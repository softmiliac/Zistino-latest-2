/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  mode: "jit",
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        primary: "#76AD00",
        "secondary-dark-100": "#32363f",
        "secondary-dark-200": "#2b2e36",
        "secondary-light-100": "#ffffff",
        "secondary-light-200": "#f5f8fa",
      },
      fontFamily: {
        // ltr
        regular: "Poppins-Regular",
        medium: "Poppins-Medium",
        semibold: "Poppins-SemiBold",
        bold: "Poppins-Bold",
        black: "Poppins-Black",
        // rtl
        "rtl-regular": "Peyda-SemiBold",
        "rtl-medium": "Peyda-SemiBold",
        "rtl-semibold": "Peyda-Bold",
        "rtl-bold": "Peyda-Extrabold",
        "rtl-black": "Peyda-Black",
      },
      boxShadow: {
        "input-dark":
          "rgb(61, 68, 81) 0px 0px 0px 2px, rgba(235, 236, 240, 0.2) 0px 0px 0px 4px",
        "input-light":
          "rgba(0, 0, 0, 0.05) 0px 0px 0px 2px, rgba(0, 0, 0, 0.05) 0px 0px 0px 4px",
      },
    },
  },
  plugins: [require("daisyui"), require("tailwindcss-rtl")],

  daisyui: {
    base: false,
  },
};
