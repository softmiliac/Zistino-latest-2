import { FC, useEffect } from "react";
import { Outlet, useLocation, useNavigate } from "react-router-dom";
import { Line } from "react-chartjs-2";
import { CategoryScale } from "chart.js";
import Chart from "chart.js/auto";
import { useTranslation } from "react-i18next";

Chart.register(CategoryScale);

const Dashboard: FC = () => {
  const { pathname } = useLocation();

  const navigate = useNavigate();

  useEffect(() => {
    if (pathname === "/") navigate("/collection-request");
  }, []);

  if (pathname === "/") {
    return <></>;
  } else {
    return <Outlet />;
  }
};
export default Dashboard;
