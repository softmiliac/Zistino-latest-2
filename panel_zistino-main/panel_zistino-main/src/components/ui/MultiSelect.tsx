import { FC } from "react";
import { Select } from "antd";

export const MultiSelect: FC<any> = ({
  handler,
  placeholder,
  children,
  label,
  value,
  defaultValue,
  id,
}) => {
  return (
    <div className="form-control">
      {label && (
        <label className="label mb-2">
          <span className="label-text dark:text-gray-200 text-gray-500">
            {label}
          </span>
        </label>
      )}
      <Select
        id={id}
        defaultValue={defaultValue}
        value={value}
        mode="multiple"
        style={{ width: "100%" }}
        placeholder={placeholder}
        onChange={handler}
      >
        {children}
      </Select>
    </div>
  );
};
