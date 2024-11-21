import { useState } from "react";
import { loginService } from "@/services/authService";
import { useNavigate } from "react-router-dom";
import useAuthStore from "@/stores/authStore";
import { User, Lock, AlertCircle } from 'lucide-react';
import { AuthResponse } from "@/types/auth";

const Login = () => {
  const [credentials, setCredentials] = useState({ email: "", password: "" });
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const navigate = useNavigate();
  const setAuth = useAuthStore(state => state.setAuth);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setCredentials(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    setError(null);
    
    try {
      const response = await loginService(credentials.email, credentials.password);
      console.log('[Login] Login successful:', response);
      setAuth(response);
      navigate("/expenses");
    } catch (err: any) {
      console.error('[Login] Login failed:', err);
      setError(err.response?.data?.message || "Failed to login. Please check your credentials.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="login-container">
      <form onSubmit={handleSubmit} className="login-form">
        <div className="input-group">
          <User className="icon" />
          <input
            type="email"
            name="email"
            value={credentials.email}
            onChange={handleChange}
            placeholder="Email"
            required
            disabled={isLoading}
          />
        </div>
        <div className="input-group">
          <Lock className="icon" />
          <input
            type="password"
            name="password"
            value={credentials.password}
            onChange={handleChange}
            placeholder="Password"
            required
            disabled={isLoading}
          />
        </div>
        {error && (
          <div className="error-message">
            <AlertCircle className="icon" />
            <span>{error}</span>
          </div>
        )}
        <button 
          type="submit" 
          className="login-button"
          disabled={isLoading}
        >
          {isLoading ? 'Logging in...' : 'Login'}
        </button>
        <button 
          type="button" 
          className="signup-button" 
          onClick={() => navigate("/signup")}
          disabled={isLoading}
        >
          Sign Up
        </button>
      </form>
    </div>
  );
};

export default Login;
