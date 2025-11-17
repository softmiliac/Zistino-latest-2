import { FC } from "react";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";
import { HiBell } from "react-icons/hi";
import { Card } from "antd";

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
        },
        validateOnChange: false,
        validateOnBlur: false,
        onSubmit: (values) => {
            if (!values.phoneNumber || !values.message) {
                errorAlert({ title: t("please_fill_all_fields") || "لطفا تمام فیلدها را پر کنید" });
                return;
            }
            sendNotification
                .mutateAsync({
                    phoneNumber: values.phoneNumber,
                    message: values.message,
                    userId: values.userId || undefined,
                })
                .then(() => {
                    notificationFormik.resetForm();
                    successAlert({ title: t("notification_sent_successfully") || "اعلان با موفقیت ارسال شد" });
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
                        <Input
                            label={t("phone_number") || "شماره تلفن"}
                            name="phoneNumber"
                            placeholder="09123456789 یا +989123456789"
                            onChange={notificationFormik.handleChange}
                            value={notificationFormik.values.phoneNumber}
                            error={notificationFormik.errors.phoneNumber}
                            required
                        />

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

