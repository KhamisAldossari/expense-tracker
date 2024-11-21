import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from "path"


// https://vite.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,         // Specifies the port for the development server
  },
  build: {
    outDir: 'dist',     // Specifies the output directory for the build
    sourcemap: true,    // Generates source maps for easier debugging
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
})

