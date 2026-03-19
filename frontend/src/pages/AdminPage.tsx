/**
 * File: frontend/src/pages/AdminPage.tsx
 * Astoria v2 — Admin panel for document ingestion.
 * Password-protected. Supports file upload, URL ingest,
 * and town web scraping. Admin only.
 */

import { useState } from "react";

const ALLOWED_TOWNS = ["Blue Hill", "Sullivan", "Milbridge", "Machias"];

interface IngestResult {
  status: string;
  document_id?: string;
  title?: string;
  chunks_created?: number;
  message?: string;
  docs_loaded?: number;
  errors?: string[];
}

interface AdminPageProps {
  onLogout: () => void;
}

type Tab = "upload" | "url" | "scrape";

export default function AdminPage({ onLogout }: AdminPageProps) {
  // --- Auth ---
  const [token, setToken] = useState("");
  const [authed, setAuthed] = useState(false);
  const [authError, setAuthError] = useState("");

  // --- Tab ---
  const [tab, setTab] = useState<Tab>("upload");

  // --- Upload ---
  const [file, setFile] = useState<File | null>(null);
  const [uploadTown, setUploadTown] = useState("");
  const [uploadArchive, setUploadArchive] = useState("");

  // --- URL ---
  const [url, setUrl] = useState("");
  const [urlTown, setUrlTown] = useState("");
  const [urlArchive, setUrlArchive] = useState("");

  // --- Scrape ---
  const [scrapeTown, setScrapeTown] = useState("");
  const [scrapeAll, setScrapeAll] = useState(false);

  // --- Shared ---
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<IngestResult | null>(null);
  const [error, setError] = useState("");

  // --- Auth handler ---
  const handleAuth = async (e: React.FormEvent) => {
    e.preventDefault();
    setAuthError("");
    try {
      const res = await fetch("/api/health");
      if (!res.ok) throw new Error("Server unreachable");
      // Validate token against a protected endpoint
      const check = await fetch("/api/ingest/sources", {
        headers: { Authorization: `Bearer ${token}` },
      });
      if (check.status === 401 || check.status === 403) {
        setAuthError("Invalid token or insufficient permissions");
        return;
      }
      setAuthed(true);
    } catch {
      setAuthError("Authentication failed — check your token");
    }
  };

  // --- API helper ---
  const apiFetch = async (path: string, body: FormData) => {
    const res = await fetch(path, {
      method: "POST",
      headers: { Authorization: `Bearer ${token}` },
      body,
    });
    if (!res.ok) {
      const err = await res.json().catch(() => ({ detail: res.statusText }));
      throw new Error(err.detail || `API error ${res.status}`);
    }
    return res.json();
  };

  // --- Upload handler ---
  const handleUpload = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!file) return;
    setLoading(true); setError(""); setResult(null);
    try {
      const form = new FormData();
      form.append("file", file);
      if (uploadTown) form.append("town", uploadTown);
      if (uploadArchive) form.append("archive_name", uploadArchive);
      const data = await apiFetch("/api/ingest/upload", form);
      setResult(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Upload failed");
    } finally {
      setLoading(false);
    }
  };

  // --- URL handler ---
  const handleUrl = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!url) return;
    setLoading(true); setError(""); setResult(null);
    try {
      const form = new FormData();
      form.append("url", url);
      if (urlTown) form.append("town", urlTown);
      if (urlArchive) form.append("archive_name", urlArchive);
      const data = await apiFetch("/api/ingest/url", form);
      setResult(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "URL ingest failed");
    } finally {
      setLoading(false);
    }
  };

  // --- Scrape handler ---
  const handleScrape = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true); setError(""); setResult(null);
    try {
      const path = scrapeAll
        ? "/api/ingest/scrape-all"
        : `/api/ingest/scrape/${encodeURIComponent(scrapeTown)}`;
      const res = await fetch(path, {
        method: "POST",
        headers: { Authorization: `Bearer ${token}` },
      });
      if (!res.ok) {
        const err = await res.json().catch(() => ({ detail: res.statusText }));
        throw new Error(err.detail || `API error ${res.status}`);
      }
      const data = await res.json();
      setResult(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Scrape failed");
    } finally {
      setLoading(false);
    }
  };

  // ── Login Gate ─────────────────────────────────────────────
  if (!authed) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="bg-white rounded-lg shadow p-8 w-full max-w-md">
          <div className="text-center mb-6">
            <span className="text-4xl">⚓</span>
            <h1 className="text-2xl font-bold text-maritime-900 mt-2">
              Astoria Admin
            </h1>
            <p className="text-gray-500 text-sm mt-1">
              Document ingestion panel — admin access only
            </p>
          </div>
          <form onSubmit={handleAuth} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Admin Token
              </label>
              <input
                type="password"
                value={token}
                onChange={(e) => setToken(e.target.value)}
                placeholder="Paste your Supabase JWT token"
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-maritime-500 focus:border-transparent"
                required
              />
            </div>
            {authError && (
              <p className="text-red-600 text-sm">{authError}</p>
            )}
            <button
              type="submit"
              className="w-full py-2.5 bg-maritime-700 text-white rounded-lg font-medium hover:bg-maritime-800 transition"
            >
              Enter Admin Panel
            </button>
          </form>
        </div>
      </div>
    );
  }

  // ── Admin Panel ────────────────────────────────────────────
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Nav */}
      <nav className="bg-maritime-900 text-white px-6 py-4">
        <div className="max-w-6xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-6">
            <h1 className="text-xl font-bold tracking-wide">
              <span className="text-maritime-200">⚓</span> Astoria
              <span className="ml-2 text-xs bg-maritime-700 px-2 py-0.5 rounded">
                ADMIN
              </span>
            </h1>
            <div className="flex gap-4 text-sm">
              <a href="/" className="text-maritime-400 hover:text-white">Query</a>
              <a href="/admin" className="text-maritime-200 hover:text-white font-medium">
                Admin
              </a>
            </div>
          </div>
          <button onClick={onLogout} className="text-maritime-400 hover:text-white text-sm">
            Sign Out
          </button>
        </div>
      </nav>

      <main className="max-w-3xl mx-auto px-6 py-8">
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900">Document Ingestion</h2>
          <p className="text-gray-500 mt-1">
            Load PDF, DOCX, TXT files or scrape web sources into the knowledge base.
          </p>
        </div>

        {/* Tabs */}
        <div className="flex gap-2 mb-6 border-b border-gray-200">
          {(["upload", "url", "scrape"] as Tab[]).map((t) => (
            <button
              key={t}
              onClick={() => { setTab(t); setResult(null); setError(""); }}
              className={`px-4 py-2 text-sm font-medium capitalize border-b-2 transition -mb-px ${
                tab === t
                  ? "border-maritime-700 text-maritime-800"
                  : "border-transparent text-gray-500 hover:text-gray-700"
              }`}
            >
              {t === "upload" ? "📄 Upload File" : t === "url" ? "🔗 URL" : "🌐 Scrape Towns"}
            </button>
          ))}
        </div>

        {/* Upload Tab */}
        {tab === "upload" && (
          <form onSubmit={handleUpload} className="bg-white rounded-lg shadow p-6 space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                File <span className="text-gray-400">(PDF, DOCX, TXT)</span>
              </label>
              <input
                type="file"
                accept=".pdf,.docx,.txt"
                onChange={(e) => setFile(e.target.files?.[0] || null)}
                className="w-full text-sm text-gray-600 border border-gray-300 rounded-lg px-3 py-2"
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Town</label>
              <select
                value={uploadTown}
                onChange={(e) => setUploadTown(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
              >
                <option value="">— Select town (optional) —</option>
                {ALLOWED_TOWNS.map((t) => <option key={t}>{t}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Archive Name
              </label>
              <input
                type="text"
                value={uploadArchive}
                onChange={(e) => setUploadArchive(e.target.value)}
                placeholder="e.g. Maine Memory Network"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
              />
            </div>
            <button
              type="submit"
              disabled={loading || !file}
              className="w-full py-2.5 bg-maritime-700 text-white rounded-lg font-medium hover:bg-maritime-800 disabled:opacity-50 transition"
            >
              {loading ? "Uploading..." : "Upload & Ingest"}
            </button>
          </form>
        )}

        {/* URL Tab */}
        {tab === "url" && (
          <form onSubmit={handleUrl} className="bg-white rounded-lg shadow p-6 space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">URL</label>
              <input
                type="url"
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                placeholder="https://en.wikipedia.org/wiki/Blue_Hill,_Maine"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
                required
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">Town</label>
              <select
                value={urlTown}
                onChange={(e) => setUrlTown(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
              >
                <option value="">— Select town (optional) —</option>
                {ALLOWED_TOWNS.map((t) => <option key={t}>{t}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Archive Name
              </label>
              <input
                type="text"
                value={urlArchive}
                onChange={(e) => setUrlArchive(e.target.value)}
                placeholder="e.g. Wikipedia"
                className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
              />
            </div>
            <button
              type="submit"
              disabled={loading || !url}
              className="w-full py-2.5 bg-maritime-700 text-white rounded-lg font-medium hover:bg-maritime-800 disabled:opacity-50 transition"
            >
              {loading ? "Fetching..." : "Fetch & Ingest"}
            </button>
          </form>
        )}

        {/* Scrape Tab */}
        {tab === "scrape" && (
          <form onSubmit={handleScrape} className="bg-white rounded-lg shadow p-6 space-y-4">
            <div className="flex items-center gap-3">
              <input
                type="checkbox"
                id="scrapeAll"
                checked={scrapeAll}
                onChange={(e) => setScrapeAll(e.target.checked)}
                className="w-4 h-4 text-maritime-700"
              />
              <label htmlFor="scrapeAll" className="text-sm font-medium text-gray-700">
                Scrape all four towns at once
              </label>
            </div>
            {!scrapeAll && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Town</label>
                <select
                  value={scrapeTown}
                  onChange={(e) => setScrapeTown(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm"
                  required={!scrapeAll}
                >
                  <option value="">— Select town —</option>
                  {ALLOWED_TOWNS.map((t) => <option key={t}>{t}</option>)}
                </select>
              </div>
            )}
            <p className="text-xs text-gray-400">
              Sources: Wikipedia API (Tier 1) → Playwright JS sites (Tier 2)
            </p>
            <button
              type="submit"
              disabled={loading || (!scrapeAll && !scrapeTown)}
              className="w-full py-2.5 bg-maritime-700 text-white rounded-lg font-medium hover:bg-maritime-800 disabled:opacity-50 transition"
            >
              {loading
                ? "Scraping..."
                : scrapeAll
                ? "Scrape All Towns"
                : `Scrape ${scrapeTown || "Town"}`}
            </button>
          </form>
        )}

        {/* Loading */}
        {loading && (
          <div className="flex items-center justify-center py-8 gap-3 text-maritime-700">
            <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
              <circle className="opacity-25" cx="12" cy="12" r="10"
                stroke="currentColor" strokeWidth="4" fill="none" />
              <path className="opacity-75" fill="currentColor"
                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
            </svg>
            <span className="text-sm font-medium">Processing — this may take a minute...</span>
          </div>
        )}

        {/* Error */}
        {error && (
          <div className="mt-4 p-4 bg-red-50 text-red-700 rounded-lg text-sm">
            {error}
          </div>
        )}

        {/* Result */}
        {result && (
          <div className="mt-4 p-4 bg-green-50 border border-green-200 rounded-lg text-sm">
            <p className="font-semibold text-green-800 mb-2">
              {result.status === "success" ? "✅ Ingested successfully" :
               result.status === "duplicate" ? "⚠️ Duplicate — already in knowledge base" :
               result.status === "completed" ? "✅ Scrape completed" :
               `Status: ${result.status}`}
            </p>
            {result.title && <p className="text-gray-700">Title: {result.title}</p>}
            {result.chunks_created !== undefined && (
              <p className="text-gray-700">Chunks created: {result.chunks_created}</p>
            )}
            {result.docs_loaded !== undefined && (
              <p className="text-gray-700">Documents loaded: {result.docs_loaded}</p>
            )}
            {result.errors && result.errors.length > 0 && (
              <div className="mt-2">
                <p className="text-red-700 font-medium">Errors:</p>
                {result.errors.map((e, i) => (
                  <p key={i} className="text-red-600 text-xs mt-1">{e}</p>
                ))}
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  );
}
// end AdminPage.tsx
