import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/pages/**/*.{js,ts,jsx,tsx,mdx}", "./src/components/**/*.{js,ts,jsx,tsx,mdx}", "./src/app/**/*.{js,ts,jsx,tsx,mdx}"],
  theme: {
    extend: {
      colors: {
        canvas: "#f4f6ef",
        ink: "#1a2a2f",
        accent: "#0f766e",
        ember: "#f97316"
      },
      boxShadow: {
        panel: "0 14px 38px rgba(26,42,47,0.12)"
      }
    }
  },
  plugins: []
};

export default config;
