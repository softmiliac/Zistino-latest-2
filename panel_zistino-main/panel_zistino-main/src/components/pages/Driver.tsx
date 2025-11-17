import { FC, useEffect, useState } from "react";
import {
  HiCheck,
  HiOutlineKey,
  HiPlusSm,
  HiTrash,
  HiUserCircle,
  HiX,
} from "react-icons/hi";
import { useFormik } from "formik";
import { useQueryClient } from "react-query";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";
import { Avatar } from "antd";

import {
  Button,
  Drawer,
  Input,
  useZoneAll,
  useCreateUserInZone,
  Modal,
  useUsersByRole,
  DriverSchema,
  useDriversAll,
  ProTable,
  APP_BASE_URL,
  errorAlert,
  Select,
  useGetUserInZone,
  useGetUserWallet,
  useDeleteZoneInZone,
  successAlert,
} from "../../";

const Driver: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [userSelectedId, setUserSelectedId] = useState<string>("");
  const { t } = useTranslation();

  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const { data: users, isLoading } = useUsersByRole(page, perPage, searchValue);
  const { data: zoneByUser, isLoading: uLoading } = useGetUserInZone(
    userSelectedId
  ) as any;
  const { data: walletByUser, isLoading: wLoading } = useGetUserWallet(
    userSelectedId
  ) as any;
  const { data: allUsers } = useDriversAll();
  const { data: allZone } = useZoneAll();

  const createUser = useCreateUserInZone();
  const deleteZoneInZone = useDeleteZoneInZone();

  const formik = useFormik<IDriver>({
    initialValues: {
      userId: "",
      zoneId: "",
    },
    validationSchema: DriverSchema,
    onSubmit: (values: any) => {
      values.zoneId = +values.zoneId;
      createUser
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-user")?.click();
          formik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const columns: ColumnsType<any> = [
    {
      title: t("image"),
      dataIndex: "imageUrl",
      align: "center",
      render(value) {
        return value ? (
          <Avatar src={`${APP_BASE_URL}${value}`} />
        ) : (
          <Avatar icon={<HiUserCircle size="100%" />} />
        );
      },
    },
    { title: t("username"), dataIndex: "userName" },
    {
      title: t("name"),
      dataIndex: "firstName",
      render(value, record) {
        return (
          <>
            {record.firstName ? record.firstName : "- - -"} {record.lastName}
          </>
        );
      },
    },
    { title: t("email"), dataIndex: "email" },
    {
      title: t("actions"),
      render(record) {
        return (
          <label
            className="cursor-pointer"
            onClick={() => setUserSelectedId(record.id)}
            htmlFor="modal-user-roles"
          >
            <HiOutlineKey className="text-xl" />
          </label>
        );
      },
    },
  ];

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("drivers")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-user"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("Connect_Driver_To_Zone")}
            </label>
          </Button>
        </div>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={users?.data}
          configData={users}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}

      <Drawer
        width="lg:w-[32%]"
        title={t("Connect_Driver_To_Zone")}
        html="create-user"
        position="right"
      >
        <form onSubmit={formik.handleSubmit} className="space-y-5">
          <Select
            label={t("Driver_Id")}
            name="userId"
            onChange={formik.handleChange}
            error={formik.errors.userId}
          >
            <option value=""></option>
            {allUsers?.data?.map((item: any) => (
              <option key={item.id} value={item.id}>
                {item?.firstName} {item?.lastName}
              </option>
            ))}
          </Select>
          <Select
            label={t("Zone_Id")}
            name="zoneId"
            onChange={formik.handleChange}
            value={formik.values.zoneId}
            error={formik.errors.zoneId}
          >
            <option value="">{t("select") || "انتخاب کنید"}</option>
            {allZone?.data?.map((item: any) => (
              <option key={item.id} value={item.id}>
                {item?.zone || item?.description || `Zone ${item.id}`}
              </option>
            ))}
          </Select>
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createUser.isLoading}
          >
            {t("Driver_To_Zone")}
          </Button>
        </form>
      </Drawer>
      <Modal html="modal-user-roles" title={t("details")}>
        <h1 style={{ fontSize: "17px" }}>{t("zones")} : </h1>
        {uLoading ? (
          <div>{t("loading")}</div>
        ) : (
          <>
            <div className="grid grid-cols-2 gap-5 mb-10">
              {(Array.isArray(zoneByUser?.data) ? zoneByUser.data : Array.isArray(zoneByUser) ? zoneByUser : []).map((item: any) => (
                <div key={item.id} style={{ display: "flex", gap: 5 }}>
                  {item.zone}{" "}
                  <HiTrash
                    style={{ color: "red", cursor: "pointer" }}
                    onClick={() => {
                      deleteZoneInZone
                        .mutateAsync(item.id)
                        .then(() => {
                          successAlert({ title: "با موفقیت حذف شد" });
                        })
                        .catch((err) => {
                          errorAlert({ title: "عملیات با خطا مواجه شد" });
                          console.info("err :>> ", err);
                        });
                    }}
                  />
                </div>
              ))}
            </div>
          </>
        )}
        <h1 style={{ fontSize: "17px" }}>{t("wallet_total")} : </h1>
        {wLoading ? (
          <div>{t("loading")}</div>
        ) : (
          <>
            <div className="grid grid-cols-2 gap-5 mb-10">
              {walletByUser?.data?.map((item: any) => (
                <>
                  <div>
                    <span>{item.price} </span>
                  </div>
                </>
              ))}
            </div>
          </>
        )}
      </Modal>
    </>
  );
};

export default Driver;
