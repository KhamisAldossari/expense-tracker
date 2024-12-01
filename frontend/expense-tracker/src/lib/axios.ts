import axios from 'axios';
import useAuthStore from '@/stores/authStore';

const BASE_URL = 'http://localhost:8576/api';

export const axiosInstance = axios.create({
  baseURL: BASE_URL,
  timeout: 10000,
});

// Request interceptor for API calls
axiosInstance.interceptors.request.use(
    (config) => {
      const token = useAuthStore.getState().token;
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      console.error('[API Request Error]:', error);
      return Promise.reject(error);
    }
  );
  
  // Response interceptor for API calls
  axiosInstance.interceptors.response.use(
    (response) => response,
    async (error) => {
      const originalRequest = error.config;
      
      if (error.response?.status === 401 && !originalRequest._retry) {
        originalRequest._retry = true;
        useAuthStore.getState().logout();
        window.location.href = '/login';
      }
      
      console.error('[API Response Error]:', {
        url: originalRequest.url,
        method: originalRequest.method,
        status: error.response?.status,
        message: error.message,
      });
      
      return Promise.reject(error);
    }
  );