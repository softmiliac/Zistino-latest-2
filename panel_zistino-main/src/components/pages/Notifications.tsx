import { FC } from "react";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";
import { HiBell } from "react-icons/hi";
import { Card, Checkbox } from "antd";

import {
    Button,
    Input,
    TextArea,
    useSendNotification,
    errorAlert,
    successAlert,
} from "../..";

const Notifications: FC = () => {
    const { t } = useTranslation();
    const sendNotification = useSendNotification();

    const notificationFormik = useFormik({
        initialValues: {
            phoneNumber: "",
            message: "",
            userId: "",
            sendToAll: false,
        },
        validateOnChange: false,
        validateOnBlur: false,
        onSubmit: (values) => {
            if (!values.message) {
                errorAlert({ title: t("please_fill_message") || "لطفا متن پیام را وارد کنید" });
                return;
            }
            if (!values.sendToAll && !values.phoneNumber) {
                errorAlert({ title: t("please_enter_phone_or_select_all") || "لطفا شماره تلفن را وارد کنید یا گزینه ارسال به همه را انتخاب کنید" });
                return;
            }
            sendNotification
                .mutateAsync({
                    phoneNumber: values.sendToAll ? "" : values.phoneNumber,
                    message: values.message,
                    userId: values.userId || undefined,
                    sendToAll: values.sendToAll,
                })
                .then((response: any) => {
                    notificationFormik.resetForm();
                    if (values.sendToAll && response?.data?.sentToAll) {
                        const { successful, totalUsers } = response.data;
                        successAlert({
                            title: t("notification_sent_to_all_successfully") || `اعلان به ${successful} از ${totalUsers} کاربر ارسال شد`
                        });
                    } else {
                        successAlert({ title: t("notification_sent_successfully") || "اعلان با موفقیت ارسال شد" });
                    }
                })
                .catch((err: any) => {
                    errorAlert({
                        title: err?.response?.data?.error_message || err?.message || t("notification_send_failed") || "ارسال اعلان با خطا مواجه شد",
                    });
                });
        },
    });

    return (
        <div className="p-6">
            <div className="flex items-center gap-2 mb-6">
                <HiBell className="text-3xl text-blue-600" />
                <h1 className="text-2xl font-bold">
                    {t("notifications") || "اعلان‌ها"}
                </h1>
            </div>

            <Card>
                <div className="max-w-2xl">
                    <form onSubmit={notificationFormik.handleSubmit} className="space-y-5">
                        <div>
                            <Checkbox
                                checked={notificationFormik.values.sendToAll}
                                onChange={(e) => {
                                    notificationFormik.setFieldValue("sendToAll", e.target.checked);
                                    if (e.target.checked) {
                                        notificationFormik.setFieldValue("phoneNumber", "");
                                    }
                                }}
                                className="mb-3"
                            >
                                {t("send_to_all_users") || "ارسال به همه کاربران"}
                            </Checkbox>
                            <Input
                                label={t("phone_number") || "شماره تلفن"}
                                name="phoneNumber"
                                placeholder={notificationFormik.values.sendToAll ? t("disabled_when_sending_to_all") || "غیرفعال - در حال ارسال به همه" : "09123456789 یا +989123456789"}
                                onChange={notificationFormik.handleChange}
                                value={notificationFormik.values.phoneNumber}
                                error={notificationFormik.errors.phoneNumber}
                                disabled={notificationFormik.values.sendToAll}
                                required={!notificationFormik.values.sendToAll}
                            />
                        </div>

                        <TextArea
                            label={t("message") || "پیام"}
                            name="message"
                            rows={5}
                            placeholder={t("enter_message") || "متن پیام را وارد کنید..."}
                            onChange={notificationFormik.handleChange}
                            value={notificationFormik.values.message}
                            error={notificationFormik.errors.message}
                            required
                        />

                        <Input
                            label={t("user_id") || "شناسه کاربر (اختیاری)"}
                            name="userId"
                            placeholder={t("optional") || "اختیاری - برای ردیابی"}
                            onChange={notificationFormik.handleChange}
                            value={notificationFormik.values.userId}
                            error={notificationFormik.errors.userId}
                        />

                        <Button
                            type="submit"
                            className="btn-block font-semibold rtl:font-rtl-semibold"
                            loading={sendNotification.isLoading}
                        >
                            {t("send") || "ارسال"}
                        </Button>
                    </form>
                </div>
            </Card>
        </div>
    );
};

export default Notifications;

