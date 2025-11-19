import { FC, useEffect, useState } from "react";
import { ColumnsType } from "antd/lib/table";
import { useTranslation } from "react-i18next";
import { HiDocumentText } from "react-icons/hi";
import { useQueryClient } from "react-query";
import moment from "jalali-moment";

import {
  put,
  Input,
  Modal,
  SingleSelect,
  useOrders,
  Pagination,
  errorAlert,
  successAlert,
  ProTable,
  useOrdersGet,
} from "../../";

const Orders: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState<string>("");
  const [selectedOrderId, setSelectedOrderId] = useState<any>("");
  const { t } = useTranslation();

  const { data: orders, isLoading } = useOrders(page, perPage, searchValue);

  const queryClient = useQueryClient();

  const { data: selectedOrder, isLoading: isLoadingOrder } = useOrdersGet(selectedOrderId) as any;

  useEffect(() => {
    setPage(1);
  }, [searchValue]);

  const orderStatus = [
    "در حال بررسی",
    "رد شده",
    "تایید شده",
    "ارسال به مرکز",
    "تحویل داده شد",
  ];

  // Map frontend status index to backend status string
  const statusMap: { [key: number]: string } = {
    0: "pending",      // "در حال بررسی"
    1: "cancelled",    // "رد شده"
    2: "confirmed",    // "تایید شده"
    3: "in_progress",  // "ارسال به مرکز"
    4: "completed",    // "تحویل داده شد"
  };

  const orderListStyle = {
    borderBottom: "1px solid",
    borderColor: "#4a4a4a21",
    padding: "10px"
  }

  const changeStatusHandler = async (status: number, id: number) => {
    // Convert frontend status index to backend status string
    const backendStatus = statusMap[status];
    if (!backendStatus) {
      errorAlert({ title: "وضعیت نامعتبر است" });
      return;
    }
    const res = await put(`/orders/order-status/${id}`, { status: backendStatus });
    if (res.data.succeeded) {
      queryClient.invalidateQueries("orders");
      successAlert({ title: `وضعیت به ${orderStatus[status]} تغییر کرد` });
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
      title: t("name"),
      dataIndex: "userFullname",
      render(value, record) {
        // Use userFullname from backend, with fallback to firstName/lastName if available
        if (record.userFullname) {
          return record.userFullname;
        }
        // Fallback for backward compatibility
        if (record.firstName || record.lastName) {
          return `${record.firstName || ""} ${record.lastName || ""}`.trim() || "-";
        }
        return "-";
      },
    },
    {
      title: t("date"),
      dataIndex: "createOrderDate",
      render(value, record) {
        if (!value) return "";
        return moment(value)
          .locale("fa")
          .format("HH:mm  - YYYY/MM/DD");
      },
    },
    {
      title: t("tracking_code"),
      dataIndex: "paymentTrackingCode",
    },
    {
      title: t("status"),
      dataIndex: "status",
      render(value, record) {
        return <>{orderStatus[value]}</>;
      },
    },
    {
      title: t("total_price"),
      dataIndex: "totalPrice",
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <div className="grid grid-cols-12 items-center space-x-5">
              <label
                onClick={() => setSelectedOrderId(record.orderUuid || record.id)}
                htmlFor="view-details"
                className="cursor-pointer col-span-2"
              >
                <HiDocumentText className="text-2xl" />
              </label>

              <div className="col-span-10 my-2">
                <SingleSelect
                  showSearch={false}
                  placeholder="order status"
                  handler={(value: any) =>
                    changeStatusHandler(parseInt(value), record.id)
                  }
                  defaultValue={JSON.stringify(record.status)}
                >
                  <option value="0">در حال بررسی</option>
                  <option value="1">رد شده</option>
                  <option value="2">تایید شده</option>
                  <option value="3">ارسال به مرکز</option>
                  <option value="4">تحویل داده شد</option>
                </SingleSelect>
              </div>
            </div>
          </>
        );
      },
    },
  ];
  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("orders")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
        </div>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={orders?.data}
          configData={orders}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}

      {/* <ProTable columns={columns} dataSource={orders?.data} /> */}
      {/* <Table
        items={[
          t("id"),
          t("date"),
          t("tracking_code"),
          t("status"),
          t("phone_number"),
          t("total_price"),
          t("actions"),
        ]}
      >
        {orders?.data?.map((order: any) => (
          <tr key={order.id}>
            <td>{order.id}</td>
            <td>
              {dayjs(order.createOrderDate).format("YYYY-MM-DD HH:mm:ss")}
            </td>
            <td>{order.paymentTrackingCode}</td>
            <td>{orderStatus[order.status]}</td>
            <td>{order.phone1}</td>
            <td>{order.totalPrice}</td>
            <td>
              <div className="grid grid-cols-12 items-center space-x-5">
                <label
                  onClick={() => setSelectedOrderId(order.id)}
                  htmlFor="view-details"
                  className="cursor-pointer col-span-2"
                >
                  <HiDocumentText className="text-2xl" />
                </label>

                <div className="col-span-10 my-2">
                  <SingleSelect
                    showSearch={false}
                    placeholder="order status"
                    handler={(value) =>
                      changeStatusHandler(parseInt(value), order.id)
                    }
                    defaultValue={JSON.stringify(order.status)}
                  >
                    <option value="0">در حال بررسی</option>
                    <option value="1">رد شده</option>
                    <option value="2">تایید شده</option>
                    <option value="3">ارسال به مرکز</option>
                    <option value="4">تحویل داده شد</option>
                  </SingleSelect>
                </div>
              </div>
            </td>
          </tr>
        ))}
      </Table> */}

      <Modal html="view-details" title={t("order_details")} className="order-list">
        {isLoadingOrder ? (
          <div>{t("loading")}</div>
        ) : selectedOrder?.data ? (
          <ul className="space-y-5">
            <li className="flex items-center justify-between" style={orderListStyle}>
              <span className="">{t("user")}</span>
              <span className="">{selectedOrder?.data?.userFullname || "-"}</span>
            </li>
            <li className="flex items-center justify-between" style={orderListStyle}>
              <span className="">{t("total_price")}</span>
              <span className="">{selectedOrder?.data?.totalPrice || 0}</span>
            </li>
            <li className="flex items-center justify-between" style={orderListStyle}>
              <span className="">{t("tracking_code")}</span>
              <span className="">{selectedOrder?.data?.paymentTrackingCode || "-"}</span>
            </li>
            <li className="flex items-center justify-between" style={orderListStyle}>
              <span className="">{t("date")}</span>
              <span className="">{selectedOrder?.data?.createOrderDate ? moment(selectedOrder.data.createOrderDate).locale("fa").format("HH:mm  - YYYY/MM/DD") : "-"}</span>
            </li>
            <li className="flex items-center justify-between" style={orderListStyle}>
              <span className="">{t("address")}</span>
              <span className="">{selectedOrder?.data?.address1 || "-"}</span>
            </li>
          </ul>
        ) : (
          <div>{t("loading")}</div>
        )}
        <h6 style={{ padding: "15px", backgroundColor: "#4a4a4a12" }} className="">{t("products")}</h6>
        <table border={1} width="100%" style={{ textAlign: "right", backgroundColor: "#4a4a4a12", borderRadius: "0px 0px 10px 10px" }}>
          <thead>
            <tr>
              <th scope="col" style={{ padding: "15px" }}>نام</th>
              <th scope="col" style={{ padding: "15px" }}>تعداد</th>
              <th scope="col" style={{ padding: "15px" }}>قیمت</th>
            </tr>
          </thead>
          <tbody>
            {selectedOrder?.data?.orderItems && selectedOrder.data.orderItems.length > 0 ? (
              selectedOrder.data.orderItems.map((item: any, index: number) => (
                <tr key={item.id || item.productId || index} dir="ltr" style={{ lineHeight: "3" }}>
                  <td>
                    <span style={{ padding: "15px" }}>{item.productName || "-"}</span>
                  </td>
                  <td>
                    <span style={{ padding: "15px" }}>{item.itemCount || 0}</span>
                  </td>
                  <td>
                    <span style={{ padding: "15px" }}>{item.unitPrice ? `${item.unitPrice.toLocaleString()} ${t("rials") || "ریال"}` : "-"}</span>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan={3} style={{ padding: "15px", textAlign: "center" }}>
                  {t("no_products") || "محصولی یافت نشد"}
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </Modal>
    </>
  );
};

export default Orders;
