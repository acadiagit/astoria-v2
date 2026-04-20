/**
 * File: frontend/src/App.tsx
 * Astoria v2 — App root with React Router for client-side routing.
 */

import { useState, useEffect } from "react";
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import LoginPage from "./pages/LoginPage";
import QueryPage from "./pages/QueryPage";
import AdminPage from "./pages/AdminPage";

export interface GuestUser {
  name: string;
  affiliation: string;
  loginAt: string;
}

export default function App() {
  const [guest, setGuest] = useState<GuestUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const stored = localStorage.getItem("astoria_guest");
    if (stored) {
      try {
        setGuest(JSON.parse(stored));
      } catch {
        localStorage.removeItem("astoria_guest");
      }
    }
    setLoading(false);
  }, []);

  const handleLogin = (name: string, affiliation: string) => {
    const user: GuestUser = {
      name,
      affiliation,
      loginAt: new Date().toISOString(),
    };
    localStorage.setItem("astoria_guest", JSON.stringify(user));
    setGuest(user);
  };

  const handleLogout = () => {
    localStorage.removeItem("astoria_guest");
    setGuest(null);
  };

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-maritime-50">
        <div className="text-maritime-600 text-lg">Loading...</div>
      </div>
    );
  }

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/admin" element={<AdminPage onLogout={handleLogout} />} />
        <Route
          path="/"
          element={
            guest
              ? <QueryPage guest={guest} onLogout={handleLogout} />
              : <LoginPage onLogin={handleLogin} />
          }
        />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
}
// end App.tsx
