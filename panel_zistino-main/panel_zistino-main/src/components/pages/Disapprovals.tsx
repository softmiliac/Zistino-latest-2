import { FC, useState } from "react";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";
import { Tag, Select } from "antd";
import moment from "jalali-moment";

import {
    ProTable,
} from "../../";
import { useDisapprovals } from "../../services/api/disapprovals";

const { Option } = Select;

const Disapprovals: FC = () => {
    const [page, setPage] = useState<number>(1);
    const [perPage, setPerPage] = useState<number>(10);
    const [type, setType] = useState<string>("all");
    const { t } = useTranslation();

    const { data: disapprovals, isLoading, error } = useDisapprovals(
        page,
        perPage,
        type
    );

    const getTypeLabel = (typeValue: string) => {
        switch (typeValue) {
            case "customer_denial":
                return t("customer_denial") || "رد مشتری";
            case "driver_non_delivery":
                return t("driver_non_delivery") || "عدم تحویل راننده";
            case "center_denial":
                return t("center_denial") || "رد مرکز";
            default:
                return typeValue;
        }
    };

    const getTypeColor = (typeValue: string) => {
        switch (typeValue) {
            case "customer_denial":
                return "red";
            case "driver_non_delivery":
                return "orange";
            case "center_denial":
                return "purple";
            default:
                return "default";
        }
    };

    const columns: ColumnsType<any> = [
        {
            title: t("delivery_id") || "شناسه تحویل",
            dataIndex: "deliveryId",
            render(value) {
                return value || "-";
            },
        },
        {
            title: t("type") || "نوع",
            dataIndex: "type",
            render(value) {
                return (
                    <Tag color={getTypeColor(value)}>
                        {getTypeLabel(value)}
                    </Tag>
                );
            },
        },
        {
            title: t("customer_phone") || "شماره تماس مشتری",
            dataIndex: "customerPhone",
            render(value) {
                return value || "-";
            },
        },
        {
            title: t("driver_phone") || "شماره تماس راننده",
            dataIndex: "driverPhone",
            render(value) {
                return value || "-";
            },
        },
        {
            title: t("delivery_date") || "تاریخ تحویل",
            dataIndex: "deliveryDate",
            render(value) {
                if (!value) return "-";
                return moment(value).locale("fa").format("HH:mm  -  YYYY/MM/DD");
            },
        },
        {
            title: t("reason_for_disapproval") || "دلیل رد/عدم تحویل",
            dataIndex: "explanation",
            render(value) {
                return value || "-";
            },
        },
        {
            title: t("date") || "تاریخ",
            dataIndex: "createdAt",
            render(value) {
                if (!value) return "-";
                return moment(value).locale("fa").format("HH:mm  -  YYYY/MM/DD");
            },
        },
    ];

    return (
        <>
            <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
                <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
                    {t("disapprovals") || "ردها و عدم تحویل‌ها"}
                </h2>
                <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
                    <Select
                        value={type}
                        onChange={(value) => {
                            setType(value);
                            setPage(1);
                        }}
                        style={{ width: 200 }}
                        placeholder={t("filter_by_type") || "فیلتر بر اساس نوع"}
                    >
                        <Option value="all">{t("all") || "همه"}</Option>
                        <Option value="customer_denial">{t("customer_denial") || "رد مشتری"}</Option>
                        <Option value="driver_non_delivery">{t("driver_non_delivery") || "عدم تحویل راننده"}</Option>
                        <Option value="center_denial">{t("center_denial") || "رد مرکز"}</Option>
                    </Select>
                </div>
            </div>
            {isLoading ? (
                <div>{t("loading")}</div>
            ) : error ? (
                <div className="text-red-500">Error: {(error as any)?.message || "Failed to load disapprovals"}</div>
            ) : (
                <ProTable
                    columns={columns}
                    dataSource={Array.isArray(disapprovals?.items) ? disapprovals.items : Array.isArray(disapprovals?.data?.items) ? disapprovals.data.items : []}
                    configData={disapprovals ? {
                        ...(disapprovals.data || disapprovals),
                        totalCount: (disapprovals.data || disapprovals).total || 0,
                        currentPage: (disapprovals.data || disapprovals).pageNumber || page,
                        totalPages: (disapprovals.data || disapprovals).total ? Math.ceil((disapprovals.data || disapprovals).total / ((disapprovals.data || disapprovals).pageSize || perPage)) : 0,
                        pageSize: (disapprovals.data || disapprovals).pageSize || perPage,
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

export default Disapprovals;

