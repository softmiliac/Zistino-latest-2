import { ColumnsType } from "antd/lib/table";
import { FC, useState } from "react";
import { useTranslation } from "react-i18next";
import { Input, Table, useCouponUses, ProTable } from "../../";

const CouponUses: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState<string>("");
  const { t } = useTranslation();

  const { data: couponUses } = useCouponUses(page, perPage);
  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },

  ]
  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("coupon_uses")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
        </div>
      </div>

      <ProTable
        columns={columns}
        dataSource={couponUses?.data}
        configData={couponUses}
        page={page}
        perPage={perPage}
        setPage={setPage}
        setPerPage={setPerPage}
      />
    </>
  );
};

export default CouponUses;
