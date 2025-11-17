import { CSSProperties, FC, TextareaHTMLAttributes } from "react";
import classNames from "classnames";

interface ITextArea extends TextareaHTMLAttributes<HTMLTextAreaElement> {
  className?: string;
  label?: string;
  error?: any;
  style?: CSSProperties;
}

export const TextArea: FC<ITextArea> = ({
  className,
  label,
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
      <textarea
        className={classNames(
          "textarea h-24 bg-[#f1f1f1] focus:shadow-input-light dark:focus:shadow-input-dark text-gray-700 dark:bg-[#3d4451] dark:text-gray-300",
          className
        )}
        {...rest}
      ></textarea>
      {error && (
        <span className="block text-red-500 text-xs mt-3">{error}</span>
      )}
    </div>
  );
};
