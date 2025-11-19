import { useEffect, useState } from "react";

interface IUseDarkMode {
  theme: string;
  toggle: () => void;
}

export const useDarkMode = (): IUseDarkMode => {
  const [theme, setTheme] = useState("light");

  const toggle = () => {
    if (theme === "light") {
      window.localStorage.setItem("app-theme", "dark");
      setTheme("dark");
      document.querySelector("html")?.classList.add("dark");
    } else {
      window.localStorage.setItem("app-theme", "light");
      setTheme("light");
      document.querySelector("html")?.classList.remove("dark");
    }
  };

  useEffect(() => {
    const localTheme = window.localStorage.getItem("app-theme");
    if (localTheme) {
      setTheme(localTheme);
    }
    if (localTheme === "dark") {
      document.querySelector("html")?.classList.add("dark");
    } else {
      document.querySelector("html")?.classList.remove("dark");
    }
  }, []);

  return {
    theme,
    toggle,
  };
};
