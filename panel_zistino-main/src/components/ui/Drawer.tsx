import { FC, useState, ReactNode, useEffect } from "react";
import classNames from "classnames";
import { HiX } from "react-icons/hi";
import { useStore } from "../../";

interface IDrawer {
  children: ReactNode;
  html: string;
  className?: string;
  position?: string;
  width?: string;
  title: string;
}

export const Drawer: FC<IDrawer> = ({
  children,
  html,
  className,
  position,
  width,
  title,
}) => {
  const [opened, setOpened] = useState(false);
  const store = useStore((store: any) => store);

  useEffect(() => {
    store.setMenuStatus(opened);
  }, [opened]);

  return (
    <div
      id={opened ? "menu-opened" : ""}
      className={classNames(
        className,
        position === "right" ? "drawer drawer-end" : "",
        `absolute left-0 top-0 bottom-0 right-0 ${opened ? "z-20" : "-z-10"}`
      )}
    >
      <input
        id={html}
        type="checkbox"
        className="drawer-toggle"
        checked={opened}
        onChange={(e) => {
          setOpened(e.target.checked);
        }}
      />
      <div className="drawer-side h-full z-20">
        <label htmlFor={html} className="drawer-overlay h-full"></label>
        <div
          dir={localStorage.getItem("i18nextLng") == "fa" ? "rtl" : "ltr"}
          className={`${
            width ? width : "lg:w-[25%]"
          } md:w-[50%] w-full bg-secondary-light-100 dark:bg-secondary-dark-100 dark:text-white p-5 h-full`}
        >
          <div className="flex items-center justify-between mb-8">
            <h5>{title}</h5>
            <label htmlFor={html} className="block cursor-pointer md:hidden">
              <HiX className="text-xl opacity-75" />
            </label>
          </div>
          {children}
        </div>
      </div>
    </div>
  );
};
