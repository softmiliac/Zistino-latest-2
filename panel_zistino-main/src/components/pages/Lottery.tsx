import { FC, useState } from "react";
import { HiStar, HiCurrencyDollar } from "react-icons/hi";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";
import { Tabs, Tag } from "antd";

import {
    ProTable,
    useLotteryWinners,
    usePointsSearch,
} from "../../";

const { TabPane } = Tabs;

const Lottery: FC = () => {
    const [activeTab, setActiveTab] = useState("winners");
    const [page, setPage] = useState<number>(1);
    const [perPage, setPerPage] = useState<number>(10);

    const { t } = useTranslation();

    const { data: winners, isLoading: loadingWinners } = useLotteryWinners();
    const { data: pointsHistory, isLoading: loadingHistory } = usePointsSearch(page, perPage);



    const winnersColumns: ColumnsType<any> = [
        {
            title: t("lottery_id"),
            dataIndex: "lotteryId",
        },
        {
            title: t("lottery_name"),
            dataIndex: "lotteryName",
        },
        {
            title: t("winner_name"),
            dataIndex: "winnerName",
        },
        {
            title: t("prize"),
            dataIndex: "prize",
        },
        {
            title: t("draw_date"),
            dataIndex: "drawDate",
            render: (value) => value ? new Date(value).toLocaleDateString() : "-",
        },
    ];

    const pointsHistoryColumns: ColumnsType<any> = [
        {
            title: t("date"),
            dataIndex: "createdAt",
            render: (value) => value ? new Date(value).toLocaleDateString() : "-",
        },
        {
            title: t("user_phone") || "شماره تلفن",
            dataIndex: "userPhone",
            render: (value) => value || "-",
        },
        {
            title: t("person_name") || "نام شخص",
            dataIndex: "userName",
            render: (value) => value || "-",
        },
        {
            title: t("amount") || "مقدار",
            dataIndex: "currentBalance",
            render: (value, record) => {
                // Use currentBalance if available, otherwise fallback to balanceAfter
                const balance = record.currentBalance !== undefined ? record.currentBalance : record.balanceAfter;
                return (
                    <Tag color="green">
                        {balance || 0} {t("points")}
                    </Tag>
                );
            },
        },
        {
            title: t("description"),
            dataIndex: "description",
            ellipsis: true,
            render: (value) => value || "-",
        },
    ];


    return (
        <>
            <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
                <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
                    {t("lottery")}
                </h2>
            </div>

            <Tabs activeKey={activeTab} onChange={setActiveTab} className="mt-6">
                {/* Winners Tab */}
                <TabPane
                    tab={
                        <span>
                            <HiStar className="inline-block mr-2" />
                            {t("winners")}
                        </span>
                    }
                    key="winners"
                >
                    {loadingWinners ? (
                        <div>{t("loading")}</div>
                    ) : (
                        <ProTable
                            columns={winnersColumns}
                            dataSource={Array.isArray(winners?.items) ? winners.items.map((lottery: any) => ({
                                ...lottery,
                                lotteryId: lottery.id,
                                lotteryName: lottery.title || lottery.lotteryName,
                                winnerName: lottery.winnerName || lottery.winner?.first_name + " " + lottery.winner?.last_name || lottery.winner?.phone_number || "-",
                                prize: lottery.prizeName || lottery.prize,
                                drawDate: lottery.drawnAt || lottery.drawDate,
                            })) : Array.isArray(winners?.data) ? winners.data.map((lottery: any) => ({
                                ...lottery,
                                lotteryId: lottery.id,
                                lotteryName: lottery.title || lottery.lotteryName,
                                winnerName: lottery.winnerName || lottery.winner?.first_name + " " + lottery.winner?.last_name || lottery.winner?.phone_number || "-",
                                prize: lottery.prizeName || lottery.prize,
                                drawDate: lottery.drawnAt || lottery.drawDate,
                            })) : []}
                            configData={winners ? { ...winners, totalCount: winners.total || winners.data?.length || 0 } : null}
                            page={page}
                            perPage={perPage}
                            setPage={setPage}
                            setPerPage={setPerPage}
                            notHavePaging={true}
                        />
                    )}
                </TabPane>

                {/* Points History Tab */}
                <TabPane
                    tab={
                        <span>
                            <HiCurrencyDollar className="inline-block mr-2" />
                            {t("points_history")}
                        </span>
                    }
                    key="points-history"
                >
                    {loadingHistory ? (
                        <div>{t("loading")}</div>
                    ) : (
                        <ProTable
                            columns={pointsHistoryColumns}
                            dataSource={
                                (Array.isArray(pointsHistory?.items) ? pointsHistory.items : Array.isArray(pointsHistory?.data) ? pointsHistory.data : [])
                                    .filter((transaction: any) => transaction.source !== 'lottery') // Filter out ticket purchases
                                    .map((transaction: any) => ({
                                        ...transaction,
                                        referredName: transaction.referredName || null,
                                    }))
                            }
                            configData={pointsHistory ? {
                                ...pointsHistory,
                                totalCount: pointsHistory.total || 0,
                                currentPage: pointsHistory.pageNumber || page,
                                totalPages: pointsHistory.total ? Math.ceil(pointsHistory.total / (pointsHistory.pageSize || perPage)) : 0,
                                pageSize: pointsHistory.pageSize || perPage,
                            } : null}
                            page={page}
                            perPage={perPage}
                            setPage={setPage}
                            setPerPage={setPerPage}
                            notHavePaging={false}
                        />
                    )}
                </TabPane>
            </Tabs>

        </>
    );
};

export default Lottery;
