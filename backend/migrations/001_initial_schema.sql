-- Astoria v2 — Initial Database Schema
-- Run this in your Supabase SQL Editor after creating the project.
--
-- This migration creates the tables needed for the v2 architecture:
--   1. documents         — source document metadata and provenance
--   2. document_chunks   — embedded chunks with vectors (pgvector)
--   3. query_log         — query analytics and monitoring
--   4. user_profiles     — extends Supabase auth.users with app-specific data
--
-- Prerequisites:
--   - pgvector extension enabled (Supabase enables this by default)
--   - Supabase Auth configured

-- ============================================================
-- Enable extensions
-- ============================================================

CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;  -- for text search

-- ============================================================
-- 1. Source Documents
-- ============================================================

CREATE TABLE IF NOT EXISTS documents (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title           TEXT NOT NULL,
    source_url      TEXT,
    archive_name    TEXT,
    content_type    TEXT DEFAULT 'text',  -- 'text', 'pdf', 'html', 'csv'
    raw_content     TEXT,                 -- original text (for re-processing)
    checksum        TEXT NOT NULL,        -- SHA-256 of raw content (deduplication)
    metadata        JSONB DEFAULT '{}',   -- flexible metadata (dates, ship names, etc.)
    ingested_at     TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW(),
    ingested_by     UUID REFERENCES auth.users(id),

    -- Deduplication: no two documents with the same content
    CONSTRAINT documents_checksum_unique UNIQUE (checksum)
);

CREATE INDEX idx_documents_archive ON documents(archive_name);
CREATE INDEX idx_documents_ingested_at ON documents(ingested_at DESC);
CREATE INDEX idx_documents_metadata ON documents USING GIN(metadata);
CREATE INDEX idx_documents_title_trgm ON documents USING GIN(title gin_trgm_ops);

-- ============================================================
-- 2. Document Chunks (with vector embeddings)
-- ============================================================

CREATE TABLE IF NOT EXISTS document_chunks (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id     UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    chunk_index     INTEGER NOT NULL,     -- position within document (0-based)
    content         TEXT NOT NULL,         -- chunk text
    embedding       vector(1024),         -- E5-large-v2 produces 1024-dim vectors
    metadata        JSONB DEFAULT '{}',   -- chunk-level metadata (ship names, dates, coordinates)
    token_count     INTEGER,
    created_at      TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT chunks_document_index_unique UNIQUE (document_id, chunk_index)
);

-- Vector similarity search index (IVFFlat for good performance at moderate scale)
-- Re-create with more lists if you exceed ~100k chunks
CREATE INDEX idx_chunks_embedding ON document_chunks
    USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 100);

CREATE INDEX idx_chunks_document_id ON document_chunks(document_id);
CREATE INDEX idx_chunks_metadata ON document_chunks USING GIN(metadata);

-- ============================================================
-- 3. Query Log (analytics and monitoring)
-- ============================================================

CREATE TABLE IF NOT EXISTS query_log (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID REFERENCES auth.users(id),
    question        TEXT NOT NULL,
    complexity      TEXT,                 -- 'simple', 'complex', 'research'
    model_used      TEXT,
    sql_generated   TEXT,
    answer          TEXT,
    sources_used    JSONB DEFAULT '[]',   -- array of document_chunk IDs
    processing_ms   INTEGER,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_query_log_user ON query_log(user_id);
CREATE INDEX idx_query_log_created ON query_log(created_at DESC);

-- ============================================================
-- 4. User Profiles (extends Supabase Auth)
-- ============================================================

CREATE TABLE IF NOT EXISTS user_profiles (
    id              UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    display_name    TEXT,
    institution     TEXT,
    role            TEXT DEFAULT 'researcher',  -- 'researcher' | 'admin'
    query_count     INTEGER DEFAULT 0,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Auto-create profile when a new user signs up
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.user_profiles (id, display_name, role)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
        COALESCE(NEW.raw_user_meta_data->>'role', 'researcher')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- 5. Row-Level Security Policies
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_chunks ENABLE ROW LEVEL SECURITY;
ALTER TABLE query_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Documents: all authenticated users can read
CREATE POLICY "documents_read_all" ON documents
    FOR SELECT TO authenticated USING (true);

-- Documents: only admins can insert/update/delete
CREATE POLICY "documents_admin_write" ON documents
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Chunks: all authenticated users can read
CREATE POLICY "chunks_read_all" ON document_chunks
    FOR SELECT TO authenticated USING (true);

-- Chunks: only admins can write
CREATE POLICY "chunks_admin_write" ON document_chunks
    FOR ALL TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Query log: users can read their own queries
CREATE POLICY "query_log_read_own" ON query_log
    FOR SELECT TO authenticated
    USING (user_id = auth.uid());

-- Query log: users can insert their own queries
CREATE POLICY "query_log_insert_own" ON query_log
    FOR INSERT TO authenticated
    WITH CHECK (user_id = auth.uid());

-- Query log: admins can read all queries
CREATE POLICY "query_log_admin_read" ON query_log
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- User profiles: users can read their own profile
CREATE POLICY "profiles_read_own" ON user_profiles
    FOR SELECT TO authenticated
    USING (id = auth.uid());

-- User profiles: users can update their own profile (except role)
CREATE POLICY "profiles_update_own" ON user_profiles
    FOR UPDATE TO authenticated
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

-- User profiles: admins can read all profiles
CREATE POLICY "profiles_admin_read" ON user_profiles
    FOR SELECT TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM user_profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- ============================================================
-- 6. Helper Functions
-- ============================================================

-- Semantic search function (used by the RAG pipeline)
CREATE OR REPLACE FUNCTION match_chunks(
    query_embedding vector(1024),
    match_threshold float DEFAULT 0.7,
    match_count int DEFAULT 10
)
RETURNS TABLE (
    id UUID,
    document_id UUID,
    content TEXT,
    metadata JSONB,
    similarity float
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        dc.id,
        dc.document_id,
        dc.content,
        dc.metadata,
        1 - (dc.embedding <=> query_embedding) AS similarity
    FROM document_chunks dc
    WHERE 1 - (dc.embedding <=> query_embedding) > match_threshold
    ORDER BY dc.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- Updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER documents_updated_at
    BEFORE UPDATE ON documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER profiles_updated_at
    BEFORE UPDATE ON user_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();
