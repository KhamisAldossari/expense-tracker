import { axiosInstance } from '@/lib/axios';
import { SignUpPayload } from '@/types/auth';

export const loginService = async (email: string, password: string) => {
  try {
    console.log('[Auth] Attempting login for:', email);
    const { data } = await axiosInstance.post('/login', { 
      email, 
      password 
    });
    console.log('[Auth] Login successful for:', data.user.email);
    return data;
  } catch (error) {
    console.error('[Auth] Login failed:', error);
    throw error;
  }
};

export const signUpService = async (payload: SignUpPayload) => {
  try {
    console.log('[Auth] Attempting signup for:', payload.email);
    const { data } = await axiosInstance.post('/register', payload);
    console.log('[Auth] Signup successful for:', data.user.email);
    return data;
  } catch (error) {
    console.error('[Auth] Signup failed:', error);
    throw error;
  }
};