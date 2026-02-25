/**
 * Astoria v2 — Query Console page.
 *
 * Phase 1: Basic form that calls the placeholder endpoint.
 * Phase 2: Full query console with SQL preview, data table, and cited narrative.
 */

import { useState } from "react";
import { apiPost } from "../lib/api";
import { useAuth } from "../hooks/useAuth";

interface QueryResponse {
  answer: string;
  sql_generated: string | null;
  sources: Array<{ document_title: string; chunk_text: string }>;
  complexity: string;
  model_used: string;
  processing_time_ms: number;
}

export default function QueryPage() {
  const { user, signOut } = useAuth();
  const [question, setQuestion] = useState("");
  const [response, setResponse] = useState<QueryResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleQuery = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!question.trim()) return;

    setLoading(true);
    setError("");
    setResponse(null);

    try {
      const data = await apiPost<QueryResponse>("/query", {
        question,
        include_sql: true,
        include_sources: true,
      });
      setResponse(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Query failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Navigation */}
      <nav className="bg-maritime-900 text-white px-6 py-4">
        <div className="max-w-6xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-6">
            <h1 className="text-xl font-bold">Astoria</h1>
            <div className="flex gap-4 text-sm">
              <a href="/" className="text-maritime-200 hover:text-white font-medium">
                Query
              </a>
              <a href="/explore" className="text-maritime-400 hover:text-white">
                Explore
              </a>
              <a href="/sources" className="text-maritime-400 hover:text-white">
                Sources
              </a>
            </div>
          </div>
          <div className="flex items-center gap-4 text-sm">
            <span className="text-maritime-300">{user?.email}</span>
            <button
              onClick={signOut}
              className="text-maritime-400 hover:text-white"
            >
              Sign Out
            </button>
          </div>
        </div>
      </nav>

      {/* Main content */}
      <main className="max-w-4xl mx-auto px-6 py-8">
        <div className="mb-8">
          <h2 className="text-2xl font-bold text-gray-900">Query Console</h2>
          <p className="text-gray-600 mt-1">
            Ask questions about maritime history in natural language.
          </p>
        </div>

        {/* Query form */}
        <form onSubmit={handleQuery} className="mb-8">
          <div className="flex gap-3">
            <input
              type="text"
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              placeholder="e.g., What ships departed from Portland in 1850?"
              className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-maritime-500 focus:border-transparent text-lg"
            />
            <button
              type="submit"
              disabled={loading || !question.trim()}
              className="px-6 py-3 bg-maritime-700 text-white rounded-lg font-medium hover:bg-maritime-800 disabled:opacity-50 transition"
            >
              {loading ? "Querying..." : "Ask"}
            </button>
          </div>
        </form>

        {/* Error */}
        {error && (
          <div className="p-4 bg-red-50 text-red-700 rounded-lg mb-6">
            {error}
          </div>
        )}

        {/* Response */}
        {response && (
          <div className="space-y-6">
            {/* Answer */}
            <div className="bg-white rounded-lg shadow p-6">
              <h3 className="text-sm font-medium text-gray-500 mb-2">
                Answer
              </h3>
              <p className="text-gray-900 leading-relaxed">{response.answer}</p>
              <div className="mt-4 flex gap-4 text-xs text-gray-400">
                <span>Complexity: {response.complexity}</span>
                <span>Model: {response.model_used}</span>
                <span>{response.processing_time_ms}ms</span>
              </div>
            </div>

            {/* SQL */}
            {response.sql_generated && (
              <div className="bg-white rounded-lg shadow p-6">
                <h3 className="text-sm font-medium text-gray-500 mb-2">
                  Generated SQL
                </h3>
                <pre className="bg-gray-900 text-green-400 p-4 rounded-md text-sm overflow-x-auto">
                  {response.sql_generated}
                </pre>
              </div>
            )}

            {/* Sources */}
            {response.sources.length > 0 && (
              <div className="bg-white rounded-lg shadow p-6">
                <h3 className="text-sm font-medium text-gray-500 mb-3">
                  Sources ({response.sources.length})
                </h3>
                <div className="space-y-3">
                  {response.sources.map((source, i) => (
                    <div
                      key={i}
                      className="p-3 bg-gray-50 rounded-md border-l-4 border-maritime-400"
                    >
                      <p className="font-medium text-sm text-maritime-800">
                        {source.document_title}
                      </p>
                      <p className="text-sm text-gray-600 mt-1">
                        {source.chunk_text}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  );
}
