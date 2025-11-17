import { FC, useState } from "react";
import { useTranslation } from "react-i18next";
import { HiTruck, HiDocumentSearch, HiCheck, HiX } from "react-icons/hi";
import { ColumnsType } from "antd/lib/table";
import moment from "jalali-moment";
import { Tag, Modal as AntModal } from "antd";

import {
    ProTable,
    useDriverMyRequests,
    useUpdateDriverDelivery,
    ActionIcon,
    Modal,
    Input,
    errorAlert,
    successAlert,
    DELIVERY_STATUS,
} from "../..";

const DriverAppointments: FC = () => {
    const [page, setPage] = useState<number>(1);
    const [perPage, setPerPage] = useState<number>(10);
    const [searchValue, setSearchValue] = useState("");
    const [statusFilter, setStatusFilter] = useState<number | undefined>(undefined);
    const [selectedId, setSelectedId] = useState("");

    const { t } = useTranslation();

    const { data: myRequestsData, isLoading } = useDriverMyRequests(
        page,
        perPage,
        searchValue,
        statusFilter
    );

    // Backend returns nested data structure: { data: { data: [...], ...pagination } }
    const myRequests = myRequestsData?.data?.data || [];
    const paginationData = myRequestsData?.data || {};

    const updateRequest = useUpdateDriverDelivery(selectedId);

    const selectedRequest: any = myRequests?.find(
        (p: any) => p.id === selectedId
    );

    const columns: ColumnsType<any> = [
        {
            title: t("id"),
            dataIndex: "id",
            width: 100,
        },
        {
            title: t("customer"),
            dataIndex: "customer_name",
            render: (value, record) => {
                // Use customer_name from backend, with fallback
                if (record.customer_name) {
                    return record.customer_name;
                }
                return "-";
            },
        },
        {
            title: t("zone"),
            dataIndex: "zone_name",
            render: (value, record) => {
                // Use zone_name from backend serializer
                if (record.zone_name) {
                    return record.zone_name;
                }
                return "-";
            },
        },
        {
            title: t("phone_number"),
            dataIndex: "phone_number",
            render: (value, record) => {
                // Try phone_number from delivery, or customer_phone from order user
                if (record.phone_number) {
                    return record.phone_number;
                }
                if (record.customer_phone) {
                    return record.customer_phone;
                }
                return "-";
            },
        },
        {
            title: t("address"),
            dataIndex: "address",
            ellipsis: true,
            render: (value) => value || "-",
        },
        {
            title: t("description"),
            dataIndex: "description",
            ellipsis: true,
            render: (value) => value || "-",
        },
        {
            title: t("deliveryDate"),
            dataIndex: "delivery_date",
            render: (value) =>
                value ? moment(value).locale("fa").format("YYYY/MM/DD HH:mm") : "-",
        },
        {
            title: t("date"),
            dataIndex: "created_at",
            render: (value) =>
                value ? moment(value).locale("fa").format("HH:mm  -  YYYY/MM/DD") : "-",
        },
        {
            title: t("status"),
            dataIndex: "status",
            render: (value) => {
                // Map backend status strings to numbers for display
                const statusMap: { [key: string]: number } = {
                    'assigned': 0,
                    'in_progress': 1,
                    'completed': 2,
                    'cancelled': 3,
                };
                const statusNum = typeof value === 'string' ? statusMap[value] || 0 : value;
                const statusText = DELIVERY_STATUS[statusNum] || "unknown";
                const statusColors: { [key: number]: string } = {
                    0: "blue", // assigned
                    1: "orange", // in_progress
                    2: "green", // completed
                    3: "red", // cancelled
                };
                return (
                    <Tag color={statusColors[statusNum] || "default"}>
                        {statusNum} - {t(statusText)}
                    </Tag>
                );
            },
        },
        {
            title: t("actions"),
            width: 150,
            render: (record: any) => {
                return (
                    <>
                        <ActionIcon onClick={() => setSelectedId(record.id)}>
                            <label htmlFor="modal-request-detail" className="cursor-pointer">
                                <HiDocumentSearch className="text-xl" />
                            </label>
                        </ActionIcon>
                        {record.status === 0 && (
                            <>
                                <ActionIcon
                                    onClick={() => {
                                        AntModal.confirm({
                                            title: t("accept_request"),
                                            content: t("are_you_sure_accept_request"),
                                            onOk: () => {
                                                updateRequest
                                                    .mutateAsync({ status: 1 }) // in_progress
                                                    .then(() => {
                                                        successAlert({ title: t("request_accepted") });
                                                        setSelectedId("");
                                                    })
                                                    .catch((err) => {
                                                        errorAlert({
                                                            title: err?.message || t("error_occurred"),
                                                        });
                                                    });
                                            },
                                        });
                                    }}
                                >
                                    <HiCheck className="text-xl text-green-500" />
                                </ActionIcon>
                                <ActionIcon
                                    onClick={() => {
                                        AntModal.confirm({
                                            title: t("reject_request"),
                                            content: t("are_you_sure_reject_request"),
                                            onOk: () => {
                                                updateRequest
                                                    .mutateAsync({ status: 3 }) // cancelled
                                                    .then(() => {
                                                        successAlert({ title: t("request_rejected") });
                                                        setSelectedId("");
                                                    })
                                                    .catch((err) => {
                                                        errorAlert({
                                                            title: err?.message || t("error_occurred"),
                                                        });
                                                    });
                                            },
                                        });
                                    }}
                                >
                                    <HiX className="text-xl text-red-500" />
                                </ActionIcon>
                            </>
                        )}
                        {record.status === 1 && (
                            <ActionIcon
                                onClick={() => {
                                    AntModal.confirm({
                                        title: t("complete_request"),
                                        content: t("are_you_sure_complete_request"),
                                        onOk: () => {
                                            updateRequest
                                                .mutateAsync({ status: 2 }) // completed
                                                .then(() => {
                                                    successAlert({ title: t("request_completed") });
                                                    setSelectedId("");
                                                })
                                                .catch((err) => {
                                                    errorAlert({
                                                        title: err?.message || t("error_occurred"),
                                                    });
                                                });
                                        },
                                    });
                                }}
                            >
                                <HiCheck className="text-xl text-green-500" />
                            </ActionIcon>
                        )}
                    </>
                );
            },
        },
    ];

    return (
        <>
            <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
                <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
                    {t("driver_appointments")}
                </h2>
                <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
                    <Input
                        placeholder={t("search")}
                        className="md:w-[280px] w-full"
                        onChange={(e) => setSearchValue(e.target.value)}
                        value={searchValue}
                    />
                    <select
                        className="px-4 py-2 border rounded-md dark:bg-gray-800 dark:border-gray-700"
                        value={statusFilter || ""}
                        onChange={(e) =>
                            setStatusFilter(
                                e.target.value === "" ? undefined : parseInt(e.target.value)
                            )
                        }
                    >
                        <option value="">{t("all_statuses")}</option>
                        <option value="0">{t("assigned")}</option>
                        <option value="1">{t("in_progress")}</option>
                        <option value="2">{t("completed")}</option>
                        <option value="3">{t("cancelled")}</option>
                    </select>
                </div>
            </div>

            {isLoading ? (
                <div>{t("loading")}</div>
            ) : (
                <ProTable
                    columns={columns}
                    dataSource={Array.isArray(myRequests) ? myRequests : []}
                    configData={{
                        ...paginationData,
                        totalCount: paginationData.totalCount || 0,
                    }}
                    page={page}
                    perPage={perPage}
                    setPage={setPage}
                    setPerPage={setPerPage}
                />
            )}

            {/* Request Detail Modal */}
            <Modal html="modal-request-detail" title={t("request_details")}>
                {selectedRequest &&
                    Object.keys(selectedRequest).map((key, index) => {
                        if (
                            !selectedRequest[key] ||
                            key === "id" ||
                            typeof selectedRequest[key] === "object"
                        )
                            return null;

                        let displayValue = selectedRequest[key];
                        if (key === "status") {
                            displayValue = `${selectedRequest[key]} - ${t(
                                DELIVERY_STATUS[selectedRequest[key]]
                            )}`;
                        } else if (
                            key.includes("Date") ||
                            key.includes("date") ||
                            key === "createdOn"
                        ) {
                            displayValue = moment(selectedRequest[key])
                                .locale("fa")
                                .format("YYYY/MM/DD HH:mm");
                        }

                        return (
                            <div key={index} className="mb-4">
                                <strong className="text-gray-700 dark:text-gray-300">
                                    {t(key)}:
                                </strong>{" "}
                                <span className="text-gray-900 dark:text-gray-100">
                                    {displayValue}
                                </span>
                            </div>
                        );
                    })}
            </Modal>
        </>
    );
};

export default DriverAppointments;

