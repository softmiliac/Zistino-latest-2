import { FC, useState } from "react";
import { HiStar, HiCurrencyDollar, HiUserGroup } from "react-icons/hi";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";
import { Tabs, Card, Tag } from "antd";

import {
    ProTable,
    useLotteryWinners,
    usePointsSearch,
    useDriversPointsList,
    useMyReferralCode,
    useMyReferrals,
} from "../../";

const { TabPane } = Tabs;

const Lottery: FC = () => {
    const [activeTab, setActiveTab] = useState("winners");
    const [page, setPage] = useState<number>(1);
    const [perPage, setPerPage] = useState<number>(10);

    const { t } = useTranslation();

    const { data: winners, isLoading: loadingWinners } = useLotteryWinners();
    const { data: pointsHistory, isLoading: loadingHistory } = usePointsSearch(page, perPage);
    const { data: driversList, isLoading: loadingDriversList } = useDriversPointsList(page, perPage);
    const { data: referralCode, isLoading: loadingCode } = useMyReferralCode();
    const { data: myReferrals, isLoading: loadingReferrals } = useMyReferrals();



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
            title: t("points") || "امتیاز",
            dataIndex: "points",
            render: (value) => (
                <Tag color={value > 0 ? "green" : "default"}>
                    {value || 0} {t("points")}
                </Tag>
            ),
        },
    ];

    const referralsColumns: ColumnsType<any> = [
        {
            title: t("user_name"),
            dataIndex: "userName",
            render: (value) => value || "-",
        },
        {
            title: t("referral_date"),
            dataIndex: "referralDate",
            render: (value) => value ? new Date(value).toLocaleDateString() : "-",
        },
        {
            title: t("status"),
            dataIndex: "status",
            render: (value) => {
                const statusMap: { [key: string]: string } = {
                    "pending": t("pending"),
                    "completed": t("completed"),
                    "awarded": t("awarded"),
                    "active": t("active"),
                };
                return (
                    <Tag color={value === "completed" || value === "awarded" ? "green" : value === "pending" ? "orange" : "default"}>
                        {statusMap[value] || value}
                    </Tag>
                );
            },
        },
    ];

    return (
        <>
            <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
                <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
                    {t("lottery")}
                </h2>
            </div>

            {/* Referral Code Card */}
            {referralCode?.data?.code && (
                <Card className="mb-6">
                    <div className="flex items-center justify-between">
                        <div>
                            <p className="text-gray-600 dark:text-gray-400">{t("my_referral_code")}</p>
                            <h3 className="text-xl font-mono font-bold">{referralCode.data.code}</h3>
                        </div>
                        <HiUserGroup className="text-4xl text-blue-500" />
                    </div>
                </Card>
            )}

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
                    {loadingDriversList ? (
                        <div>{t("loading")}</div>
                    ) : (
                        <ProTable
                            columns={pointsHistoryColumns}
                            dataSource={
                                Array.isArray(driversList?.items) ? driversList.items : Array.isArray(driversList?.data) ? driversList.data : []
                            }
                            configData={driversList ? { ...driversList, totalCount: driversList.total || driversList.data?.length || 0 } : null}
                            page={page}
                            perPage={perPage}
                            setPage={setPage}
                            setPerPage={setPerPage}
                            notHavePaging={false}
                        />
                    )}
                </TabPane>

                {/* My Referrals Tab */}
                <TabPane
                    tab={
                        <span>
                            <HiUserGroup className="inline-block mr-2" />
                            {t("my_referrals")}
                        </span>
                    }
                    key="referrals"
                >
                    {loadingReferrals ? (
                        <div>{t("loading")}</div>
                    ) : (
                        <ProTable
                            columns={referralsColumns}
                            dataSource={Array.isArray(myReferrals?.items) ? myReferrals.items.map((referral: any) => ({
                                ...referral,
                                userName: referral.referredName || referral.userName,
                                referralDate: referral.createdAt || referral.referralDate,
                            })) : Array.isArray(myReferrals?.data) ? myReferrals.data.map((referral: any) => ({
                                ...referral,
                                userName: referral.referredName || referral.userName,
                                referralDate: referral.createdAt || referral.referralDate,
                            })) : []}
                            configData={myReferrals ? { ...myReferrals, totalCount: myReferrals.total || myReferrals.data?.length || 0 } : null}
                            page={page}
                            perPage={perPage}
                            setPage={setPage}
                            setPerPage={setPerPage}
                            notHavePaging={true}
                        />
                    )}
                </TabPane>
            </Tabs>

        </>
    );
};

export default Lottery;
