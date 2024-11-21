import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { User } from '@/types/auth';

interface AuthState {
  user: User | null;
  token: string | null;
  setAuth: (response: { user: User; token: string }) => void;
  logout: () => void;
  isAuthenticated: () => boolean;
}

const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      setAuth: (response) => {
        console.log('[Auth] Setting auth state:', { user: response.user });
        set({ 
          user: response.user,
          token: response.token 
        });
      },
      logout: () => {
        console.log('[Auth] Logging out user');
        set({ user: null, token: null });
      },
      isAuthenticated: () => {
        const state = get();
        return !!(state.token && state.user);
      },
    }),
    {
      name: 'auth-storage',
    }
  )
);

export default useAuthStore;
