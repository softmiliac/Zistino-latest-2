import { FC, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { useTranslation } from "react-i18next";
import { Radio } from "antd";

import {
  post,
  Button,
  Input,
  PasswordInput,
  errorAlert,
  TENANTS,
  useAuth,
} from "../../";

const Login: FC = () => {
  const [loading, setLoading] = useState<boolean>(false);
  const [tenant, setTenant] = useState(TENANTS[0].value);
  const { login } = useAuth();
  const navigate = useNavigate();
  const token = localStorage.getItem("token_zistino");
  const { t } = useTranslation();

  useEffect(() => {
    if (token) {
      navigate("/");
    }
    return () => console.info("loggedIn");
  }, []);

  const handleSubmit = async (e: any) => {
    e.preventDefault();

    setLoading(true);

    const form = new FormData(e.target);
    const formData = Object.fromEntries(form.entries());

    try {
      const { data: res } = await post("/tokens/", formData, {
        headers: {
          tenant,
        },
      });
      login(res.data.token);
    } catch (err) {
      console.info(err);
      errorAlert({ title: t("wrong_username_or_password") });
    }
    setLoading(false);
  };

  return (
    <div className="h-screen w-screen flex items-center justify-center">
      <div className="dark:bg-secondary-dark-100 bg-secondary-light-100 p-8 rounded-xl w-5/6 md:w-[400px]">
        <h2 className="text-2xl font-semibold rtl:font-rtl-semibold mb-5">
          {t("login_title")}
        </h2>
        <form onSubmit={handleSubmit}>
          <div className="space-y-5">
            <Input dir="ltr" label={t("username")} name="email" required />
            <PasswordInput
              dir="ltr"
              label={t("password")}
              name="password"
              required
            />
          </div>
          <Radio.Group
            onChange={(e) => setTenant(e.target.value)}
            size="small"
            defaultValue={tenant}
            className="text-center w-full pt-3"
          >
            {TENANTS.map(({ title, value }) => (
              <Radio.Button
                key={value}
                className="dark:bg-[#2b2e36] dark:text-[#fff] !p-2 !mt-2 !h-fit"
                value={value}
              >
                {title}
              </Radio.Button>
            ))}
          </Radio.Group>
          <Button className="btn-block mt-8" loading={loading}>
            {t("login_btn")}
          </Button>
        </form>
      </div>
    </div>
  );
};

export default Login;
