import { FC } from "react";

interface IToggle {
  label: string;
  onChange?: any;
  error?: any;
  checked?: boolean;
  value?: any;
  name?: string;
}

export const Toggle: FC<IToggle> = ({
  label,
  onChange,
  error,
  checked,
  value,
  name,
}) => {
  return (
    <div className="form-control">
      <label className="cursor-pointer label">
        <span className="label-text dark:text-gray-200 text-gray-500 mr-5">
          {label}
        </span>
        <input
          type="checkbox"
          className="toggle"
          name={name}
          onChange={onChange}
          checked={checked}
          value={value}
        />
      </label>
      {error && (
        <span className="block text-red-500 text-xs mt-3">{error}</span>
      )}
    </div>
  );
};
