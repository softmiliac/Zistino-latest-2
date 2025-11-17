import { Navigate } from "react-router-dom";

export const AuthGuard = ({ children }: { children: any }) => {
  const token = localStorage.getItem("token_zistino");

  if (!token) {
    return <Navigate to="/login" />;
  }

  return <>{children}</>;
};
