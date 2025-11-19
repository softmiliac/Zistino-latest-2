import { FC } from "react";
import { HiOutlineMenu, HiBell, HiMail } from "react-icons/hi";
import { useTranslation } from "react-i18next";

import { ThemeSwitcher, ActionIcon, UserCard } from "../../";

export const Header: FC = () => {
  const { i18n } = useTranslation();

  // const changeLanguage = (lng: any) => {
  //   i18n.changeLanguage(lng);
  // };

  return (
    <div className="lg:block text-right flex items-center justify-between p-[0.7rem] bg-secondary-light-100 dark:bg-secondary-dark-100">
      <ActionIcon className="lg:hidden">
        <label htmlFor="dashboard-drawer">
          <HiOutlineMenu className="text-2xl" />
        </label>
      </ActionIcon>
      <div className="flex items-center space-x-2 w-fit rtl:mr-auto rtl:ml-0 ml-auto">
        <ThemeSwitcher />
        {/* <ActionIcon>
          <HiMail className="text-2xl" />
        </ActionIcon>
        <ActionIcon>
          <HiBell className="text-2xl" />
        </ActionIcon> */}
        {/* <select
          className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
          onChange={(e) => {
            changeLanguage(e.target.value);
          }}
          value={localStorage.getItem("i18nextLng") ?? "fa"}
        >
          <option value="en">EN</option>
          <option value="fa">فا</option>
        </select> */}

        <UserCard
          userName="admin"
          firstName="Root"
          lastName="Admin"
          imageUrl=""
          isActive={true}
          id="123"
          phoneNumber="123"
          email="ad"
        />
      </div>
    </div>
  );
};
