/**
 * File: frontend/src/App.tsx
 * Astoria v2 — App root with guest auth and admin route.
 */

import { useState, useEffect } from "react";
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
  const isAdmin = window.location.pathname === "/admin";

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

  // Admin route — standalone, own auth
  if (isAdmin) {
    return <AdminPage onLogout={handleLogout} />;
  }

  if (!guest) {
    return <LoginPage onLogin={handleLogin} />;
  }

  return <QueryPage guest={guest} onLogout={handleLogout} />;
}
// end App.tsx
