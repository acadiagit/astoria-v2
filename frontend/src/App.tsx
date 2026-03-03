/**
 * Astoria v2 — App root with lightweight guest auth for demo.
 */

import { useState, useEffect } from "react";
import LoginPage from "./pages/LoginPage";
import QueryPage from "./pages/QueryPage";

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

  if (!guest) {
    return <LoginPage onLogin={handleLogin} />;
  }

  return <QueryPage guest={guest} onLogout={handleLogout} />;
}
