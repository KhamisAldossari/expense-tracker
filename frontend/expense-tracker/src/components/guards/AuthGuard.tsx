import { Navigate, Outlet, useLocation } from "react-router-dom";
import useAuthStore from "@/stores/authStore";

const AuthGuard = () => {
  const isAuthenticated = useAuthStore(state => state.isAuthenticated());
  const location = useLocation();

  if (!isAuthenticated) {
    // Redirect to login with the return url
    return <Navigate to="/" state={{ from: location }} replace />;
  }

  return <Outlet />;
};

export default AuthGuard;
