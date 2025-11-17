import { FC, InputHTMLAttributes, useState } from "react";
import classNames from "classnames";
import { ActionIcon } from "./ActionIcon";
import { RiEyeLine, RiEyeOffLine } from "react-icons/ri";

interface IPasswordInput extends InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  label?: string;
  error?: string;
}

export const PasswordInput: FC<IPasswordInput> = ({
  className,
  label,
  error,
  ...rest
}) => {
  const [isPassword, setIsPassword] = useState(true);
  return (
    <div className="form-control">
      {label && (
        <label className="label mb-2">
          <span className="label-text dark:text-gray-200 text-gray-500">
            {label}
          </span>
        </label>
      )}
      <div className="relative">
        <input
          type={isPassword ? "password" : "text"}
          className={classNames(
            "input w-full bg-[#f1f1f1] focus:shadow-input-light dark:focus:shadow-input-dark text-gray-700 dark:bg-[#3d4451] dark:text-gray-300",
            className
          )}
          {...rest}
        />
        <ActionIcon
          type="button"
          className="absolute inset-y-0 right-0"
          onClick={() => setIsPassword(!isPassword)}
        >
          {isPassword ? (
            <RiEyeLine className="text-xl text-gray-300/75" />
          ) : (
            <RiEyeOffLine className="text-xl text-gray-300/75" />
          )}
        </ActionIcon>
      </div>
      {error && (
        <span className="block text-red-500 text-xs mt-3">{error}</span>
      )}
    </div>
  );
};
