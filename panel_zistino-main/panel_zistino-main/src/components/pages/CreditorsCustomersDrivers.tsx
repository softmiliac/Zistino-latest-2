import { FC, useState } from "react";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";
import { HiPlusSm, HiUser, HiTruck, HiCurrencyDollar } from "react-icons/hi";
import { Tabs } from "antd";
import moment from "jalali-moment";

const { TabPane } = Tabs;

import {
  useUpdateWallet,
  useCreateWallet,
  useDeleteWallet,
  Button,
  Drawer,
  Input,
  Select,
  useWallet,
  errorAlert,
  useUserData,
  useAllUserData,
  ProTable,
  SingleSelect,
  successAlert,
  put,
  useCustomerCredits,
  useDriverCredits,
  useRecordManualPayment,
  useDriverPayoutTiers,
  useSetDriverPayoutTiers,
  useWeightRangeMinimums,
  useSetWeightRangeMinimums,
  useWeightShortfalls,
} from "../..";
import { ColumnsType } from "antd/lib/table";
import { useQueryClient } from "react-query";

const CreditorsCustomersDrivers: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState("");
  const [filteredUserId, setFilteredUserId] = useState("");
  const [activeTab, setActiveTab] = useState<string>("transactions");

  // Customer Credits state
  const [customerPage, setCustomerPage] = useState<number>(1);
  const [customerPerPage, setCustomerPerPage] = useState<number>(10);
  const [customerSearchValue, setCustomerSearchValue] = useState("");
  const [customerUserId, setCustomerUserId] = useState<string>("");

  // Driver Credits state
  const [driverPage, setDriverPage] = useState<number>(1);
  const [driverPerPage, setDriverPerPage] = useState<number>(10);
  const [driverSearchValue, setDriverSearchValue] = useState("");
  const [driverId, setDriverId] = useState<string>("");
  const [dateFrom, setDateFrom] = useState<string>("");
  const [dateTo, setDateTo] = useState<string>("");

  // Weight Shortfalls state
  const [shortfallPage, setShortfallPage] = useState<number>(1);
  const [shortfallPerPage, setShortfallPerPage] = useState<number>(10);
  const [shortfallUserId, setShortfallUserId] = useState<string>("");
  const [shortfallIsDeducted, setShortfallIsDeducted] = useState<boolean | undefined>(undefined);
  const [shortfallDateFrom, setShortfallDateFrom] = useState<string>("");
  const [shortfallDateTo, setShortfallDateTo] = useState<string>("");
  const [showManualPayment, setShowManualPayment] = useState<boolean>(false);
  const [showPayoutTiers, setShowPayoutTiers] = useState<boolean>(false);
  const [editingTiers, setEditingTiers] = useState<Array<{ min: number; max: number | null; rate: number }>>([]);
  const [showWeightRanges, setShowWeightRanges] = useState<boolean>(false);
  const [editingRanges, setEditingRanges] = useState<Array<{ value: string; min: number }>>([]);

  const { t } = useTranslation();

  const [selectedProductId, setSelectedProductId] = useState("");
  const { data: wallet, isLoading } = useWallet(
    page,
    perPage,
    searchValue,
    filteredUserId === "" ? undefined : filteredUserId
  );
  const { data: currentUser } = useUserData();
  const { data: users } = useAllUserData();
  const paymentTypes = [t("debit"), t("credit")];

  // Credit Reports hooks
  const { data: customerCredits, isLoading: loadingCustomerCredits } = useCustomerCredits(
    customerPage,
    customerPerPage,
    customerSearchValue,
    customerUserId || undefined
  );
  const { data: driverCredits, isLoading: loadingDriverCredits } = useDriverCredits(
    driverPage,
    driverPerPage,
    driverSearchValue,
    driverId || undefined,
    dateFrom || undefined,
    dateTo || undefined
  );
  const { data: payoutTiersData, isLoading: loadingTiers } = useDriverPayoutTiers();
  const setPayoutTiers = useSetDriverPayoutTiers();
  const { data: weightRangesData, isLoading: loadingWeightRanges } = useWeightRangeMinimums();
  const setWeightRanges = useSetWeightRangeMinimums();
  const { data: weightShortfalls, isLoading: loadingShortfalls } = useWeightShortfalls(
    shortfallPage,
    shortfallPerPage,
    shortfallUserId || undefined,
    shortfallIsDeducted,
    shortfallDateFrom || undefined,
    shortfallDateTo || undefined
  );

  const status = ["در حال بررسی", "تایید شده", "رد شده"];
  const queryClient = useQueryClient();

  const changeStatusHandler = async (
    value: number,
    id: number,
    record: any
  ) => {
    record.status = value;
    const res = await put(`/v1/transactionwallet/${id}`, record);
    if (res.data.succeeded) {
      queryClient.invalidateQueries("transactionwallet");
      successAlert({ title: `وضعیت به ${status[value]} تغییر کرد` });
    } else {
      errorAlert({ title: "خطایی در تغییر وضعیت رخ داد" });
    }
  };

  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("Sender_Id"),
      dataIndex: "senderId",
      render: (value) =>
        value
          ? `${users?.data?.find((x: any) => x.id === value)?.firstName}  ${users?.data?.find((x: any) => x.id === value)?.lastName
          }`
          : "کاربر",
    },
    {
      title: t("user"),
      dataIndex: "userId",
      render: (value) =>
        value
          ? `${users?.data?.find((x: any) => x.id === value)?.firstName}  ${users?.data?.find((x: any) => x.id === value)?.lastName
          }`
          : "",
    },
    {
      title: t("status"),
      dataIndex: "status",
      render: (value) => status[value ?? 0],
    },
    {
      title: t("price"),
      dataIndex: "price",
    },
    {
      title: t("type"),
      dataIndex: "type",
      render: (value) => paymentTypes[value],
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <div className="col-span-10 my-2">
              <SingleSelect
                showSearch={false}
                placeholder="order status"
                handler={(value: any) =>
                  changeStatusHandler(parseInt(value), record.id, record)
                }
                defaultValue={JSON.stringify(record.status ?? 0)}
              >
                <option value="0">در حال بررسی</option>
                <option value="1">تایید شده</option>
                <option value="2">رد شده</option>
              </SingleSelect>
            </div>
          </>
        );
      },
    },
  ];

  const deleteWallet = useDeleteWallet();
  const createWallet = useCreateWallet();
  const updateWallet = useUpdateWallet(selectedProductId);
  const recordManualPayment = useRecordManualPayment();

  const selectedProduct: any = wallet?.data?.filter(
    (p: any) => p.id === selectedProductId
  )[0];

  const createFormik = useFormik({
    initialValues: {
      userId: "",
      senderId: currentUser?.id,
      type: 0,
      price: 0,
      finished: false,
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: false,
    onSubmit: (values: any) => {
      values.senderId = currentUser?.id;
      const finalValues = {
        userId: values?.userId,
        senderId: values?.senderId,
        type: values?.type,
        price: +values?.type === 0 ? values?.price * -1 : values?.price,
        finished: values?.finished,
        status: 1,
      };
      createWallet
        .mutateAsync(finalValues)
        .then(() => {
          document.getElementById("create")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      userId: selectedProduct?.userId,
      senderId: selectedProduct?.senderId,
      type: selectedProduct?.type,
      price: selectedProduct?.price,
      finished: selectedProduct?.finished,
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: true,
    onSubmit: (values: any) => {
      const finalValues = {
        userId: values?.userId,
        senderId: values?.senderId,
        type: values?.type,
        price: +values?.type === 0 ? values?.price * -1 : values?.price,
        finished: values?.finished,
        status: values?.status,
      };
      updateWallet
        .mutateAsync(finalValues)
        .then(() => {
          document.getElementById("update-product")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const manualPaymentFormik = useFormik({
    initialValues: {
      userId: "",
      amount: 0,
      transactionType: "credit" as "credit" | "debit",
      description: "",
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: false,
    onSubmit: (values: any) => {
      if (!values.userId || values.amount <= 0) {
        errorAlert({ title: t("please_fill_all_fields") || "لطفا تمام فیلدها را پر کنید" });
        return;
      }
      recordManualPayment
        .mutateAsync({
          userId: values.userId,
          amount: parseFloat(values.amount),
          transactionType: values.transactionType,
          description: values.description || undefined,
        })
        .then((res) => {
          document.getElementById("manual-payment")?.click();
          manualPaymentFormik.resetForm();
          successAlert({
            title: `${t("payment_recorded_successfully") || "پرداخت با موفقیت ثبت شد"} - ${t("new_balance") || "موجودی جدید"}: ${res.newBalance} ${t("rials") || "ریال"}`
          });
        })
        .catch((err) => {
          errorAlert({ title: err?.message || t("error_occurred") || "خطایی رخ داد" });
        });
    },
  });

  // Customer Credits columns
  const customerCreditsColumns: ColumnsType<any> = [
    {
      title: t("user"),
      dataIndex: "fullName",
      render: (value, record) => (
        <div>
          <div>{value || record.phoneNumber}</div>
          <div className="text-xs text-gray-500">{record.phoneNumber}</div>
        </div>
      ),
    },
    {
      title: t("current_balance"),
      dataIndex: "currentBalance",
      render: (value) => `${parseFloat(value || 0).toLocaleString()} ${t("rials")}`,
    },
    {
      title: t("total_credits"),
      dataIndex: "totalCredits",
      render: (value) => `${parseFloat(value || 0).toLocaleString()} ${t("rials")}`,
    },
    {
      title: t("credit_count"),
      dataIndex: "creditCount",
    },
    {
      title: t("currency"),
      dataIndex: "currency",
    },
  ];

  // Driver Credits columns
  // Weight Shortfalls columns
  const weightShortfallsColumns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
      width: 100,
    },
    {
      title: t("customer_phone") || "شماره تماس مشتری",
      dataIndex: "userPhone",
      render: (value) => value || "-",
    },
    {
      title: t("weight_range") || "بازه وزنی",
      dataIndex: "estimated_range",
      render: (value) => value || "-",
    },
    {
      title: t("minimum_weight") || "حداقل وزن",
      dataIndex: "minimum_weight",
      render: (value) => value ? `${value} ${t("kg") || "کیلوگرم"}` : "-",
    },
    {
      title: t("delivered_weight") || "وزن تحویل شده",
      dataIndex: "delivered_weight",
      render: (value) => value ? `${value} ${t("kg") || "کیلوگرم"}` : "-",
    },
    {
      title: t("shortfall_amount") || "مقدار کسری",
      dataIndex: "shortfallAmount",
      render: (value) => {
        const numValue = parseFloat(value || "0");
        return (
          <span className={numValue < 0 ? "text-red-600 font-semibold" : ""}>
            {value ? `${value} ${t("kg") || "کیلوگرم"}` : "-"}
          </span>
        );
      },
    },
    {
      title: t("is_deducted") || "کسر شده",
      dataIndex: "is_deducted",
      render: (value) => {
        return value ? (
          <span className="text-green-600">{t("yes") || "بله"}</span>
        ) : (
          <span className="text-red-600">{t("no") || "خیر"}</span>
        );
      },
    },
    {
      title: t("created_at") || "تاریخ ایجاد",
      dataIndex: "createdAt",
      render: (value) => {
        if (!value) return "-";
        try {
          return moment(value).format("jYYYY/jMM/jDD HH:mm");
        } catch {
          return value;
        }
      },
    },
    {
      title: t("deducted_at") || "تاریخ کسر",
      dataIndex: "deductedAt",
      render: (value) => {
        if (!value) return "-";
        try {
          return moment(value).format("jYYYY/jMM/jDD HH:mm");
        } catch {
          return value;
        }
      },
    },
  ];

  const driverCreditsColumns: ColumnsType<any> = [
    {
      title: t("driver"),
      dataIndex: "fullName",
      render: (value, record) => (
        <div>
          <div>{value || record.phoneNumber}</div>
          <div className="text-xs text-gray-500">{record.phoneNumber}</div>
        </div>
      ),
    },
    {
      title: t("current_balance"),
      dataIndex: "currentBalance",
      render: (value) => `${parseFloat(value || 0).toLocaleString()} ${t("rials")}`,
    },
    {
      title: t("total_payouts"),
      dataIndex: "totalPayouts",
      render: (value) => `${parseFloat(value || 0).toLocaleString()} ${t("rials")}`,
    },
    {
      title: t("payout_count"),
      dataIndex: "payoutCount",
    },
    {
      title: t("total_deliveries"),
      dataIndex: "totalDeliveries",
      render: (value) => value || 0,
    },
    {
      title: t("total_weight"),
      dataIndex: "totalWeight",
      render: (value) => `${parseFloat(value || 0).toLocaleString()} ${t("kg")}`,
    },
    {
      title: t("currency"),
      dataIndex: "currency",
    },
  ];

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("creditors_customers_and_drivers")}
        </h2>
        {activeTab === "transactions" && (
          <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
            <Input
              placeholder={t("search")}
              className="md:w-[280px] w-full"
              onChange={(e) => setSearchValue(e.target.value)}
            />
            <Button onClick={() => setShowManualPayment(true)}>
              <label
                htmlFor="manual-payment"
                className="w-full h-full flex items-center cursor-pointer"
              >
                <HiCurrencyDollar className="text-2xl ltr:mr-1 rtl:ml-2" />
                {t("record_manual_payment") || "ثبت پرداخت دستی"}
              </label>
            </Button>
            <Button>
              <label
                htmlFor="create"
                className="w-full h-full flex items-center cursor-pointer"
              >
                <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
                {t("add")}
              </label>
            </Button>
          </div>
        )}
        {activeTab === "customer-credits" && (
          <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
            <Input
              placeholder={t("search")}
              className="md:w-[280px] w-full"
              onChange={(e) => setCustomerSearchValue(e.target.value)}
              value={customerSearchValue}
            />
          </div>
        )}
        {activeTab === "driver-credits" && (
          <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
            <Input
              placeholder={t("search")}
              className="md:w-[280px] w-full"
              onChange={(e) => setDriverSearchValue(e.target.value)}
              value={driverSearchValue}
            />
            <Button>
              <label
                htmlFor="payout-tiers"
                className="w-full h-full flex items-center cursor-pointer"
                onClick={() => {
                  setEditingTiers(payoutTiersData?.tiers || []);
                }}
              >
                {t("visit_count_ranges") || "تعریف بازه تعداد بازدید"}
              </label>
            </Button>
            <Button>
              <label
                htmlFor="weight-ranges"
                className="w-full h-full flex items-center cursor-pointer"
                onClick={() => {
                  setEditingRanges(weightRangesData?.ranges || []);
                }}
              >
                {t("weight_range_minimums") || "تعریف بازه‌های وزنی"}
              </label>
            </Button>
          </div>
        )}
      </div>

      <Tabs activeKey={activeTab} onChange={setActiveTab} className="mt-6">
        {/* Wallet Transactions Tab */}
        <TabPane
          tab={
            <span>
              <HiCurrencyDollar className="inline-block mr-2" />
              {t("wallet_transactions")}
            </span>
          }
          key="transactions"
        >
          <div style={{ paddingTop: "20px" }}>
            <SingleSelect
              handler={(e: any) => setFilteredUserId(e)}
              value={filteredUserId}
              style={{ width: "30%" }}
              showSearch
            >
              <option value=""></option>
              {users?.data?.map((value: any, index: any) => (
                <option key={value.id} value={value.id}>
                  {value.firstName} {value.lastName} ({value.phoneNumber})
                </option>
              ))}
            </SingleSelect>
          </div>
          {isLoading ? (
            <div>{t("loading")}</div>
          ) : (
            <ProTable
              columns={columns}
              dataSource={wallet?.data}
              configData={wallet}
              page={page}
              perPage={perPage}
              setPage={setPage}
              setPerPage={setPerPage}
            />
          )}
        </TabPane>

        {/* Customer Credits Report Tab */}
        <TabPane
          tab={
            <span>
              <HiUser className="inline-block mr-2" />
              {t("customer_credits_report")}
            </span>
          }
          key="customer-credits"
        >
          <div style={{ paddingTop: "20px", marginBottom: "20px" }}>
            <SingleSelect
              handler={(e: any) => setCustomerUserId(e)}
              value={customerUserId}
              style={{ width: "30%" }}
              showSearch
            >
              <option value="">{t("all_customers")}</option>
              {users?.data?.map((value: any, index: any) => (
                <option key={value.id} value={value.id}>
                  {value.firstName} {value.lastName} ({value.phoneNumber})
                </option>
              ))}
            </SingleSelect>
          </div>
          {loadingCustomerCredits ? (
            <div>{t("loading")}</div>
          ) : (
            <ProTable
              columns={customerCreditsColumns}
              dataSource={Array.isArray(customerCredits?.items) ? customerCredits.items : []}
              configData={customerCredits ? { ...customerCredits, totalCount: customerCredits.total || 0 } : null}
              page={customerPage}
              perPage={customerPerPage}
              setPage={setCustomerPage}
              setPerPage={setCustomerPerPage}
            />
          )}
        </TabPane>

        {/* Driver Credits Report Tab */}
        <TabPane
          tab={
            <span>
              <HiTruck className="inline-block mr-2" />
              {t("driver_credits_report")}
            </span>
          }
          key="driver-credits"
        >
          <div style={{ paddingTop: "20px", marginBottom: "20px" }} className="space-y-4">
            <div className="flex gap-4">
              <SingleSelect
                handler={(e: any) => setDriverId(e)}
                value={driverId}
                style={{ width: "30%" }}
                showSearch
              >
                <option value="">{t("all_drivers")}</option>
                {users?.data?.filter((u: any) => u.isDriver).map((value: any, index: any) => (
                  <option key={value.id} value={value.id}>
                    {value.firstName} {value.lastName} ({value.phoneNumber})
                  </option>
                ))}
              </SingleSelect>
              <Input
                type="date"
                placeholder={t("date_from")}
                className="md:w-[200px] w-full"
                onChange={(e) => setDateFrom(e.target.value)}
                value={dateFrom}
              />
              <Input
                type="date"
                placeholder={t("date_to")}
                className="md:w-[200px] w-full"
                onChange={(e) => setDateTo(e.target.value)}
                value={dateTo}
              />
            </div>
          </div>
          {loadingDriverCredits ? (
            <div>{t("loading")}</div>
          ) : (
            <ProTable
              columns={driverCreditsColumns}
              dataSource={Array.isArray(driverCredits?.items) ? driverCredits.items : []}
              configData={driverCredits ? { ...driverCredits, totalCount: driverCredits.total || 0 } : null}
              page={driverPage}
              perPage={driverPerPage}
              setPage={setDriverPage}
              setPerPage={setDriverPerPage}
            />
          )}
        </TabPane>

        {/* Weight Shortfalls Tab */}
        <TabPane
          tab={
            <span>
              <HiCurrencyDollar className="inline-block mr-2" />
              {t("weight_shortfalls") || "کسری‌های وزنی"}
            </span>
          }
          key="weight-shortfalls"
        >
          <div style={{ paddingTop: "20px", marginBottom: "20px" }} className="space-y-4">
            <div className="flex gap-4 flex-wrap">
              <SingleSelect
                handler={(e: any) => setShortfallUserId(e)}
                value={shortfallUserId}
                style={{ width: "30%" }}
                showSearch
              >
                <option value="">{t("all_customers")}</option>
                {users?.data?.map((value: any, index: any) => (
                  <option key={value.id} value={value.id}>
                    {value.firstName} {value.lastName} ({value.phoneNumber})
                  </option>
                ))}
              </SingleSelect>
              <Select
                value={shortfallIsDeducted === undefined ? "" : shortfallIsDeducted ? "true" : "false"}
                onChange={(e) => {
                  const value = e.target.value;
                  setShortfallIsDeducted(value === "" ? undefined : value === "true");
                }}
                style={{ width: "20%" }}
              >
                <option value="">{t("all") || "همه"}</option>
                <option value="false">{t("not_deducted") || "کسر نشده"}</option>
                <option value="true">{t("deducted") || "کسر شده"}</option>
              </Select>
              <Input
                type="date"
                placeholder={t("date_from")}
                className="md:w-[200px] w-full"
                onChange={(e) => setShortfallDateFrom(e.target.value)}
                value={shortfallDateFrom}
              />
              <Input
                type="date"
                placeholder={t("date_to")}
                className="md:w-[200px] w-full"
                onChange={(e) => setShortfallDateTo(e.target.value)}
                value={shortfallDateTo}
              />
            </div>
          </div>
          {loadingShortfalls ? (
            <div>{t("loading")}</div>
          ) : (
            <ProTable
              columns={weightShortfallsColumns}
              dataSource={Array.isArray(weightShortfalls?.items) ? weightShortfalls.items : []}
              configData={weightShortfalls ? { ...weightShortfalls, totalCount: weightShortfalls.total || 0 } : null}
              page={shortfallPage}
              perPage={shortfallPerPage}
              setPage={setShortfallPage}
              setPerPage={setShortfallPerPage}
            />
          )}
        </TabPane>
      </Tabs>
      <Drawer
        title={t("Add_Creditors_Customers_Drivers")}
        html="create"
        position="right"
      >
        <form
          onSubmit={createFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Select
            label={t("user")}
            name="userId"
            onChange={createFormik.handleChange}
            value={createFormik.values.userId}
            error={createFormik.errors.userId}
          >
            <option value="">{t("select")}</option>
            {users?.data?.map((value: any, index: any) => (
              <option key={value.id} value={value.id}>
                {value.firstName} {value.lastName} ({value.phoneNumber})
              </option>
            ))}
          </Select>
          <Select
            label={t("type")}
            name="type"
            onChange={createFormik.handleChange}
            value={createFormik.values.type}
            error={createFormik.errors.type}
          >
            <option value="">{t("select")}</option>
            {paymentTypes?.map((value: any, index) => (
              <option key={index} value={index}>
                {value}
              </option>
            ))}
          </Select>
          <Input
            label={t("price")}
            name="price"
            type="number"
            min="1"
            onChange={createFormik.handleChange}
            value={createFormik.values.price}
            error={createFormik.errors.price}
          />

          <Button
            type="submit"
            loading={createWallet.isLoading}
            className="btn-block font-semibold rtl:font-rtl-semibold"
          >
            {t("add")}
          </Button>
        </form>
      </Drawer>

      <Drawer
        title={t("record_manual_payment") || "ثبت پرداخت دستی"}
        html="manual-payment"
        position="right"
      >
        <form
          onSubmit={manualPaymentFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Select
            label={t("user") || "کاربر"}
            name="userId"
            onChange={manualPaymentFormik.handleChange}
            value={manualPaymentFormik.values.userId}
            error={manualPaymentFormik.errors.userId}
          >
            <option value="">{t("select") || "انتخاب کنید"}</option>
            {users?.data?.map((value: any) => (
              <option key={value.id} value={value.id}>
                {value.firstName} {value.lastName} ({value.phoneNumber})
              </option>
            ))}
          </Select>
          <Input
            label={t("amount") || "مبلغ"}
            name="amount"
            type="number"
            min={0.01}
            step={0.01}
            onChange={manualPaymentFormik.handleChange}
            value={manualPaymentFormik.values.amount}
            error={manualPaymentFormik.errors.amount}
          />
          <Select
            label={t("transaction_type") || "نوع تراکنش"}
            name="transactionType"
            onChange={manualPaymentFormik.handleChange}
            value={manualPaymentFormik.values.transactionType}
            error={manualPaymentFormik.errors.transactionType}
          >
            <option value="credit">{t("credit") || "بستانکار"}</option>
            <option value="debit">{t("debit") || "بدهکار"}</option>
          </Select>
          <Input
            label={t("description") || "توضیحات"}
            name="description"
            onChange={manualPaymentFormik.handleChange}
            value={manualPaymentFormik.values.description}
            error={manualPaymentFormik.errors.description}
          />
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={recordManualPayment.isLoading}
          >
            {t("record_payment") || "ثبت پرداخت"}
          </Button>
        </form>
      </Drawer>

      <Drawer title="Update Product" html="update-product" position="right">
        <form
          onSubmit={updateFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Select
            label={t("userId")}
            name="userId"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.userId}
            error={updateFormik.errors.userId}
          >
            <option value="">select</option>
            {users?.data?.map((value: any, index: any) => (
              <option key={value.id} value={value.id}>
                {value.firstName} {value.lastName} ({value.phoneNumber})
              </option>
            ))}
          </Select>
          <Select
            label={t("type")}
            name="type"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.type}
            error={updateFormik.errors.type}
          >
            <option value="">select</option>
            {paymentTypes?.map((value: any, index) => (
              <option key={index} value={index}>
                {value}
              </option>
            ))}
          </Select>
          <Input
            label={t("price")}
            name="price"
            type="number"
            min="0"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.price}
            error={updateFormik.errors.price}
          />
          <Button
            type="submit"
            loading={updateWallet.isLoading}
            className="btn-block font-semibold rtl:font-rtl-semibold"
          >
            Update
          </Button>
        </form>
      </Drawer>

      {/* Driver Payout Tiers Configuration Drawer */}
      <Drawer
        title={t("visit_count_ranges") || "تعریف بازه تعداد بازدید"}
        html="payout-tiers"
        position="right"
      >
        <div className="space-y-4">
          <div className="mb-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
            <p className="text-sm text-gray-700 dark:text-gray-300">
              {t("payout_tiers_explanation") || "پرداخت به رانندگان بر اساس تعداد بازدید مشتری و وزن کالای تحویل داده شده محاسبه می‌شود. فرمول: وزن (کیلوگرم) × نرخ (تومان/کیلوگرم)"}
            </p>
            <p className="text-sm text-gray-600 dark:text-gray-400 mt-2">
              {t("example_tiers") || "مثال: اگر مشتری 1-100 بازدید داشته باشد، هر کیلو 100 تومان. اگر 101-200 بازدید داشته باشد، هر کیلو 200 تومان."}
            </p>
          </div>

          <div className="space-y-3">
            {editingTiers.map((tier, index) => (
              <div key={index} className="flex gap-2 items-center p-3 border rounded-lg">
                <div className="flex-1">
                  <label className="block text-sm mb-1">{t("min_visits") || "حداقل بازدید"}</label>
                  <Input
                    type="number"
                    value={tier.min}
                    onChange={(e) => {
                      const newTiers = [...editingTiers];
                      newTiers[index].min = parseInt(e.target.value) || 1;
                      setEditingTiers(newTiers);
                    }}
                    min={1}
                  />
                </div>
                <div className="flex-1">
                  <label className="block text-sm mb-1">{t("max_visits") || "حداکثر بازدید (اختیاری)"}</label>
                  <Input
                    type="number"
                    value={tier.max || ""}
                    onChange={(e) => {
                      const newTiers = [...editingTiers];
                      newTiers[index].max = e.target.value ? parseInt(e.target.value) : null;
                      setEditingTiers(newTiers);
                    }}
                    min={tier.min}
                    placeholder={t("unlimited") || "نامحدود"}
                  />
                </div>
                <div className="flex-1">
                  <label className="block text-sm mb-1">{t("rate_per_kg") || "نرخ (تومان/کیلوگرم)"}</label>
                  <Input
                    type="number"
                    value={tier.rate}
                    onChange={(e) => {
                      const newTiers = [...editingTiers];
                      newTiers[index].rate = parseFloat(e.target.value) || 0;
                      setEditingTiers(newTiers);
                    }}
                    min={0}
                    step="0.01"
                  />
                </div>
                <Button
                  onClick={() => {
                    const newTiers = editingTiers.filter((_, i) => i !== index);
                    setEditingTiers(newTiers);
                  }}
                  className="mt-6"
                >
                  {t("delete")}
                </Button>
              </div>
            ))}
          </div>

          <Button
            onClick={() => {
              const newTiers = [...editingTiers, { min: 1, max: null, rate: 0 }];
              setEditingTiers(newTiers);
            }}
            className="w-full"
          >
            {t("add_tier") || "افزودن بازه"}
          </Button>

          <div className="flex gap-2 mt-6">
            <Button
              onClick={() => {
                document.getElementById("payout-tiers")?.click();
                setEditingTiers(payoutTiersData?.tiers || []);
              }}
              className="flex-1"
            >
              {t("cancel")}
            </Button>
            <Button
              onClick={() => {
                // Validate tiers
                let isValid = true;
                for (let i = 0; i < editingTiers.length; i++) {
                  const tier = editingTiers[i];
                  if (!tier.min || tier.min < 1) {
                    errorAlert({ title: t("min_visits_required") || "حداقل بازدید باید عددی مثبت باشد" });
                    isValid = false;
                    break;
                  }
                  if (tier.max !== null && tier.max < tier.min) {
                    errorAlert({ title: t("max_must_be_greater_than_min") || "حداکثر بازدید باید بیشتر از حداقل باشد" });
                    isValid = false;
                    break;
                  }
                  if (!tier.rate || tier.rate < 0) {
                    errorAlert({ title: t("rate_required") || "نرخ باید عددی مثبت باشد" });
                    isValid = false;
                    break;
                  }
                }
                if (!isValid) return;

                setPayoutTiers
                  .mutateAsync(editingTiers)
                  .then(() => {
                    successAlert({ title: t("tiers_saved_successfully") || "بازه‌های تعداد بازدید با موفقیت ذخیره شد" });
                    document.getElementById("payout-tiers")?.click();
                  })
                  .catch((err) => {
                    errorAlert({ title: err?.response?.data?.detail || err?.message || t("error_occurred") || "خطایی رخ داد" });
                  });
              }}
              loading={setPayoutTiers.isLoading}
              className="flex-1"
            >
              {t("save") || "ذخیره"}
            </Button>
          </div>

          {loadingTiers ? (
            <div className="mt-4">{t("loading")}</div>
          ) : payoutTiersData?.tiers && payoutTiersData.tiers.length > 0 ? (
            <div className="mt-6 p-4 bg-gray-50 dark:bg-gray-800 rounded-lg">
              <h3 className="font-semibold mb-3">{t("current_tiers") || "بازه‌های فعلی:"}</h3>
              <div className="space-y-2">
                {payoutTiersData.tiers.map((tier: any, index: number) => (
                  <div key={index} className="text-sm">
                    {tier.min} - {tier.max === null ? t("unlimited") || "نامحدود" : tier.max} {t("visits") || "بازدید"}: {tier.rate} {t("tomans_per_kg") || "تومان/کیلوگرم"}
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="mt-6 p-4 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg">
              <p className="text-sm">{t("no_tiers_configured") || "هیچ بازه‌ای تعریف نشده است. لطفا بازه‌ها را تعریف کنید."}</p>
            </div>
          )}
        </div>
      </Drawer>

      {/* Weight Range Minimums Configuration Drawer */}
      <Drawer
        title={t("weight_range_minimums") || "تعریف بازه‌های وزنی و حداقل وزن"}
        html="weight-ranges"
        position="right"
      >
        <div className="space-y-4">
          <div className="mb-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
            <p className="text-sm text-gray-700 dark:text-gray-300">
              {t("weight_range_minimums_explanation") || "برای هر بازه وزنی، حداقل وزن را تعریف کنید. اگر وزن تحویل شده از حداقل کمتر باشد، تفاوت منفی شده و از بار تحویلی بعدی کسر خواهد گردید."}
            </p>
            <p className="text-sm text-gray-600 dark:text-gray-400 mt-2">
              {t("weight_range_minimums_example") || "مثال: اگر بازه 5-10 کیلوگرم باشد و حداقل 5 کیلوگرم تعریف شود، و مشتری 3 کیلوگرم تحویل دهد، 2 کیلوگرم منفی شده و از تحویل بعدی کسر می‌شود."}
            </p>
          </div>

          <div className="space-y-3">
            {editingRanges.map((range, index) => (
              <div key={index} className="flex gap-2 items-end">
                <div className="flex-1">
                  <label className="block mb-1 text-sm font-semibold">
                    {t("weight_range") || "بازه وزنی"}
                  </label>
                  <Input
                    value={range.value}
                    onChange={(e) => {
                      const newRanges = [...editingRanges];
                      newRanges[index].value = e.target.value;
                      setEditingRanges(newRanges);
                    }}
                    placeholder="مثال: 2-5 یا 50+"
                  />
                </div>
                <div className="flex-1">
                  <label className="block mb-1 text-sm font-semibold">
                    {t("minimum_weight") || "حداقل وزن (کیلوگرم)"}
                  </label>
                  <Input
                    type="number"
                    min="0"
                    step="0.1"
                    value={range.min}
                    onChange={(e) => {
                      const newRanges = [...editingRanges];
                      newRanges[index].min = parseFloat(e.target.value) || 0;
                      setEditingRanges(newRanges);
                    }}
                    placeholder="0"
                  />
                </div>
                <Button
                  onClick={() => {
                    const newRanges = editingRanges.filter((_, i) => i !== index);
                    setEditingRanges(newRanges);
                  }}
                  className="bg-red-500 hover:bg-red-600"
                >
                  {t("delete") || "حذف"}
                </Button>
              </div>
            ))}

            <Button
              onClick={() => {
                setEditingRanges([...editingRanges, { value: "", min: 0 }]);
              }}
              className="w-full"
            >
              {t("add_range") || "افزودن بازه"}
            </Button>

            <div className="flex gap-2 mt-4">
              <Button
                onClick={() => {
                  // Validate ranges
                  let isValid = true;
                  for (const range of editingRanges) {
                    if (!range.value || range.value.trim() === "") {
                      errorAlert({ title: t("weight_range_required") || "لطفا بازه وزنی را وارد کنید" });
                      isValid = false;
                      break;
                    }
                    if (range.min < 0) {
                      errorAlert({ title: t("minimum_weight_must_be_positive") || "حداقل وزن باید مثبت باشد" });
                      isValid = false;
                      break;
                    }
                  }
                  if (!isValid) return;

                  setWeightRanges
                    .mutateAsync(editingRanges)
                    .then(() => {
                      successAlert({ title: t("weight_ranges_saved_successfully") || "بازه‌های وزنی با موفقیت ذخیره شدند" });
                    })
                    .catch((err: any) => {
                      errorAlert({ title: err?.response?.data?.detail || err?.message || t("error_occurred") || "خطایی رخ داد" });
                    });
                }}
                loading={setWeightRanges.isLoading}
                className="flex-1"
              >
                {t("save") || "ذخیره"}
              </Button>
              <Button
                onClick={() => {
                  setShowWeightRanges(false);
                  setEditingRanges(weightRangesData?.ranges || []);
                }}
                className="flex-1"
              >
                {t("cancel") || "انصراف"}
              </Button>
            </div>
          </div>

          {loadingWeightRanges ? (
            <div className="mt-4">{t("loading")}</div>
          ) : weightRangesData?.ranges && weightRangesData.ranges.length > 0 ? (
            <div className="mt-6 p-4 bg-gray-50 dark:bg-gray-800 rounded-lg">
              <h3 className="font-semibold mb-3">{t("current_ranges") || "بازه‌های فعلی:"}</h3>
              <div className="space-y-2">
                {weightRangesData.ranges.map((range: any, index: number) => (
                  <div key={index} className="text-sm">
                    {range.value}: {t("minimum") || "حداقل"} {range.min} {t("kg") || "کیلوگرم"}
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="mt-6 p-4 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg">
              <p className="text-sm">{t("no_ranges_configured") || "هیچ بازه‌ای تعریف نشده است. لطفا بازه‌ها را تعریف کنید."}</p>
            </div>
          )}
        </div>
      </Drawer>
    </>
  );
};

export default CreditorsCustomersDrivers;
