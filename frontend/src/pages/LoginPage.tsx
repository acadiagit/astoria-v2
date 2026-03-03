/**
 * Astoria v2 — Guest login page (demo mode).
 *
 * Simple name entry — no email/password required.
 * Stores guest info in localStorage for session persistence.
 */

import { useState } from "react";

interface GuestLoginProps {
  onLogin: (name: string, affiliation: string) => void;
}

export default function LoginPage({ onLogin }: GuestLoginProps) {
  const [name, setName] = useState("");
  const [affiliation, setAffiliation] = useState("");

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!name.trim()) return;
    onLogin(name.trim(), affiliation.trim());
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-maritime-50">
      <div className="max-w-md w-full bg-white rounded-lg shadow-lg p-8">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-maritime-900">
            <span className="text-maritime-400">⚓</span> Astoria
          </h1>
          <p className="text-maritime-600 mt-2">
            Maritime History Research Platform
          </p>
          <p className="text-gray-500 text-sm mt-1">
            New England Maritime Records — Machias Customs District
          </p>
        </div>

        {/* Form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Your Name
            </label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              required
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-maritime-500 focus:border-transparent"
              placeholder="e.g., Jane Smith"
              autoFocus
            />
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Affiliation <span className="text-gray-400">(optional)</span>
            </label>
            <input
              type="text"
              value={affiliation}
              onChange={(e) => setAffiliation(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-maritime-500 focus:border-transparent"
              placeholder="e.g., Bates College, Independent Researcher"
            />
          </div>

          <button
            type="submit"
            disabled={!name.trim()}
            className="w-full py-2 px-4 bg-maritime-700 text-white rounded-md font-medium hover:bg-maritime-800 disabled:opacity-50 transition"
          >
            Enter as Guest
          </button>

          <p className="text-xs text-gray-400 text-center mt-2">
            Demo version — no account required
          </p>
        </form>
      </div>
    </div>
  );
}
