import { FC } from "react";
import { Select } from "antd";

export const SingleSelect: FC<any> = ({
  handler,
  placeholder,
  children,
  label,
  defaultValue,
  value,
  showSearch,
  id,
  style,
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
      <Select
        id={id}
        showSearch={showSearch}
        defaultValue={defaultValue}
        value={value}
        style={{ width: "100%" }}
        placeholder={placeholder}
        onChange={handler}
        filterOption={(inputValue, option) =>
          [...(option?.children ?? [])]
            .join("")
            .toLowerCase()
            .includes(inputValue.toLowerCase())
        }
      >
        {children}
      </Select>
    </div>
  );
};
