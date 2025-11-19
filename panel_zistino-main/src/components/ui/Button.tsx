import { FC, ReactNode, ButtonHTMLAttributes, CSSProperties } from "react";
import classNames from "classnames";

interface IButton extends ButtonHTMLAttributes<HTMLButtonElement> {
  children: ReactNode;
  className?: string;
  loading?: boolean;
  style?: CSSProperties;
}

export const Button: FC<IButton> = ({
  children,
  className,
  loading,
  style,
  ...rest
}) => {
  return (
    <button
      style={style}
      className={classNames(
        className,
        `btn bg-gradient-to-r from-[#76AD00] to-[#76AD00] hover:bg-gradient-to-r hover:from-[#76AD00] hover:to-[#76AD00] text-white border-0 rounded-lg px-4 min-h-[2rem] h-[2.5rem] ${
          loading ? "loading opacity-75 pointer-events-none" : ""
        }`
      )}
      {...rest}
    >
      {children}
    </button>
  );
};
