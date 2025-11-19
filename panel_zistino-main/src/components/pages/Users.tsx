import { FC, useEffect, useState } from "react";
import {
  HiCheck,
  HiOutlineKey,
  HiPlusSm,
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
  Modal,
  Select,
  useCreateUser,
  useUserRoles,
  useUsers,
  UserSchema,
  post,
  ProTable,
  APP_BASE_URL,
  errorAlert,
  successAlert,
  useGetUserWallet,
  useZoneAll,
} from "../../";

const Users: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [selectedRoles, setSelectedRoles] = useState<any>([]);
  const [selectedUserId, setSelectedUserId] = useState("");
  const [isRLoading, setIsRLoading] = useState(false);
  const { t } = useTranslation();

  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const { data: users, isLoading } = useUsers(page, perPage, searchValue);

  const { data: uroles, isLoading: uLoading } = useUserRoles(selectedUserId);
  const { data: walletByUser, isLoading: wLoading } = useGetUserWallet(
    selectedUserId
  ) as any;
  const { data: zones, isLoading: zonesLoading } = useZoneAll();
  const createUser = useCreateUser();

  const queryClient = useQueryClient();

  const formik = useFormik<IUser>({
    initialValues: {
      firstName: "",
      lastName: "",
      email: "",
      userName: "",
      password: "",
      confirmPassword: "",
      phoneNumber: "",
      companyName: "",
      vatNumber: "",
      zoneId: "",
    },
    validationSchema: UserSchema,
    onSubmit: (values) => {
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

  const handleChangeItems = () => {
    const checkedItems: any = document.querySelectorAll("#user-role-item");

    const checkItemsData = Array.from(checkedItems).map((item: any) => {
      try {
        return JSON.parse(item.alt);
      } catch (e) {
        return {};
      }
    });

    Array.from(checkedItems).map((x: any, index) => {
      if (x.checked) {
        checkItemsData[index].enabled = true;
      } else {
        checkItemsData[index].enabled = false;
      }
    });

    setSelectedRoles(checkItemsData);
  };

  useEffect(() => {
    handleChangeItems();
  }, [uroles]);

  // if (isLoading) return <div>{t("loading")}</div>;

  const submitUserRoles = async () => {
    setIsRLoading(true);

    const newUserRoles = {
      userRoles: selectedRoles,
    };

    const res: any = post(`/users/${selectedUserId}/roles`, newUserRoles);
    const x = await res;

    if (x.data.succeeded) {
      successAlert({ title: x?.data?.messages?.[0] });
      queryClient.invalidateQueries("user-roles");
      queryClient.invalidateQueries("users");
      document.getElementById("modal-user-roles")?.click();
    } else if (x.data.succeeded === false) {
      errorAlert({ title: x.data.messages[0] });
    } else {
      errorAlert({ title: "Error updating user roles" });
    }
    setIsRLoading(false);
  };

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
    // {
    //   title: t("confirmed"),
    //   dataIndex: "emailConfirmed",
    //   align: "center",
    //   render(value) {
    //     return value ? (
    //       <HiCheck
    //         className="text-xl text-green-500"
    //         style={{ display: "inline-flex" }}
    //       />
    //     ) : (
    //       <HiX
    //         className="text-xl text-red-500"
    //         style={{ display: "inline-flex" }}
    //       />
    //     );
    //   },
    // },
    {
      title: t("نقش ها"),
      render(record) {
        return (
          <label
            className="cursor-pointer"
            onClick={() => setSelectedUserId(record.id)}
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
          {t("users")}
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
              {t("add")}
            </label>
          </Button>
        </div>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={Array.isArray(users?.data) ? users.data : []}
          configData={users}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}

      <Drawer
        width="lg:w-[32%]"
        title={t("create_user")}
        html="create-user"
        position="right"
      >
        <form onSubmit={formik.handleSubmit} className="space-y-5">
          <div className="grid grid-cols-2 gap-6">
            <Input
              label={t("firstname")}
              name="firstName"
              onChange={formik.handleChange}
              value={formik.values.firstName}
              error={formik.errors.firstName}
            />
            <Input
              label={t("lastname")}
              name="lastName"
              onChange={formik.handleChange}
              value={formik.values.lastName}
              error={formik.errors.lastName}
            />
          </div>
          <Input
            label={t("username")}
            name="userName"
            onChange={formik.handleChange}
            value={formik.values.userName}
            error={formik.errors.userName}
          />
          <Input
            label={t("email")}
            name="email"
            onChange={formik.handleChange}
            value={formik.values.email}
            error={formik.errors.email}
          />

          <div className="grid grid-cols-2 gap-6">
            {/* <Input
              label={t("company")}
              name="companyName"
              onChange={formik.handleChange}
              value={formik.values.companyName}
              error={formik.errors.companyName}
            /> */}
            {/* <Input
              label={t("vat_number")}
              name="vatNumber"
              onChange={formik.handleChange}
              value={formik.values.vatNumber}
              error={formik.errors.vatNumber}
            /> */}
            <Input
              label={t("password")}
              name="password"
              onChange={formik.handleChange}
              value={formik.values.password}
              error={formik.errors.password}
            />
            <Input
              label={t("confirm_password")}
              name="confirmPassword"
              onChange={formik.handleChange}
              value={formik.values.confirmPassword}
              error={formik.errors.confirmPassword}
            />

            <Input
              placeholder="مثال  : 11 ج 222 - 12"
              label={t("number_plates")}
              name="vatNumber"
              onChange={formik.handleChange}
              value={formik.values.vatNumber}
              error={formik.errors.vatNumber}
            />
          </div>
          <Select
            label={t("zone") || "منطقه"}
            name="zoneId"
            onChange={formik.handleChange}
            value={formik.values.zoneId}
            error={formik.errors.zoneId}
          >
            <option value="">{t("select") || "انتخاب کنید"}</option>
            {zones?.data?.map((zone: any) => (
              <option key={zone.id} value={zone.id}>
                {zone.zone || zone.description || `Zone ${zone.id}`}
              </option>
            ))}
          </Select>
          {/* <Input
            label={t("phone_number")}
            name="phoneNumber"
            onChange={formik.handleChange}
            value={formik.values.phoneNumber}
            error={formik.errors.phoneNumber}
          /> */}
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createUser.isLoading}
          >
            {t("create_user")}
          </Button>
        </form>
      </Drawer>

      <Modal html="modal-user-roles" title={t("user_roles")}>
        {uLoading ? (
          <div>{t("loading")}</div>
        ) : (
          <>
            <div className="grid grid-cols-2 gap-5 mb-10">
              {uroles?.data?.userRoles.map((role: any) => (
                <div className="form-control">
                  <label className="cursor-pointer label">
                    <span className="label-text text-zinc-800 dark:text-white">
                      {role.roleName}
                    </span>
                    <input
                      id="user-role-item"
                      alt={JSON.stringify(role)}
                      name={role.roleName}
                      defaultChecked={role.enabled}
                      type="checkbox"
                      onChange={handleChangeItems}
                      className="checkbox checkbox-primary"
                    />
                  </label>
                </div>
              ))}
            </div>
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
            <Button
              onClick={submitUserRoles}
              loading={isRLoading}
              className="btn-block"
            >
              {t("submit")}
            </Button>
          </>
        )}
      </Modal>
    </>
  );
};

export default Users;
