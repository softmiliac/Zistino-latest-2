import { FC, ReactNode } from "react";

interface ITable {
  items: string[];
  children: ReactNode;
}

export const Table: FC<ITable> = ({ items, children }) => {
  return (
    <div className="overflow-x-auto">
      <table className="table w-full table-normal rounded-none">
        <thead className="font-regular rtl:font-rtl-regular opacity-90">
          <tr>
            {items.map((item, index) => (
              <td key={index}>{item}</td>
            ))}
          </tr>
        </thead>
        <tbody>{children}</tbody>
      </table>
    </div>
  );
};
