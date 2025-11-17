import { FC, ReactNode } from "react";

interface IIndicator {
  children: ReactNode;
  content: string;
  position?: string;
}

export const Indicator: FC<IIndicator> = ({ children, content, position }) => {
  return (
    <div className="indicator">
      <div
        className={`indicator-item ${
          position ? position : "indicator-top"
        } indicator-end badge bg-primary border-0 w-[1px] p-[10px]`}
      >
        {content}
      </div>
      {children}
    </div>
  );
};
