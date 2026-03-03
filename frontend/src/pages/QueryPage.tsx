/**
 * Astoria v2 — Query Console page.
 *
 * Phase 2: Full query console with sample queries, expandable answers,
 * markdown-rendered responses, SQL preview, and cited narrative.
 */

import { useState } from "react";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
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

// ── Sample Queries ──────────────────────────────────────────
const SAMPLE_QUERIES = {
  simple: [
    "How many schooners were built in Addison?",
    "What is the largest vessel by tonnage?",
    "List all vessels built before 1820",
    "Which builders constructed the most vessels?",
    "How many vessels were built per decade?",
  ],
  complex: [
    "Compare the average tonnage of schooners vs brigs",
    "What vessels were associated with the port of Jonesport?",
    "Show me the enrollment history for the ship ACARA",
    "Which ports produced the most vessels and what was their average tonnage?",
    "What captains are mentioned in the enrollment records for vessels built in Addison?",
  ],
};

// ── Markdown component classes ──────────────────────────────
const markdownComponents = {
  h1: ({ children, ...props }: any) => (
    <h1 className="text-xl font-bold text-gray-900 mt-4 mb-2" {...props}>{children}</h1>
  ),
  h2: ({ children, ...props }: any) => (
    <h2 className="text-lg font-bold text-gray-900 mt-3 mb-2" {...props}>{children}</h2>
  ),
  h3: ({ children, ...props }: any) => (
    <h3 className="text-base font-semibold text-gray-800 mt-3 mb-1" {...props}>{children}</h3>
  ),
  p: ({ children, ...props }: any) => (
    <p className="text-gray-800 leading-relaxed mb-3" {...props}>{children}</p>
  ),
  ul: ({ children, ...props }: any) => (
    <ul className="list-disc list-inside space-y-1 mb-3 text-gray-800" {...props}>{children}</ul>
  ),
  ol: ({ children, ...props }: any) => (
    <ol className="list-decimal list-inside space-y-1 mb-3 text-gray-800" {...props}>{children}</ol>
  ),
  li: ({ children, ...props }: any) => (
    <li className="leading-relaxed" {...props}>{children}</li>
  ),
  strong: ({ children, ...props }: any) => (
    <strong className="font-semibold text-gray-900" {...props}>{children}</strong>
  ),
  em: ({ children, ...props }: any) => (
    <em className="italic text-gray-700" {...props}>{children}</em>
  ),
  table: ({ children, ...props }: any) => (
    <div className="overflow-x-auto mb-4">
      <table className="min-w-full border border-gray-200 rounded-lg text-sm" {...props}>
        {children}
      </table>
    </div>
  ),
  thead: ({ children, ...props }: any) => (
    <thead className="bg-maritime-50 text-maritime-900" {...props}>{children}</thead>
  ),
  tbody: ({ children, ...props }: any) => (
    <tbody className="divide-y divide-gray-100" {...props}>{children}</tbody>
  ),
  tr: ({ children, ...props }: any) => (
    <tr className="hover:bg-gray-50" {...props}>{children}</tr>
  ),
  th: ({ children, ...props }: any) => (
    <th className="px-3 py-2 text-left font-semibold border-b border-gray-200" {...props}>{children}</th>
  ),
  td: ({ children, ...props }: any) => (
    <td className="px-3 py-2 text-gray-700" {...props}>{children}</td>
  ),
  blockquote: ({ children, ...props }: any) => (
    <blockquote className="border-l-4 border-maritime-300 pl-4 py-1 my-3 text-gray-600 italic" {...props}>
      {children}
    </blockquote>
  ),
  code: ({ inline, children, ...props }: any) =>
    inline ? (
      <code className="bg-gray-100 text-maritime-800 px-1.5 py-0.5 rounded text-sm font-mono" {...props}>
        {children}
      </code>
    ) : (
      <pre className="bg-gray-900 text-green-400 p-4 rounded-md text-sm overflow-x-auto mb-3">
        <code {...props}>{children}</code>
      </pre>
    ),
  hr: () => <hr className="my-4 border-gray-200" />,
};

export default function QueryPage() {
  const { user, signOut } = useAuth();
  const [question, setQuestion] = useState("");
  const [response, setResponse] = useState<QueryResponse | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [expanded, setExpanded] = useState(false);
  const [showSql, setShowSql] = useState(false);
  const [showSources, setShowSources] = useState(false);

  const handleQuery = async (q?: string) => {
    const queryText = q || question;
    if (!queryText.trim()) return;

    if (q) setQuestion(q);
    setLoading(true);
    setError("");
    setResponse(null);
    setExpanded(false);
    setShowSql(false);
    setShowSources(false);

    try {
      const data = await apiPost<QueryResponse>("/query", {
        question: queryText,
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

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    handleQuery();
  };

  // Split answer into summary and detail at the "---" separator
  const splitAnswer = (answer: string) => {
    // Try explicit --- separator first
    const separatorMatch = answer.match(/\n\s*---\s*\n/);
    if (separatorMatch && separatorMatch.index !== undefined) {
      const summary = answer.slice(0, separatorMatch.index).trim();
      const detail = answer.slice(separatorMatch.index + separatorMatch[0].length).trim();
      if (summary && detail) {
        return { summary, detail };
      }
    }

    // Fallback: split at first double newline (paragraph break)
    const paragraphs = answer.split(/\n\n+/);
    if (paragraphs.length >= 3) {
      // First 1-2 short paragraphs as summary
      const summaryParas = paragraphs.slice(0, paragraphs[0].length < 120 ? 2 : 1);
      const detailParas = paragraphs.slice(summaryParas.length);
      return {
        summary: summaryParas.join("\n\n").trim(),
        detail: detailParas.join("\n\n").trim(),
      };
    }

    // Final fallback: everything as summary, no expand button
    return { summary: answer, detail: "" };
  };

  const answerParts = response ? splitAnswer(response.answer) : null;

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Navigation */}
      <nav className="bg-maritime-900 text-white px-6 py-4">
        <div className="max-w-6xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-6">
            <h1 className="text-xl font-bold tracking-wide">
              <span className="text-maritime-200">⚓</span> Astoria
            </h1>
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
        <div className="mb-6">
          <h2 className="text-2xl font-bold text-gray-900">Maritime Research Assistant</h2>
          <p className="text-gray-600 mt-1">
            Ask questions about ships, voyages, ports, and maritime history of New England.
          </p>
        </div>

        {/* Query form */}
        <form onSubmit={handleSubmit} className="mb-6">
          <div className="flex gap-3">
            <input
              type="text"
              value={question}
              onChange={(e) => setQuestion(e.target.value)}
              placeholder="e.g., What ships departed from Machias in the 1850s?"
              className="flex-1 px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-maritime-500 focus:border-transparent text-lg"
            />
            <button
              type="submit"
              disabled={loading || !question.trim()}
              className="px-6 py-3 bg-maritime-700 text-white rounded-lg font-medium hover:bg-maritime-800 disabled:opacity-50 transition"
            >
              {loading ? "Searching..." : "Ask"}
            </button>
          </div>
        </form>

        {/* Sample queries — show when no response */}
        {!response && !loading && (
          <div className="mb-8 space-y-5">
            <div>
              <h3 className="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">
                Quick Lookups
              </h3>
              <div className="flex flex-wrap gap-2">
                {SAMPLE_QUERIES.simple.map((q) => (
                  <button
                    key={q}
                    onClick={() => handleQuery(q)}
                    className="px-3 py-1.5 bg-white border border-gray-200 rounded-full text-sm text-gray-700 hover:bg-maritime-50 hover:border-maritime-300 hover:text-maritime-800 transition shadow-sm"
                  >
                    {q}
                  </button>
                ))}
              </div>
            </div>
            <div>
              <h3 className="text-xs font-semibold text-gray-400 uppercase tracking-wider mb-2">
                Research Questions
              </h3>
              <div className="flex flex-wrap gap-2">
                {SAMPLE_QUERIES.complex.map((q) => (
                  <button
                    key={q}
                    onClick={() => handleQuery(q)}
                    className="px-3 py-1.5 bg-white border border-gray-200 rounded-full text-sm text-gray-700 hover:bg-maritime-50 hover:border-maritime-300 hover:text-maritime-800 transition shadow-sm"
                  >
                    {q}
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Loading indicator */}
        {loading && (
          <div className="flex items-center justify-center py-12">
            <div className="flex items-center gap-3 text-maritime-700">
              <svg className="animate-spin h-5 w-5" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none" />
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z" />
              </svg>
              <span className="text-sm font-medium">Searching maritime records...</span>
            </div>
          </div>
        )}

        {/* Error */}
        {error && (
          <div className="p-4 bg-red-50 text-red-700 rounded-lg mb-6">
            {error}
          </div>
        )}

        {/* Response */}
        {response && answerParts && (
          <div className="space-y-4">
            {/* Summary answer — rendered as markdown */}
            <div className="bg-white rounded-lg shadow p-6">
              <div className="prose-maritime">
                <ReactMarkdown remarkPlugins={[remarkGfm]} components={markdownComponents}>
                  {answerParts.summary}
                </ReactMarkdown>
              </div>

              {/* Expandable detail — also rendered as markdown */}
              {answerParts.detail && (
                <>
                  {expanded && (
                    <div className="mt-4 pt-4 border-t border-gray-100 prose-maritime">
                      <ReactMarkdown remarkPlugins={[remarkGfm]} components={markdownComponents}>
                        {answerParts.detail}
                      </ReactMarkdown>
                    </div>
                  )}
                  <button
                    onClick={() => setExpanded(!expanded)}
                    className="mt-3 text-sm text-maritime-600 hover:text-maritime-800 font-medium flex items-center gap-1"
                  >
                    {expanded ? (
                      <>
                        <span>Show less</span>
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 15l7-7 7 7" />
                        </svg>
                      </>
                    ) : (
                      <>
                        <span>Read full analysis</span>
                        <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                        </svg>
                      </>
                    )}
                  </button>
                </>
              )}

              {/* Metadata bar */}
              <div className="mt-4 pt-3 border-t border-gray-100 flex flex-wrap gap-4 text-xs text-gray-400">
                <span className="capitalize">{response.complexity} query</span>
                <span>{response.model_used}</span>
                <span>{response.processing_time_ms}ms</span>
                {response.sql_generated && (
                  <button
                    onClick={() => setShowSql(!showSql)}
                    className="text-maritime-500 hover:text-maritime-700 font-medium"
                  >
                    {showSql ? "Hide SQL" : "View SQL"}
                  </button>
                )}
                {response.sources.length > 0 && (
                  <button
                    onClick={() => setShowSources(!showSources)}
                    className="text-maritime-500 hover:text-maritime-700 font-medium"
                  >
                    {showSources ? "Hide sources" : `View ${response.sources.length} sources`}
                  </button>
                )}
              </div>
            </div>

            {/* SQL — collapsible */}
            {showSql && response.sql_generated && (
              <div className="bg-white rounded-lg shadow p-6">
                <h3 className="text-sm font-medium text-gray-500 mb-2">
                  Generated SQL
                </h3>
                <pre className="bg-gray-900 text-green-400 p-4 rounded-md text-sm overflow-x-auto">
                  {response.sql_generated}
                </pre>
              </div>
            )}

            {/* Sources — collapsible */}
            {showSources && response.sources.length > 0 && (
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
                      <p className="text-sm text-gray-600 mt-1 line-clamp-3">
                        {source.chunk_text}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            )}

            {/* Ask another question */}
            <div className="text-center pt-2">
              <button
                onClick={() => {
                  setResponse(null);
                  setQuestion("");
                  setExpanded(false);
                  setShowSql(false);
                  setShowSources(false);
                }}
                className="text-sm text-gray-500 hover:text-maritime-700 font-medium"
              >
                Ask another question
              </button>
            </div>
          </div>
        )}
      </main>
    </div>
  );
}
