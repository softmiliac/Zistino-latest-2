import { FC } from "react";
import { ActionIcon, useDarkMode } from "../../";
import { BsFillMoonFill, BsFillSunFill } from "react-icons/bs";

export const ThemeSwitcher: FC = () => {
  const { toggle, theme } = useDarkMode();
  return (
    <ActionIcon onClick={toggle}>
      {theme === "dark" ? (
        <BsFillMoonFill className="text-lg" />
      ) : (
        <BsFillSunFill className="text-lg" />
      )}
    </ActionIcon>
  );
};
