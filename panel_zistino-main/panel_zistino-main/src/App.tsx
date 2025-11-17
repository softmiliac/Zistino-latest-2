import { FC, useEffect, Suspense } from "react";
import { useRoutes } from "react-router-dom";
import i18n from "i18next";
import { initReactI18next, useTranslation } from "react-i18next";
import LanguageDetector from "i18next-browser-languagedetector";

import { Loading, useDarkMode, AuthProvider, routes, AppLayout } from "./";

import "./assets/styles/editor.css";
import "./assets/styles/custom.css";
import "./assets/styles/table.css";

import en from "./assets/locales/en/translation.json";
import fa from "./assets/locales/fa/translation.json";
import "antd/dist/antd.css";
import { QueryClient, QueryClientProvider } from "react-query";

i18n
  .use(initReactI18next)
  .use(LanguageDetector)
  .init({
    resources: {
      en: {
        translation: en,
      },
      fa: {
        translation: fa,
      },
    },
    lng: "fa",
    fallbackLng: "fa",
    interpolation: {
      escapeValue: false,
    },
    detection: {
      order: ["localStorage"],
      caches: ["localStorage"],
      htmlTag: document.documentElement,
    },
  });

const twentyFourHoursInMs = 1000 * 60 * 60 * 24;
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      refetchOnWindowFocus: false,
      refetchOnReconnect: false,
      retry: false,
      staleTime: twentyFourHoursInMs,
    },
  },
});

const App: FC = () => {
  const { i18n } = useTranslation();

  useDarkMode();
  const content = useRoutes(routes);

  useEffect(() => {
    if (i18n.language == "fa") {
      document.body.setAttribute("dir", "rtl");
    } else {
      document.body.setAttribute("dir", "ltr");
    }
  }, [i18n.language]);

  return (
    <AppLayout>
      <AuthProvider>
        <QueryClientProvider client={queryClient}>
          <Suspense fallback={<Loading />}>{content}</Suspense>
        </QueryClientProvider>
      </AuthProvider>
    </AppLayout>
  );
};

export default App;
