import { FC } from "react";
import { Input } from "../../";

interface Props {
  tags: any[];
  addHandler: any;
  removeHandler: any;
  placeholder: string;
}

export const TagInput: FC<Props> = ({
  tags,
  addHandler,
  removeHandler,
  placeholder,
}) => {
  return (
    <div>
      <ul className="flex space-x-2 max-w-full overflow-auto pb-3 mb-4">
        {tags?.map((tag, index) => (
          <li key={index}>
            <div
              className="badge badge-ghost text-sm space-x-2 cursor-pointer"
              key={index}
            >
              <span className="block" onClick={() => removeHandler(index)}>
                x
              </span>
              <span>{tag}</span>
            </div>
          </li>
        ))}
      </ul>
      <Input
        onKeyUp={(event) => {
          event.key === "Enter" && addHandler(event);
        }}
        placeholder={placeholder}
      />
    </div>
  );
};
