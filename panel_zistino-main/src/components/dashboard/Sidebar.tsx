import { FC } from "react";
import { useTranslation } from "react-i18next";
import { Navigation } from "react-minimal-side-navigation";
import { useNavigate } from "react-router-dom";

import { getSideBarItem, navigateHandler, useAuth, useStore } from "../../";

import "react-minimal-side-navigation/lib/ReactMinimalSideNavigation.css";
import "../../assets/styles/sidebar.css";

import logo from "../../assets/images/logo.png";

export const Sidebar: FC = () => {
  const { logout } = useAuth();
  const navigate = useNavigate();
  const { t } = useTranslation();

  const store = useStore((store: any) => store);
  const sideBarItem = getSideBarItem(t);

  return (
    <div className={`drawer-side ${store.menuStatus ? "-z-20" : ""}`}>
      <label htmlFor="dashboard-drawer" className="drawer-overlay"></label>
      <ul className="flex flex-col justify-between overflow-y-auto w-72 dark:bg-secondary-dark-100 bg-secondary-light-100">
        <div>
          <li
            style={{ textAlign: "center" }}
            className="px-2 pt-1 pb-2 space-y-5 h-16"
          >
            <img src={logo} alt="logo" className="w-16" />
          </li>
          <div className="space-y-7"></div>
          <Navigation
            items={sideBarItem}
            activeItemId={""}
            onSelect={({ itemId }) => navigateHandler(itemId, navigate)}
          />
        </div>
      </ul>
    </div>
  );
};
