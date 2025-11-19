import { FC } from "react";
import { Sidebar, Header } from "../../";

interface Props {
  children: any;
}

export const MainLayout: FC<Props> = ({ children }) => {
  return (
    <div className="drawer drawer-mobile h-screen font-regular rtl:font-rtl-regular">
      <input id="dashboard-drawer" type="checkbox" className="drawer-toggle" />
      {/* CONTENT */}
      <div className="drawer-content">
        <Header />
        <div className="p-8">{children}</div>
      </div>

      {/* SIDEBAR */}
      <Sidebar />
    </div>
  );
};
