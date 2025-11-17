import { CSSProperties, FC, ReactNode, SelectHTMLAttributes } from "react";
import classNames from "classnames";

interface ISelect extends SelectHTMLAttributes<HTMLSelectElement> {
  className?: string;
  label?: string;
  children: ReactNode;
  error?: any;
  style?: CSSProperties;
}

export const Select: FC<ISelect> = ({
  label,
  className,
  children,
  error,
  style,
  ...rest
}) => {
  return (
    <div className="form-control" style={style}>
      {label && (
        <label className="label mb-2">
          <span className="label-text dark:text-gray-200 text-gray-500">
            {label}
          </span>
        </label>
      )}
      <select
        className={classNames(
          className,
          "select w-full font-regular rtl:font-rtl-regular bg-[#f1f1f1] focus:shadow-input-light dark:focus:shadow-input-dark text-gray-700 dark:bg-[#3d4451] dark:text-gray-300"
        )}
        {...rest}
      >
        {children}
      </select>
      {error && (
        <span className="block text-red-500 text-xs mt-3">{error}</span>
      )}
    </div>
  );
};
