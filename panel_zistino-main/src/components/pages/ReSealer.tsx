import { FC, useState } from "react";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";

import {
  ProTable,
} from "../../";
import { useReferrals } from "../../services/api/referrals";
import moment from "moment";
import DatePicker from "react-multi-date-picker";
import TimePicker from "react-multi-date-picker/plugins/time_picker";
import persian from "react-date-object/calendars/persian";
import persian_fa from "react-date-object/locales/persian_fa";

const ReSealer: FC = () => {
  const date = new Date();
  const [fromDate, setFromDate] = useState<any>(
    new Date(new Date().setFullYear(new Date().getFullYear() - 1))
  );
  const [toDate, setToDate] = useState<any>(date);
  const { t } = useTranslation();

  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(10);
  const [keyword, setKeyword] = useState<string>("");
  const [status, setStatus] = useState<string>("");

  const { data: referrals, isLoading } = useReferrals(
    page,
    perPage,
    keyword,
    status,
    moment(fromDate?.toDate?.().toString()).format("YYYY-MM-DD"),
    moment(toDate?.toDate?.().toString()).format("YYYY-MM-DD")
  );

  const columns: ColumnsType<any> = [
    {
      title: t("username") || "نام کاربری",
      dataIndex: "referredPhone",
      render(value, record) {
        // Show referred user's phone as username
        return record.referredPhone || record.referredName || "-";
      },
    },
    {
      title: t("name") || "نام",
      dataIndex: "referredName",
      render(value, record) {
        // Show referred user's name
        return record.referredName || record.referredPhone || "-";
      },
    },
    {
      title: t("email") || "ایمیل",
      dataIndex: "email",
      render(value, record) {
        // Referrals don't have email, show referrer info instead
        return record.referrerName ? `${t("referred_by") || "معرفی شده توسط"}: ${record.referrerName}` : "-";
      },
    },
    {
      title: t("کد معرف") || "کد معرف",
      dataIndex: "referral_code",
      render(value) {
        return value || "-";
      },
    },
  ];

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("معرفی ها")}
        </h2>
      </div>
      <div style={{ display: "flex", gap: "20px" }}>
        <div
          style={{
            width: "30%",
          }}
        >
          <label className="label mb-2">
            <span className="label-text dark:text-gray-200 text-gray-500">
              از تاریخ
            </span>
          </label>
          <DatePicker
            style={{
              width: "100%",
              height: "48px",
              backgroundColor: "#f1f1f1",
              border: "0",
              padding: "0 15px",
            }}
            format="MM/DD/YYYY"
            onChange={(value) => setFromDate(value)}
            value={fromDate}
            calendar={persian}
            locale={persian_fa}
          />
        </div>
        <div
          style={{
            width: "30%",
          }}
        >
          <label className="label mb-2">
            <span className="label-text dark:text-gray-200 text-gray-500">
              تا تاریخ
            </span>
          </label>
          <DatePicker
            style={{
              width: "100%",
              height: "48px",
              backgroundColor: "#f1f1f1",
              border: "0",
              padding: "0 15px",
            }}
            format="MM/DD/YYYY"
            onChange={(value) => setToDate(value)}
            value={toDate}
            calendar={persian}
            locale={persian_fa}
          />
        </div>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={Array.isArray(referrals?.items) ? referrals.items : []}
          configData={referrals ? {
            ...referrals,
            totalCount: referrals.total || 0,
            currentPage: referrals.pageNumber || page,
            totalPages: referrals.total ? Math.ceil(referrals.total / (referrals.pageSize || perPage)) : 0,
            pageSize: referrals.pageSize || perPage,
          } : null}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}
    </>
  );
};

export default ReSealer;
