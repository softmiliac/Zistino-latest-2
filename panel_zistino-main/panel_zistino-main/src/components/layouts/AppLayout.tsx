import { FC } from "react";
import { useLocation } from "react-router-dom";
import { AuthLayout, MainLayout } from "./";

export const AppLayout = ({ children }: { children: any }) => {
  const { pathname } = useLocation();

  if (pathname === "/login") {
    return <AuthLayout>{children}</AuthLayout>;
  } else {
    return <MainLayout>{children}</MainLayout>;
  }
};
