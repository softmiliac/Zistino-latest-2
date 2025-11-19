import { FC } from "react";
import { useTranslation } from "react-i18next";
import { HiChevronLeft, HiChevronRight } from "react-icons/hi";

interface IPagination {
  page: number;
  setPage: any;
  total: number;
  current: number;
  hasNext: boolean;
  hasPrev: boolean;
}

export const Pagination: FC<IPagination> = ({
  page,
  setPage,
  total,
  current,
  hasNext,
  hasPrev,
}) => {
  const { t } = useTranslation();

  return (
    <div dir="ltr" className="flex items-center space-x-5 my-5">
      <button
        className="btn btn-square btn-ghost disabled:bg-transparent"
        onClick={() => setPage(page - 1)}
        disabled={!hasPrev}
      >
        <HiChevronLeft className="text-3xl text-gray-400" />
      </button>
      {localStorage.getItem("i18nextLng") == "fa" ? (
        <span dir="rtl" className="space-x-2 space-x-reverse">
          <span>{total}</span> <span>{t("of")}</span> <span>{current}</span>
        </span>
      ) : (
        <span dir="ltr" className="space-x-2">
          <span>{current}</span>
          <span>{t("of")}</span>
          <span>{total}</span>
        </span>
      )}

      <button
        className="btn btn-square btn-ghost disabled:bg-transparent"
        onClick={() => setPage(page + 1)}
        disabled={!hasNext}
      >
        <HiChevronRight className="text-3xl text-gray-400" />
      </button>
    </div>
  );
};
