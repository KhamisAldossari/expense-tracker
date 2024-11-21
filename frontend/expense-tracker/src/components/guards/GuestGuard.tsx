import { Navigate, Outlet } from "react-router-dom";
import useAuthStore from "@/stores/authStore";

const GuestGuard = () => {
  const isAuthenticated = useAuthStore(state => state.isAuthenticated());

  if (isAuthenticated) {
    // Redirect authenticated users to expenses page
    return <Navigate to="/expenses" replace />;
  }

  return <Outlet />;
};

export default GuestGuard;