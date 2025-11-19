import { FC, useState, useEffect } from "react";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";
import { HiPlusSm, HiPencil, HiDocumentSearch, HiCurrencyDollar, HiPhone } from "react-icons/hi";

import {
  useCreateAllDriverDelivery,
  Button,
  Drawer,
  Input,
  Select,
  useDriverDelivery,
  errorAlert,
  DELIVERY_STATUS,
  useUserData,
  useDriversAll,
  ProTable,
  useZoneAll,
  ActionIcon,
  Modal,
  useDriverDeliverySP,
  useOrdersGet,
  useDeliveryPrice,
  useCreateTelephoneRequest,
  successAlert,
} from "../..";
import { ColumnsType } from "antd/lib/table";
import moment from "jalali-moment";
import { Tag } from "antd";
import DatePicker from "react-multi-date-picker";
import TimePicker from "react-multi-date-picker/plugins/time_picker";
import persian from "react-date-object/calendars/persian";
import persian_fa from "react-date-object/locales/persian_fa";

const { CheckableTag } = Tag;
const CollectionRequest: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState("");
  const [searchValueTag, setSearchValueTag] = useState<number | undefined>(
    undefined
  );
  const [selectedCouponId, setSelectedCouponId] = useState<any>("");

  const [selectedOrderId, setSelectedOrderId] = useState<string | undefined>(
    undefined
  );
  const [selectedPreOrderId, setSelectedPreOrderId] = useState<
    string | undefined
  >(undefined);

  const { t } = useTranslation();
  const { data: selectedOrder } = useOrdersGet(selectedOrderId) as any;
  const { data: preSelectedOrder } = useOrdersGet(selectedPreOrderId) as any;

  const [selectedId, setSelectedId] = useState("");
  const [selectedPriceId, setSelectedPriceId] = useState<string>("");
  const [showTelephoneRequest, setShowTelephoneRequest] = useState<boolean>(false);

  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("customer"),
      dataIndex: "customer_name",
      render: (value, record) => {
        // Backend now returns customer_name directly
        if (value) return value;
        // Fallback to order.user if available
        if (record.order?.user) {
          const user = record.order.user;
          return `${user.first_name || ""} ${user.last_name || ""}`.trim() || user.phone_number || "-";
        }
        // Fallback to creator if available (for compatibility)
        if (record.creator) {
          return record.creator;
        }
        return "-";
      },
    },
    {
      title: t("driver"),
      dataIndex: "driver",
      render: (value, record) => {
        // Backend returns driver object or driver_name
        if (record.driver_name) {
          return record.driver_name;
        }
        if (record.driver) {
          if (typeof record.driver === "object") {
            return `${record.driver.first_name || ""} ${record.driver.last_name || ""}`.trim() || record.driver.phone_number || "-";
          }
          return record.driver;
        }
        // Fallback to dirver (typo) for compatibility
        if (record.dirver) {
          return record.dirver;
        }
        return "-";
      },
    },
    {
      title: t("zone"),
      dataIndex: "address",
      render: (value) => value || "-",
    },
    {
      title: t("phone_number"),
      dataIndex: "phone_number",
      render: (value, record) => {
        // Backend returns phone_number (snake_case) - this is the delivery phone
        if (value) return value;
        // Try customer_phone from serializer
        if (record.customer_phone) return record.customer_phone;
        // Fallback to phoneNumber (camelCase) for compatibility
        if (record.phoneNumber) return record.phoneNumber;
        // Try to get from order user
        if (record.order?.user?.phone_number) return record.order.user.phone_number;
        return "-";
      },
    },
    {
      title: t("description"),
      dataIndex: "description",
      render: (value) => value || "-",
    },
    {
      title: t("date"),
      dataIndex: "created_at",
      render: (value, record) => {
        // Backend returns created_at (snake_case)
        const dateValue = value || record.createdOn || record.createdAt;
        if (dateValue) {
          return moment(dateValue).locale("fa").format("HH:mm  -  YYYY/MM/DD");
        }
        return "-";
      },
    },
    {
      title: t("status"),
      dataIndex: "status",
      render: (value) => {
        const statusValue = value !== undefined && value !== null ? value : "-";
        const statusText = value !== undefined && value !== null ? t(DELIVERY_STATUS[value]) : "";
        return `${statusValue}${statusText ? "  -  " + statusText : ""}`;
      },
    },
    {
      title: t("actions"),
      render: ({ status, id }) => {
        // Map backend string status to numeric for compatibility
        // Backend returns: 'assigned', 'in_progress', 'completed', 'cancelled'
        // Frontend expects: 0=assigned, 1=in_progress, 2=completed, 3=cancelled
        const statusMap: { [key: string]: number } = {
          'assigned': 0,
          'in_progress': 1,
          'completed': 2,
          'cancelled': 3,
        };
        const statusNum = typeof status === 'string' ? statusMap[status] : status;

        return (
          <>
            <ActionIcon onClick={() => setSelectedId(id)}>
              <label htmlFor="modal-user-roles" className="cursor-pointer">
                <HiDocumentSearch className="text-2xl" />
              </label>
            </ActionIcon>
            <ActionIcon onClick={() => setSelectedPriceId(id)}>
              <label htmlFor="modal-delivery-price" className="cursor-pointer">
                <HiCurrencyDollar className="text-2xl text-green-600" />
              </label>
            </ActionIcon>
          </>
        );
      },
    },
  ];

  const { data: driverDeliveryData, isLoading } = useDriverDeliverySP(
    page,
    perPage,
    searchValue,
    searchValueTag
  );
  const driverDelivery = driverDeliveryData?.data;

  const selectedDriverDelivery: any = driverDelivery?.data?.filter(
    (p: any) => p.id === selectedId
  )[0];

  const { data: priceResponse, isLoading: loadingPrice, error: priceError } = useDeliveryPrice(selectedPriceId);
  // Backend returns data directly, not wrapped in a 'data' key
  const priceData = priceResponse?.data || priceResponse;


  const { data: currentUser } = useUserData();
  const { data: users } = useDriversAll();
  const { data: allZone } = useZoneAll();

  const createDriverDelivery = useCreateAllDriverDelivery();
  const createTelephoneRequest = useCreateTelephoneRequest();

  const createFormik = useFormik({
    initialValues: {
      phoneNumber: "",
      address: "",
      plate: "",
      title: "",
      firstName: "",
      lastName: "",
      deliveryUserId: "",
      setUserId: "",
      description: "",
      deliveryDate: "",
      zoneId: 0,
      status: 2,
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: false,
    onSubmit: (values: any) => {
      const finalValues: any = {
        delivery: {
          userId: "00000000-0000-0000-0000-000000000000",
          deliveryUserId: values.deliveryUserId,
          zoneId: values.zoneId,
          deliveryDate: moment(
            values.deliveryDate?.toDate?.().toString()
          ).format("YYYY-MM-DDTHH:mm"),
          status: values.status,
          setUserId: currentUser?.id,
          description: values.description,
        },
        address: {
          phoneNumber: values.phoneNumber,
          address: values.address,
          plate: values.plate,
          title: values.title,
          id: 0,
          userId: "00000000-0000-0000-0000-000000000000",
          latitude: 0,
          longitude: 0,
          description: values.plate,
        },
        userInfo: {
          phoneNumber: values.phoneNumber,
          email: values.phoneNumber + "@p.com",
          firstName: values.firstName,
          lastName: values.lastName,
          userName: values.phoneNumber,
          password: "123456",
          confirmPassword: "123456",
          birthdate: "1998-11-14T18:29:48.877Z",
          codeMeli: "",
        },
      };
      values.setUserId = currentUser?.id;
      createDriverDelivery
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


  const telephoneRequestFormik = useFormik({
    initialValues: {
      phoneNumber: "",
      fullName: "",
      address: "",
      latitude: "",
      longitude: "",
      preferredDeliveryDate: "",
      createDelivery: true,
      items: [] as any[],
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: false,
    onSubmit: (values: any) => {
      if (!values.phoneNumber) {
        errorAlert({ title: t("phone_number_required") || "شماره تلفن الزامی است" });
        return;
      }
      const data: any = {
        phoneNumber: values.phoneNumber,
        fullName: values.fullName || undefined,
        address: values.address || undefined,
        createDelivery: values.createDelivery !== false,
      };
      if (values.latitude && values.longitude) {
        data.latitude = parseFloat(values.latitude);
        data.longitude = parseFloat(values.longitude);
      }
      if (values.preferredDeliveryDate) {
        data.preferredDeliveryDate = new Date(values.preferredDeliveryDate).toISOString();
      }
      if (values.items && values.items.length > 0) {
        data.items = values.items;
      }
      createTelephoneRequest
        .mutateAsync(data)
        .then((res) => {
          document.getElementById("telephone-request")?.click();
          telephoneRequestFormik.resetForm();
          successAlert({
            title: t("telephone_request_created") || "درخواست تلفنی با موفقیت ثبت شد" + (res?.message ? `: ${res.message}` : "")
          });
        })
        .catch((err) => {
          errorAlert({ title: err?.message || t("error_occurred") || "خطایی رخ داد" });
        });
    },
  });

  const paymentTypes = [t("debit"), t("credit")];


  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("collection_request")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button onClick={() => setShowTelephoneRequest(true)}>
            <label
              htmlFor="telephone-request"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPhone className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("record_phone_request") || "ثبت درخواست تلفنی"}
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
      </div>
      <div style={{ paddingTop: "20px" }}>
        <CheckableTag
          checked={searchValueTag == undefined}
          onClick={() => setSearchValueTag(undefined)}
        >
          همه
        </CheckableTag>
        <CheckableTag
          checked={searchValueTag == 12}
          onClick={() => setSearchValueTag(12)}
        >
          فعال
        </CheckableTag>
        <CheckableTag
          checked={searchValueTag == 13}
          onClick={() => setSearchValueTag(13)}
        >
          تمام شده ها
        </CheckableTag>
        <CheckableTag
          checked={searchValueTag == 14}
          onClick={() => setSearchValueTag(14)}
        >
          لغو شده ها
        </CheckableTag>
        <CheckableTag
          checked={searchValueTag == 16}
          onClick={() => setSearchValueTag(16)}
        >
          دریافتی از راننده ها
        </CheckableTag>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={driverDelivery?.data}
          configData={driverDelivery}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}
      <Drawer title={t("new request")} html="create" position="right">
        <form
          onSubmit={createFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Input
            label={t("firstname")}
            name="firstName"
            onChange={createFormik.handleChange}
            value={createFormik.values.firstName}
            error={createFormik.errors.firstName}
          />
          <Input
            label={t("lastname")}
            name="lastName"
            onChange={createFormik.handleChange}
            value={createFormik.values.lastName}
            error={createFormik.errors.lastName}
          />
          <Input
            label={t("phone_number")}
            name="phoneNumber"
            onChange={createFormik.handleChange}
            value={createFormik.values.phoneNumber}
            error={createFormik.errors.phoneNumber}
          />
          <Input
            label={t("address")}
            name="address"
            onChange={createFormik.handleChange}
            value={createFormik.values.address}
            error={createFormik.errors.address}
          />
          <Input
            label={t("plate_address")}
            name="plate"
            onChange={createFormik.handleChange}
            value={createFormik.values.plate}
            error={createFormik.errors.plate}
          />
          <Input
            label={t("title_address")}
            name="title"
            onChange={createFormik.handleChange}
            value={createFormik.values.title}
            error={createFormik.errors.title}
          />
          <Select
            label={t("driver")}
            name="deliveryUserId"
            onChange={createFormik.handleChange}
            value={createFormik.values.deliveryUserId}
            error={createFormik.errors.deliveryUserId}
          >
            <option value="">{t("select")}</option>
            {users?.data?.map((value: any, index: any) => (
              <option key={value.id} value={value.id}>
                {value.firstName} {value.lastName}
              </option>
            ))}
          </Select>
          <Select
            label={t("zone")}
            name="zoneId"
            onChange={createFormik.handleChange}
            value={createFormik.values.zoneId}
            error={createFormik.errors.zoneId}
          >
            <option value="">{t("select")}</option>
            {allZone?.data?.map((value: any, index: any) => (
              <option key={value.id} value={value.id}>
                {value?.zone}
              </option>
            ))}
          </Select>
          <div
            style={{
              width: "100%",
            }}
          >
            <label className="label mb-2">
              <span className="label-text dark:text-gray-200 text-gray-500">
                تاریخ
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
              format="MM/DD/YYYY HH:mm:ss"
              plugins={[<TimePicker position="bottom" />]}
              onChange={(value) =>
                createFormik.setFieldValue("deliveryDate", value)
              }
              value={createFormik.values.deliveryDate}
              calendar={persian}
              locale={persian_fa}
            />
          </div>
          <Input
            label={t("description")}
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />
          <Button
            type="submit"
            loading={createDriverDelivery.isLoading}
            className="btn-block font-semibold rtl:font-rtl-semibold"
          >
            {t("Add request")}
          </Button>
        </form>
      </Drawer>
      <Modal html="modal-user-roles" title={t("DriverDeliverydetail")}>
        {selectedDriverDelivery &&
          Object.keys(selectedDriverDelivery).map((item, index) => {
            if (index === 0) {
              if (
                selectedDriverDelivery["orderId"] &&
                selectedOrderId !== selectedDriverDelivery["orderId"]
              )
                setSelectedOrderId(selectedDriverDelivery["orderId"]);
              if (
                selectedDriverDelivery["preOrderId"] &&
                selectedPreOrderId !== selectedDriverDelivery["preOrderId"]
              )
                setSelectedPreOrderId(selectedDriverDelivery["preOrderId"]);
            }

            return selectedDriverDelivery[item] &&
              item != "longitude" &&
              item != "latitude" ? (
              <p>
                <span style={{ lineHeight: "1.7", marginLeft: 5 }}>
                  {t(item)} :{"    "}
                </span>
                <span style={{ fontWeight: "bolder" }}>
                  {item == "status" ? (
                    t(DELIVERY_STATUS[selectedDriverDelivery[item]])
                  ) : item == "createdOn" ? (
                    moment(selectedDriverDelivery[item])
                      .locale("fa")
                      .format("HH:mm  -  YYYY/MM/DD")
                  ) : item == "deliveryDate" ? (
                    moment(selectedDriverDelivery[item])
                      .locale("fa")
                      .format("HH:mm  -  YYYY/MM/DD")
                  ) : item == "preOrderId" ? (
                    <>
                      <table
                        border={1}
                        width="100%"
                        style={{ textAlign: "right" }}
                      >
                        {preSelectedOrder?.data?.orderItems?.map(
                          (item: any) => (
                            <tr dir="ltr" className="list-decimal list-inside ">
                              <td key={item.productId}>
                                <span style={{ padding: "15px" }}>
                                  {item.productName}
                                </span>
                              </td>
                              <td key={item.productId}>
                                <span style={{ padding: "15px" }}>
                                  {item.itemCount}
                                </span>
                              </td>
                              <td key={item.productId}>
                                <span style={{ padding: "15px" }}>
                                  {item.unitPrice}
                                </span>
                              </td>
                            </tr>
                          )
                        )}
                      </table>
                    </>
                  ) : item == "orderId" ? (
                    <>
                      <table
                        border={1}
                        width="100%"
                        style={{ textAlign: "right" }}
                      >
                        {selectedOrder?.data?.orderItems?.map((item: any) => (
                          <tr dir="ltr" className="list-decimal list-inside ">
                            <td key={item.productId}>
                              <span style={{ padding: "15px" }}>
                                {item.productName}
                              </span>
                            </td>
                            <td key={item.productId}>
                              <span style={{ padding: "15px" }}>
                                {item.itemCount}
                              </span>
                            </td>
                            <td key={item.productId}>
                              <span style={{ padding: "15px" }}>
                                {item.unitPrice}
                              </span>
                            </td>
                          </tr>
                        ))}
                      </table>
                    </>
                  ) : (
                    selectedDriverDelivery[item]
                  )}
                </span>
              </p>
            ) : (
              ""
            );
          })}
      </Modal>

      {/* Price Calculation Modal */}
      <Modal
        html="modal-delivery-price"
        title={t("delivery_price_calculation") || "محاسبه قیمت تحویل"}
        visible={!!selectedPriceId}
        onCancel={() => setSelectedPriceId("")}
        footer={null}
      >
        {loadingPrice ? (
          <div>{t("loading")}</div>
        ) : priceError ? (
          <div className="text-red-500">{t("error_occurred") || "خطایی رخ داد"}: {(priceError as any)?.message || JSON.stringify(priceError)}</div>
        ) : priceData && (priceData.deliveryId || priceData.delivery_id) ? (
          <div className="space-y-4">
            <div className="border-b pb-3">
              <p className="text-sm text-gray-600">{t("delivery_id") || "شناسه تحویل"}: {priceData.deliveryId || priceData.delivery_id}</p>
              <p className="text-sm text-gray-600">{t("rate_source") || "منبع نرخ"}: {priceData.rateSource || priceData.rate_source}</p>
            </div>

            {priceData.breakdown && Array.isArray(priceData.breakdown) && priceData.breakdown.length > 0 ? (
              <>
                <div className="overflow-x-auto">
                  <table className="w-full border-collapse border border-gray-300">
                    <thead>
                      <tr className="bg-gray-100">
                        <th className="border border-gray-300 p-2 text-right">{t("category") || "دسته‌بندی"}</th>
                        <th className="border border-gray-300 p-2 text-right">{t("weight") || "وزن (کیلوگرم)"}</th>
                        <th className="border border-gray-300 p-2 text-right">{t("rate_per_kg") || "نرخ (ریال/کیلوگرم)"}</th>
                        <th className="border border-gray-300 p-2 text-right">{t("amount") || "مبلغ (ریال)"}</th>
                      </tr>
                    </thead>
                    <tbody>
                      {priceData.breakdown.map((item: any, index: number) => (
                        <tr key={index}>
                          <td className="border border-gray-300 p-2">{item.categoryName}</td>
                          <td className="border border-gray-300 p-2 text-left">{item.weight}</td>
                          <td className="border border-gray-300 p-2 text-left">{parseFloat(item.rate).toLocaleString()}</td>
                          <td className="border border-gray-300 p-2 text-left font-semibold">{parseFloat(item.amount).toLocaleString()}</td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
                <div className="mt-4 p-4 bg-gray-50 rounded">
                  <div className="flex justify-between items-center">
                    <span className="font-semibold">{t("total_weight") || "وزن کل"}:</span>
                    <span className="font-semibold">{priceData.totalWeight || priceData.total_weight} {t("kg") || "کیلوگرم"}</span>
                  </div>
                  <div className="flex justify-between items-center mt-2">
                    <span className="font-bold text-lg">{t("total_amount") || "مبلغ کل"}:</span>
                    <span className="font-bold text-lg text-green-600">
                      {parseFloat(priceData.totalAmount || priceData.total_amount || "0").toLocaleString()} {priceData.currency || t("rials") || "ریال"}
                    </span>
                  </div>
                </div>
              </>
            ) : (
              <div className="p-4 bg-gray-50 rounded">
                <p className="text-gray-600 mb-2">{t("total_weight") || "وزن کل"}: {priceData.totalWeight || priceData.total_weight} {t("kg") || "کیلوگرم"}</p>
                <p className="text-lg font-bold text-green-600">
                  {t("total_amount") || "مبلغ کل"}: {parseFloat(priceData.totalAmount || priceData.total_amount || "0").toLocaleString()} {priceData.currency || t("rials") || "ریال"}
                </p>
                <p className="text-sm text-gray-500 mt-2">
                  ({t("using_global_rate") || "استفاده از نرخ سراسری"})
                </p>
              </div>
            )}
          </div>
        ) : (
          <div>{t("no_data") || "داده‌ای یافت نشد"}</div>
        )}
      </Modal>

      <Drawer
        title={t("record_phone_request") || "ثبت درخواست تلفنی"}
        html="telephone-request"
        position="right"
      >
        <form
          onSubmit={telephoneRequestFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Input
            label={t("phone_number") || "شماره تلفن"}
            name="phoneNumber"
            onChange={telephoneRequestFormik.handleChange}
            value={telephoneRequestFormik.values.phoneNumber}
            error={telephoneRequestFormik.errors.phoneNumber}
            required
          />
          <Input
            label={t("full_name") || "نام کامل"}
            name="fullName"
            onChange={telephoneRequestFormik.handleChange}
            value={telephoneRequestFormik.values.fullName}
            error={telephoneRequestFormik.errors.fullName}
          />
          <Input
            label={t("address") || "آدرس"}
            name="address"
            onChange={telephoneRequestFormik.handleChange}
            value={telephoneRequestFormik.values.address}
            error={telephoneRequestFormik.errors.address}
          />
          <div className="grid grid-cols-2 gap-4">
            <Input
              label={t("latitude") || "عرض جغرافیایی"}
              name="latitude"
              type="number"
              step="any"
              onChange={telephoneRequestFormik.handleChange}
              value={telephoneRequestFormik.values.latitude}
              error={telephoneRequestFormik.errors.latitude}
            />
            <Input
              label={t("longitude") || "طول جغرافیایی"}
              name="longitude"
              type="number"
              step="any"
              onChange={telephoneRequestFormik.handleChange}
              value={telephoneRequestFormik.values.longitude}
              error={telephoneRequestFormik.errors.longitude}
            />
          </div>
          <Input
            label={t("preferred_delivery_date") || "تاریخ تحویل ترجیحی"}
            name="preferredDeliveryDate"
            type="datetime-local"
            onChange={telephoneRequestFormik.handleChange}
            value={telephoneRequestFormik.values.preferredDeliveryDate}
            error={telephoneRequestFormik.errors.preferredDeliveryDate}
          />
          <Select
            label={t("create_delivery") || "ایجاد تحویل"}
            name="createDelivery"
            onChange={(e) => telephoneRequestFormik.setFieldValue("createDelivery", e.target.value === "true")}
            value={telephoneRequestFormik.values.createDelivery ? "true" : "false"}
            error={telephoneRequestFormik.errors.createDelivery}
          >
            <option value="true">{t("yes") || "بله"}</option>
            <option value="false">{t("no") || "خیر"}</option>
          </Select>
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createTelephoneRequest.isLoading}
          >
            {t("create_telephone_request") || "ایجاد درخواست تلفنی"}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default CollectionRequest;
