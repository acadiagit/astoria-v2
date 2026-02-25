/**
 * Astoria v2 — App root with auth-gated routing.
 */

import { useAuth } from "./hooks/useAuth";
import LoginPage from "./pages/LoginPage";
import QueryPage from "./pages/QueryPage";

export default function App() {
  const { isAuthenticated, loading } = useAuth();

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-maritime-50">
        <div className="text-maritime-600 text-lg">Loading...</div>
      </div>
    );
  }

  if (!isAuthenticated) {
    return <LoginPage />;
  }

  // Phase 4 will add React Router for /explore, /sources, /admin
  return <QueryPage />;
}
