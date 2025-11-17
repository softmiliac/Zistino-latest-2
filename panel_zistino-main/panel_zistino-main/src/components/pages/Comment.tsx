import { FC, useState } from "react";
import { ColumnsType } from "antd/lib/table";
import { useTranslation } from "react-i18next";

import {
  ProTable,
} from "../../";
import { useComments } from "../../services/api/comment";

const Comment: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [perPage, setPerPage] = useState<number>(5);
  const [page, setPage] = useState<number>(1);

  const { t } = useTranslation();

  const { data: configurations, isLoading, error } = useComments(
    page,
    perPage,
    searchValue
  );

  // Delivery surveys are read-only - customers create them when confirming deliveries

  const columns: ColumnsType<any> = [
    // {
    //   title: t("id"),
    //   dataIndex: "id",
    // },
    {
      title: t("نام راننده") || "نام راننده",
      dataIndex: "driverName",
      render(value) {
        return value || "-";
      },
    },
    {
      title: t("firstname") || "نام",
      dataIndex: "userFullName",
      render(value) {
        return value || "-";
      },
    },
    {
      title: t("text"),
      dataIndex: "text",
      render(v) {
        if (!v) return "";
        try {
          // Try to parse as JSON first
          const parsed = JSON.parse(v);
          if (Array.isArray(parsed)) {
            return parsed.map(({ text }: any, index: any) =>
              index != 0 ? " ---- " + text : text
            ).join("");
          }
          // If parsed but not array, return as string
          return String(v);
        } catch (e) {
          // If not valid JSON, return as plain string
          return String(v);
        }
      },
    },
    {
      title: t("rate"),
      dataIndex: "rate",
    },
  ];
  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("نظرات کاربران")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          {/* <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          /> */}
          {/* <Button>
            <label
              htmlFor="create-configuration"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("add")}
            </label>
          </Button> */}
        </div>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : error ? (
        <div className="text-red-500">Error: {(error as any)?.message || "Failed to load comments"}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={configurations?.data || []}
          configData={configurations}
          page={page}
          perPage={perPage}
          setPerPage={setPerPage}
          setPage={setPage}
        />
      )}
    </>
  );
};

export default Comment;
