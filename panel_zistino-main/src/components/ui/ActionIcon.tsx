import { FC, ReactNode, ButtonHTMLAttributes } from "react";
import classNames from "classnames";

interface IActionIcon extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
}

export const ActionIcon: FC<IActionIcon> = ({
  children,
  className,
  ...rest
}) => {
  return (
    <button
      className={classNames(
        className,
        "btn-square btn bg-transparent dark:hover:bg-gray-500/30 hover:bg-gray-500/10 focus:bg-transparent text-gray-600 dark:text-gray-200 border-0 rounded-xl"
      )}
      {...rest}
    >
      {children}
    </button>
  );
};
