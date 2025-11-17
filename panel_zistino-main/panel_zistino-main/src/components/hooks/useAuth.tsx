import React, { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { infoAlert, post } from "../../";

type Provider = {
  children: JSX.Element | JSX.Element[];
};

export const AuthContext = React.createContext({});

export const AuthProvider = ({ children }: Provider) => {
  const user = useProvideAuth();
  return <AuthContext.Provider value={user}>{children}</AuthContext.Provider>;
};

const useProvideAuth = () => {
  const [token, setToken] = useState<string | null>(null);
  let navigate = useNavigate();
  useEffect(() => {
    if (token) {
    }
  }, [token]);
  useEffect(() => {
    if (localStorage.getItem("token_zistino")) {
      (async () => {
        try {
          const xtoken = await localStorage.getItem("token_zistino");
          await post(
            "/identity/verify",
            {},
            {
              headers: { Authorization: `Bearer ${xtoken}` },
            }
          );
          setToken(xtoken);
        } catch (err) {
          alert(err);
          localStorage.removeItem("token_zistino");
          window.location.href = "/login";
        }
      })();
    }
    const localToken = localStorage.getItem("token_zistino");
    setToken(localToken);
  }, []);

  const login = async (token: string) => {
    if (!token) return;
    localStorage.setItem("token_zistino", token);
    setToken(token);
    window.location.assign("/");
  };

  const logout = () => {
    if (!token) return;
    localStorage.removeItem("token_zistino");
    setToken(null);
    window.location.assign("/login");
  };

  return {
    token,
    login,
    logout,
  };
};

export const useAuth = (): any => useContext(AuthContext);
