export interface User {
    id: number;
    name: string;
    email: string;
    email_verified_at: string | null;
    created_at: string;
    updated_at: string;
  }
  
  export interface AuthResponse {
    user: User;
    token: string;
  }

  // src/types/auth.ts
export interface SignUpPayload {
    name: string;
    email: string;
    password: string;
    password_confirmation: string;
  }