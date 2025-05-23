import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig({
  plugins: [
    vue({
      template: {
        compilerOptions: {
         
          isCustomElement: tag => tag.startsWith('ion-')
        }
      }
    })
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src')
    }
  },
  server: {
    proxy: {
      "/api": {
        target: "http://127.0.0.1:8000",
        changeOrigin: true,
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json"
        }
      }
    }
  }
});
