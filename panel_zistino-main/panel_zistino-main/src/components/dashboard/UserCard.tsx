import { FC } from "react";

export const UserCard: FC<IUser> = ({
  userName,
  firstName,
  lastName,
  imageUrl,
}) => {
  return (
    <div
      dir="ltr"
      className="flex items-center justify-between space-x-4 rtl:pr-6 rtl:pl-0 pr-0 pl-6"
    >
      {imageUrl ? (
        <img
          src={imageUrl}
          className="rounded-full mb-[5px] w-[40px] lg:w-[50px] h-[53px] bg-secondary-dark-200"
        />
      ) : (
        <div className="flex items-center uppercase justify-center text-gray-300 rounded-full w-[44px] h-[44px] lg:w-[46px] lg:h-[46px] bg-gray-600">
          {firstName[0]}
          {lastName[0]}
        </div>
      )}
      <div className="hidden mt-1 md:block text-left lg:leading-6 max-w-[2.5rem] lg:max-w-max truncate">
        <h4 className="text-[11px] lg:text-[14px]">
          {firstName} {lastName}
        </h4>
        <span className="text-[9px] lg:text-[12px] opacity-75">
          @{userName}
        </span>
      </div>
    </div>
  );
};
