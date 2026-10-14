/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        brand: {
          50: '#f5f3ff',
          100: '#ede9fe',
          200: '#ddd6fe',
          300: '#c4b5fd',
          400: '#a78bfa',
          500: '#8b5cf6',
          600: '#7c3aed',
          700: '#6d28d9',
          800: '#5b21b6',
          900: '#4c1d95',
          950: '#2e1065',
        },
        lavender: {
          50: '#f8f7ff',
          100: '#f0eeff',
          200: '#e4e0ff',
          300: '#d1c7ff',
          400: '#b4a2ff',
          500: '#9575ff',
          600: '#7947f7',
        },
        indigoaccent: {
          50: '#eef2ff',
          100: '#e0e7ff',
          500: '#6366f1',
          600: '#4f46e5',
          700: '#4338ca',
        }
      },
      fontFamily: {
        sans: ['Plus Jakarta Sans', 'Inter', 'system-ui', 'sans-serif'],
      },
      boxShadow: {
        'soft': '0 4px 20px -2px rgba(109, 40, 217, 0.06), 0 2px 6px -1px rgba(0, 0, 0, 0.04)',
        'soft-lg': '0 10px 25px -3px rgba(109, 40, 217, 0.1), 0 4px 10px -2px rgba(0, 0, 0, 0.05)',
        'glow': '0 0 25px rgba(124, 58, 237, 0.25)',
      }
    },
  },
  plugins: [],
}
