import { FC, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash, HiStar, HiStop, HiUsers } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";
import { Modal, Tag, Button as AntButton } from "antd";
import { useQueryClient } from "react-query";

import {
    ActionIcon,
    Button,
    Drawer,
    Input,
    Select,
    useLotteries,
    useCreateLottery,
    useDeleteLottery,
    useUpdateLottery,
    errorAlert,
    successAlert,
    ProTable,
    useLotteryGet,
    useDrawLotteryWinner,
    useEndLottery,
    useLotteryParticipants,
    useLotteryEligibleDrivers,
} from "../../";

const LotteryManagement: FC = () => {
    const [page, setPage] = useState<number>(1);
    const [perPage, setPerPage] = useState<number>(5);
    const [searchValue, setSearchValue] = useState<string>("");
    const [selectedLotteryId, setSelectedLotteryId] = useState<any>("");
    const [eligibleDriversModalVisible, setEligibleDriversModalVisible] = useState(false);
    const [selectedLotteryForEligibleDrivers, setSelectedLotteryForEligibleDrivers] = useState<string>("");
    const [minPointsFilter, setMinPointsFilter] = useState<number>(0);

    const { t } = useTranslation();
    const queryClient = useQueryClient();

    const { data: lotteries, isLoading } = useLotteries(page, perPage, searchValue);
    const deleteLottery = useDeleteLottery();
    const createLottery = useCreateLottery();
    const updateLottery = useUpdateLottery(selectedLotteryId);
    const drawWinner = useDrawLotteryWinner();
    const endLottery = useEndLottery();
    const { data: eligibleDrivers, isLoading: loadingEligibleDrivers } = useLotteryEligibleDrivers(
        selectedLotteryForEligibleDrivers,
        minPointsFilter
    );

    const dataSelectedLottery = useLotteryGet(selectedLotteryId) as any;
    const selectedLottery = dataSelectedLottery?.data?.data;

    const createFormik = useFormik({
        initialValues: {
            name: "",
            description: "",
            startDate: "",
            endDate: "",
            prize: "",
            status: "active",
        },
        validateOnBlur: false,
        validateOnChange: false,
        onSubmit: (values) => {
            if (values.name === "") return;

            const data = {
                title: values.name, // Backend expects 'title', not 'name'
                description: values.description || "",
                ticketPricePoints: 0, // Set to 0 since tickets are not used
                startDate: values.startDate ? new Date(values.startDate).toISOString() : null,
                endDate: values.endDate ? new Date(values.endDate).toISOString() : null,
                prizeName: values.prize, // Backend expects 'prizeName', not 'prize'
                prizeImage: "", // Optional field
                status: values.status || "draft",
            };

            createLottery
                .mutateAsync(data)
                .then(() => {
                    document.getElementById("create-lottery")?.click();
                    createFormik.resetForm();
                    successAlert({ title: t("lottery_created_successfully") });
                    // Invalidate queries to refresh the lottery list
                    queryClient.invalidateQueries("lotteries");
                })
                .catch((err) => {
                    errorAlert({ title: err?.message || t("error_occurred") });
                });
        },
    });

    const updateFormik = useFormik({
        initialValues: {
            name: selectedLottery?.title || "", // Backend returns 'title', map to 'name' for form
            description: selectedLottery?.description || "",
            startDate: selectedLottery?.startDate || "",
            endDate: selectedLottery?.endDate || "",
            prize: selectedLottery?.prizeName || "", // Backend returns 'prizeName', map to 'prize' for form
            status: selectedLottery?.status || "active",
        },
        validateOnBlur: false,
        validateOnChange: false,
        enableReinitialize: true,
        onSubmit: (values) => {
            if (values.name === "") return;

            const data = {
                title: values.name, // Backend expects 'title', not 'name'
                description: values.description || "",
                ticketPricePoints: 0, // Set to 0 since tickets are not used
                startDate: values.startDate ? new Date(values.startDate).toISOString() : null,
                endDate: values.endDate ? new Date(values.endDate).toISOString() : null,
                prizeName: values.prize, // Backend expects 'prizeName', not 'prize'
                prizeImage: selectedLottery?.prizeImage || "", // Optional field
                status: values.status || "draft",
            };

            updateLottery
                .mutateAsync(data)
                .then(() => {
                    document.getElementById("update-lottery")?.click();
                    updateFormik.resetForm();
                    successAlert({ title: t("lottery_updated_successfully") });
                })
                .catch((err) => {
                    errorAlert({ title: err?.message || t("error_occurred") });
                });
        },
    });

    if (isLoading) return <div>{t("loading")}</div>;

    const deleteHandler = (id: any) => {
        if (!window.confirm(t("delete_item"))) return;
        toast.promise(deleteLottery.mutateAsync(id), {
            pending: "Please wait...",
            success: "Deleted successfully",
            error: "Something went wrong",
        });
    };

    const drawWinnerHandler = (id: string, minPoints: number = 0) => {
        if (!window.confirm(t("confirm_draw_winner") || "آیا از قرعه کشی مطمئن هستید؟")) return;
        drawWinner.mutateAsync({ id, data: { method: 'random', min_points: minPoints } })
            .then((response: any) => {
                const message = response?.sms_sent
                    ? `Winner drawn successfully! SMS sent to ${response.winner_phone}`
                    : "Winner drawn successfully! (SMS may not have been sent)";
                successAlert({ title: message });
            })
            .catch((err: any) => {
                errorAlert({ title: err?.message || "Something went wrong" });
            });
    };

    const endLotteryHandler = (id: string) => {
        if (!window.confirm(t("confirm_end_lottery"))) return;
        toast.promise(endLottery.mutateAsync(id), {
            pending: "Ending lottery...",
            success: "Lottery ended successfully",
            error: "Something went wrong",
        });
    };

    const showEligibleDrivers = (id: string) => {
        setSelectedLotteryForEligibleDrivers(id);
        setEligibleDriversModalVisible(true);
    };

    const columns: ColumnsType<any> = [
        {
            title: t("id"),
            dataIndex: "id",
        },
        {
            title: t("name"),
            dataIndex: "title", // Backend returns 'title', not 'name'
        },
        {
            title: t("status"),
            dataIndex: "status",
            render: (value) => {
                const statusMap: { [key: string]: string } = {
                    "active": t("active"),
                    "pending": t("pending"),
                    "ended": t("ended"),
                    "draft": t("draft"),
                    "drawn": t("drawn"),
                    "cancelled": t("cancelled"),
                };
                return (
                    <Tag color={value === "active" ? "green" : value === "ended" ? "red" : "default"}>
                        {statusMap[value] || value}
                    </Tag>
                );
            },
        },
        {
            title: t("actions"),
            render: (record) => {
                return (
                    <>
                        <ActionIcon onClick={() => setSelectedLotteryId(record.id)}>
                            <label htmlFor="update-lottery" className="cursor-pointer">
                                <HiPencil className="text-2xl" />
                            </label>
                        </ActionIcon>
                        <ActionIcon onClick={() => showEligibleDrivers(record.id)}>
                            <HiUsers className="text-2xl text-blue-500" />
                        </ActionIcon>
                        {record.status === "active" && (
                            <>
                                <ActionIcon onClick={() => drawWinnerHandler(record.id)}>
                                    <HiStar className="text-2xl text-yellow-500" />
                                </ActionIcon>
                                <ActionIcon onClick={() => endLotteryHandler(record.id)}>
                                    <HiStop className="text-2xl text-orange-500" />
                                </ActionIcon>
                            </>
                        )}
                        <ActionIcon onClick={() => deleteHandler(record.id)}>
                            <HiTrash className="text-2xl text-red-500" />
                        </ActionIcon>
                    </>
                );
            },
        },
    ];

    return (
        <>
            <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
                <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
                    {t("lottery_management")}
                </h2>
                <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
                    <Input
                        placeholder={t("search")}
                        className="md:w-[280px] w-full"
                        onChange={(e) => setSearchValue(e.target.value)}
                    />
                    <Button>
                        <label
                            htmlFor="create-lottery"
                            className="w-full h-full flex items-center cursor-pointer"
                        >
                            <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
                            {t("add")}
                        </label>
                    </Button>
                </div>
            </div>
            <ProTable
                columns={columns}
                dataSource={Array.isArray(lotteries?.items) ? lotteries.items : []}
                configData={lotteries ? { ...lotteries, totalCount: lotteries.total } : null}
                page={page}
                perPage={perPage}
                setPage={setPage}
                setPerPage={setPerPage}
            />
            <Drawer title={t("create_lottery")} html="create-lottery" position="right">
                <form onSubmit={createFormik.handleSubmit} className="space-y-5">
                    <Input
                        label={t("name")}
                        name="name"
                        onChange={createFormik.handleChange}
                        value={createFormik.values.name}
                        error={createFormik.errors.name}
                    />
                    <Input
                        label={t("description")}
                        name="description"
                        onChange={createFormik.handleChange}
                        value={createFormik.values.description}
                        error={createFormik.errors.description}
                    />
                    <Input
                        label={t("prize")}
                        name="prize"
                        onChange={createFormik.handleChange}
                        value={createFormik.values.prize}
                        error={createFormik.errors.prize}
                    />
                    <Input
                        label={t("start_date")}
                        name="startDate"
                        type="datetime-local"
                        onChange={createFormik.handleChange}
                        value={createFormik.values.startDate}
                        error={createFormik.errors.startDate}
                    />
                    <Input
                        label={t("end_date")}
                        name="endDate"
                        type="datetime-local"
                        onChange={createFormik.handleChange}
                        value={createFormik.values.endDate}
                        error={createFormik.errors.endDate}
                    />
                    <Select
                        label={t("status")}
                        name="status"
                        onChange={createFormik.handleChange}
                        value={createFormik.values.status}
                        error={createFormik.errors.status}
                    >
                        <option value="active">{t("active")}</option>
                        <option value="pending">{t("pending")}</option>
                        <option value="ended">{t("ended")}</option>
                    </Select>
                    <br />
                    <Button
                        type="submit"
                        className="btn-block font-semibold rtl:font-rtl-semibold"
                        loading={createLottery.isLoading}
                    >
                        {t("create_lottery")}
                    </Button>
                </form>
            </Drawer>

            <Drawer title={t("update_lottery")} html="update-lottery" position="right">
                <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
                    <Input
                        label={t("name")}
                        name="name"
                        onChange={updateFormik.handleChange}
                        value={updateFormik.values.name}
                        error={updateFormik.errors.name}
                    />
                    <Input
                        label={t("description")}
                        name="description"
                        onChange={updateFormik.handleChange}
                        value={updateFormik.values.description}
                        error={updateFormik.errors.description}
                    />
                    <Input
                        label={t("prize")}
                        name="prize"
                        onChange={updateFormik.handleChange}
                        value={updateFormik.values.prize}
                        error={updateFormik.errors.prize}
                    />
                    <Input
                        label={t("start_date")}
                        name="startDate"
                        type="datetime-local"
                        onChange={updateFormik.handleChange}
                        value={updateFormik.values.startDate}
                        error={updateFormik.errors.startDate}
                    />
                    <Input
                        label={t("end_date")}
                        name="endDate"
                        type="datetime-local"
                        onChange={updateFormik.handleChange}
                        value={updateFormik.values.endDate}
                        error={updateFormik.errors.endDate}
                    />
                    <Select
                        label={t("status")}
                        name="status"
                        onChange={updateFormik.handleChange}
                        value={updateFormik.values.status}
                        error={updateFormik.errors.status}
                    >
                        <option value="active">{t("active")}</option>
                        <option value="pending">{t("pending")}</option>
                        <option value="ended">{t("ended")}</option>
                    </Select>
                    <br />
                    <Button
                        type="submit"
                        className="btn-block font-semibold rtl:font-rtl-semibold"
                        loading={updateLottery.isLoading}
                    >
                        {t("update_lottery")}
                    </Button>
                </form>
            </Drawer>

            {/* Eligible Drivers Modal */}
            <Modal
                title={t("eligible_drivers") || "رانندگان واجد شرایط"}
                open={eligibleDriversModalVisible}
                onCancel={() => {
                    setEligibleDriversModalVisible(false);
                    setSelectedLotteryForEligibleDrivers("");
                    setMinPointsFilter(0);
                }}
                footer={[
                    <AntButton key="draw" type="primary" onClick={() => {
                        if (selectedLotteryForEligibleDrivers) {
                            drawWinnerHandler(selectedLotteryForEligibleDrivers, minPointsFilter);
                            setEligibleDriversModalVisible(false);
                        }
                    }}>
                        {t("draw_winner") || "قرعه کشی"}
                    </AntButton>,
                    <AntButton key="cancel" onClick={() => {
                        setEligibleDriversModalVisible(false);
                        setSelectedLotteryForEligibleDrivers("");
                        setMinPointsFilter(0);
                    }}>
                        {t("cancel")}
                    </AntButton>
                ]}
                width={800}
            >
                <div className="mb-4">
                    <label className="block mb-2">{t("min_points") || "حداقل امتیاز"}:</label>
                    <Input
                        type="number"
                        min={0}
                        value={minPointsFilter}
                        onChange={(e) => setMinPointsFilter(parseInt(e.target.value) || 0)}
                        placeholder="0"
                    />
                </div>
                {loadingEligibleDrivers ? (
                    <div>{t("loading")}</div>
                ) : (
                    <div>
                        {Array.isArray(eligibleDrivers?.items) && eligibleDrivers.items.length > 0 ? (
                            <div className="space-y-2 max-h-96 overflow-y-auto">
                                {eligibleDrivers.items.map((driver: any, index: number) => (
                                    <div key={driver.userId || index} className="p-3 border rounded flex justify-between items-center">
                                        <div>
                                            <div className="font-semibold">{driver.userName || driver.userPhone}</div>
                                            <div className="text-sm text-gray-500">{driver.userPhone}</div>
                                        </div>
                                        <div className="text-lg font-bold text-green-600">
                                            {driver.points} {t("points") || "امتیاز"}
                                        </div>
                                    </div>
                                ))}
                            </div>
                        ) : (
                            <p>{t("no_eligible_drivers") || "راننده واجد شرایطی یافت نشد"}</p>
                        )}
                        {eligibleDrivers?.total !== undefined && (
                            <div className="mt-4 text-center text-gray-600">
                                {t("total")}: {eligibleDrivers.total} {t("drivers") || "راننده"}
                            </div>
                        )}
                    </div>
                )}
            </Modal>
        </>
    );
};

export default LotteryManagement;

