import { FC, SetStateAction, useEffect, useState } from "react";
import {
  HiOutlineReceiptTax,
  HiPencil,
  HiPlusSm,
  HiTrash,
} from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";
import { ColumnsType } from "antd/lib/table";

import {
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  useCoupons,
  useCreateCoupon,
  useDeleteCoupon,
  useUpdateCoupon,
  useUsers,
  errorAlert,
  ProTable,
  useCouponsGet,
} from "../../";

const Coupons: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState<string>("");
  const [selectedCouponId, setSelectedCouponId] = useState<any>("");
  const [couponKey, setCouponKey] = useState<string>("");
  const [couponType, setCouponType] = useState<number>(0);
  const [couponLimitType, setCouponLimitType] = useState<number>(0);
  const [couponUserLimitType, setCouponUserLimitType] = useState<number>(0);

  const { t } = useTranslation();

  const { data: coupons, isLoading } = useCoupons(page, perPage);
  const deleteCoupon = useDeleteCoupon();
  const createCoupon = useCreateCoupon();
  const updateCoupon = useUpdateCoupon(selectedCouponId);

  const { data: users } = useUsers();

  const dataSelectedCoupon = useCouponsGet(selectedCouponId) as any;
  const selectedCoupon = dataSelectedCoupon?.data?.data;

  const createFormik = useFormik({
    initialValues: {
      key: "",
      startDateTime: "",
      endDateTime: "",
      maxUseCount: null,
      percent: null,
      price: null,
      userId: "",
      roleId: "",
      type: couponType,
      limitationType: couponLimitType,
      userLimitationType: couponUserLimitType,
    },
    validateOnBlur: false,
    validateOnChange: false,
    // validationSchema: CouponSchema,
    onSubmit: (values) => {
      if (values.key === "") return;

      const data = {
        key: values.key,
        startDateTime:
          values.startDateTime === ""
            ? null
            : new Date(values.startDateTime).toISOString(),
        endDateTime:
          values.endDateTime === ""
            ? null
            : new Date(values.endDateTime).toISOString(),
        maxUseCount: values.maxUseCount,
        percent: values.percent,
        price: values.price,
        userId: values.userId === "" ? null : values.userId,
        roleId: values.roleId === "" ? null : values.roleId,
        type: values.type,
        limitationType: values.limitationType,
        userLimitationType: values.userLimitationType,
      };

      createCoupon
        .mutateAsync(data)
        .then(() => {
          document.getElementById("create-coupon")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      key: selectedCoupon?.key,
      startDateTime: selectedCoupon?.startDateTime,
      endDateTime: selectedCoupon?.endDateTime,
      maxUseCount: selectedCoupon?.maxUseCount,
      percent: selectedCoupon?.percent,
      price: selectedCoupon?.price,
      userId: selectedCoupon?.userId,
      roleId: selectedCoupon?.roleId,
      type: selectedCoupon?.type,
      limitationType: selectedCoupon?.limitationType,
      userLimitationType: selectedCoupon?.userLimitationType,
    },
    validateOnBlur: false,
    validateOnChange: false,
    enableReinitialize: true,
    // validationSchema: CouponSchema,
    onSubmit: (values) => {
      if (values.key === "") return;

      const data = {
        key: values.key,
        startDateTime:
          values.startDateTime === "" || values.startDateTime === null
            ? null
            : new Date(values.startDateTime).toISOString(),
        endDateTime:
          values.endDateTime === "" || values.endDateTime === null
            ? null
            : new Date(values.endDateTime).toISOString(),
        maxUseCount: values.maxUseCount,
        percent: values.percent,
        price: values.price,
        userId: values.userId === "" ? null : values.userId,
        roleId: values.roleId === "" ? null : values.roleId,
        type: values.type,
        limitationType: values.limitationType,
        userLimitationType: values.userLimitationType,
      };

      updateCoupon
        .mutateAsync(data)
        .then(() => {
          document.getElementById("update-coupon")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  useEffect(() => {
    createFormik.setFieldValue("key", couponKey);
    updateFormik.setFieldValue("key", couponKey);
  }, [couponKey]);
  useEffect(() => {
    createFormik.setFieldValue("type", couponType);
    updateFormik.setFieldValue("type", couponType);
    if (couponType === 0) {
      createFormik.setFieldValue("percent", null);
      updateFormik.setFieldValue("percent", null);
    } else {
      createFormik.setFieldValue("price", null);
      updateFormik.setFieldValue("price", null);
    }
  }, [couponType]);
  useEffect(() => {
    createFormik.setFieldValue("limitationType", couponLimitType);
    updateFormik.setFieldValue("limitationType", couponLimitType);
    if (couponLimitType === 0) {
      createFormik.setFieldValue("maxUseCount", null);
      updateFormik.setFieldValue("maxUseCount", null);
    } else {
      createFormik.setFieldValue("endDateTime", "");
      createFormik.setFieldValue("startDateTime", "");
      updateFormik.setFieldValue("endDateTime", "");
      updateFormik.setFieldValue("startDateTime", "");
    }
  }, [couponLimitType]);
  useEffect(() => {
    createFormik.setFieldValue("userLimitationType", couponUserLimitType);
    updateFormik.setFieldValue("userLimitationType", couponUserLimitType);
    if (couponUserLimitType === 0) {
      createFormik.setFieldValue("userId", "");
      createFormik.setFieldValue("roleId", "");
      updateFormik.setFieldValue("userId", "");
      updateFormik.setFieldValue("roleId", "");
    } else if (couponUserLimitType === 1) {
      createFormik.setFieldValue("roleId", "");
      updateFormik.setFieldValue("roleId", "");
    } else {
      createFormik.setFieldValue("userId", "");
      updateFormik.setFieldValue("userId", "");
    }
  }, [couponUserLimitType]);
  useEffect(() => {
    if (selectedCoupon) {
      setCouponType(selectedCoupon.type);
      setCouponLimitType(selectedCoupon.limitationType);
      setCouponUserLimitType(selectedCoupon.userLimitationType);
    }
  }, [selectedCoupon]);

  if (isLoading) return <div>{t("loading")}</div>;

  const couponTypes = [t("price"), t("percent")];
  const couponLimitTypes = [t("date"), t("count")];
  const couponUserLimitTypes = [t("none"), t("user"), t("role")];

  const deleteHandler = (id: any) => {
    if (!window.confirm(t("delete_item"))) return;
    toast.promise(deleteCoupon.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
    });
  };

  const generateCoupon = () => {
    let text = "";
    const possible =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 6; i++)
      text += possible.charAt(Math.floor(Math.random() * possible.length));

    return text;
  };
  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("name"),
      dataIndex: "key",
    },
    {
      title: t("type"),
      dataIndex: "type",
      render(value, record, index) {
        return couponTypes[value];
      },
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => setSelectedCouponId(record.id)}>
              <label htmlFor="update-coupon" className="cursor-pointer">
                <HiPencil className="text-2xl" />
              </label>
            </ActionIcon>
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
          {t("coupons")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-coupon"
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
        dataSource={coupons?.data}
        configData={coupons}
        page={page}
        perPage={perPage}
        setPage={setPage}
        setPerPage={setPerPage}
      />
      <Drawer title={t("create_coupon")} html="create-coupon" position="right">
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <div className="flex items-end justify-between">
            <Input
              className="w-[153%]"
              label={t("name")}
              name="key"
              onChange={createFormik.handleChange}
              value={createFormik.values.key}
              error={createFormik.errors.key}
            />
            <ActionIcon
              type="button"
              onClick={() => setCouponKey(generateCoupon())}
            >
              <HiOutlineReceiptTax className="text-2xl" />
            </ActionIcon>
          </div>

          <Select
            label={t("type")}
            name="type"
            onChange={(e) => setCouponType(parseInt(e.target.value))}
            // @ts-ignore
            value={couponType}
            error={createFormik.errors.type}
          >
            {couponTypes.map((type, index) => (
              <option key={index} value={couponTypes.indexOf(type)}>
                {type}
              </option>
            ))}
          </Select>

          {couponType === 0 ? (
            <Input
              label={t("price")}
              name="price"
              type="number"
              min={1}
              onChange={createFormik.handleChange}
              value={createFormik.values.price ? createFormik.values.price : 1}
              error={createFormik.errors.price}
            />
          ) : (
            <Input
              label={t("percent")}
              name="percent"
              type="number"
              min={1}
              onChange={createFormik.handleChange}
              value={
                createFormik.values.percent ? createFormik.values.percent : 1
              }
              error={createFormik.errors.percent}
            />
          )}

          <Select
            label={t("limitation")}
            name="limitationType"
            onChange={(e) => setCouponLimitType(parseInt(e.target.value))}
            // @ts-ignore
            value={couponLimitType}
            error={createFormik.errors.limitationType}
          >
            {couponLimitTypes.map((type, index) => (
              <option key={index} value={couponLimitTypes.indexOf(type)}>
                {type}
              </option>
            ))}
          </Select>

          {couponLimitType === 0 ? (
            <>
              {/* <Input
            //    type="datetime-local"
                label={t("start_date")}
                name="startDateTime"
                onChange={createFormik.handleChange}
                value={createFormik.values.startDateTime}
                error={createFormik.errors.startDateTime}
              />

              <Input
              //  type="datetime-local"
                label={t("end_date")}
                name="endDateTime"
                onChange={createFormik.handleChange}
                value={createFormik.values.endDateTime}
                error={createFormik.errors.endDateTime}
              /> */}
            </>
          ) : (
            <Input
              label={t("max_use")}
              name="maxUseCount"
              type="number"
              min={1}
              onChange={createFormik.handleChange}
              value={
                createFormik.values.maxUseCount
                  ? createFormik.values.maxUseCount
                  : 1
              }
              error={createFormik.errors.maxUseCount}
            />
          )}

          <Select
            label={t("limitation_user")}
            name="userLimitationType"
            onChange={(e) => setCouponUserLimitType(parseInt(e.target.value))}
            // @ts-ignore
            value={couponUserLimitType}
            error={createFormik.errors.userLimitationType}
          >
            {couponUserLimitTypes.map((type, index) => (
              <option key={index} value={couponUserLimitTypes.indexOf(type)}>
                {type}
              </option>
            ))}
          </Select>

          {(() => {
            if (couponUserLimitType === 0) {
              return null;
            } else if (couponUserLimitType == 1) {
              return (
                <Select
                  label={t("user")}
                  name="userId"
                  onChange={createFormik.handleChange}
                  error={createFormik.errors.userId}
                >
                  <option value="">{t("user")}</option>
                  {users?.data?.map((user: any) => (
                    <option key={user.id} value={user.id}>
                      {user.userName}
                    </option>
                  ))}
                </Select>
              );
            } else {
              return (
                <Select
                  label={t("role")}
                  name="roleId"
                  onChange={createFormik.handleChange}
                  error={createFormik.errors.roleId}
                >
                  <option value="">{t("role")}</option>
                  {/* {roles?.data?.map((role: any) => (
                    <option key={role.id} value={role.id}>
                      {role.name}
                    </option>
                  ))} */}
                </Select>
              );
            }
          })()}

          <br />

          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createCoupon.isLoading}
          >
            {t("create_coupon")}
          </Button>
        </form>
      </Drawer>

      <Drawer title={t("update_coupon")} html="update-coupon" position="right">
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <div className="flex items-end justify-between">
            <Input
              className="w-[153%]"
              label={t("name")}
              name="key"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.key}
              error={updateFormik.errors.key}
            />
            <ActionIcon
              type="button"
              onClick={() => setCouponKey(generateCoupon())}
            >
              <HiOutlineReceiptTax className="text-2xl" />
            </ActionIcon>
          </div>

          <Select
            label={t("type")}
            name="type"
            onChange={(e) => setCouponType(parseInt(e.target.value))}
            // @ts-ignore
            value={couponType}
            error={updateFormik.errors.type}
          >
            {couponTypes.map((type, index) => (
              <option key={index} value={couponTypes.indexOf(type)}>
                {type}
              </option>
            ))}
          </Select>

          {couponType === 0 ? (
            <Input
              label={t("price")}
              name="price"
              type="number"
              min={1}
              onChange={updateFormik.handleChange}
              value={updateFormik.values.price ? updateFormik.values.price : 1}
              error={updateFormik.errors.price}
            />
          ) : (
            <Input
              label={t("percent")}
              name="percent"
              type="number"
              min={1}
              onChange={updateFormik.handleChange}
              value={
                updateFormik.values.percent ? updateFormik.values.percent : 1
              }
              error={updateFormik.errors.percent}
            />
          )}

          <Select
            label={t("limitation")}
            name="limitationType"
            onChange={(e) => setCouponLimitType(parseInt(e.target.value))}
            // @ts-ignore
            value={couponLimitType}
            error={updateFormik.errors.limitationType}
          >
            {couponLimitTypes.map((type, index) => (
              <option key={index} value={couponLimitTypes.indexOf(type)}>
                {type}
              </option>
            ))}
          </Select>

          {couponLimitType === 0 ? (
            <>
              {/* <Input
             //   type="datetime-local"
                label={t("start_date")}
                name="startDateTime"
                onChange={updateFormik.handleChange}
                value={updateFormik.values.startDateTime}
                error={updateFormik.errors.startDateTime}
              />

              <Input
               // type="datetime-local"
                label={t("end_date")}
                name="endDateTime"
                onChange={updateFormik.handleChange}
                value={updateFormik.values.endDateTime}
                error={updateFormik.errors.endDateTime}
              /> */}
            </>
          ) : (
            <Input
              label={t("max_use")}
              name="maxUseCount"
              type="number"
              min={1}
              onChange={updateFormik.handleChange}
              value={
                updateFormik.values.maxUseCount
                  ? updateFormik.values.maxUseCount
                  : 1
              }
              error={updateFormik.errors.maxUseCount}
            />
          )}

          <Select
            label={t("limitation_user")}
            name="userLimitationType"
            onChange={(e) => setCouponUserLimitType(parseInt(e.target.value))}
            // @ts-ignore
            value={couponUserLimitType}
            error={updateFormik.errors.userLimitationType}
          >
            {couponUserLimitTypes.map((type, index) => (
              <option key={index} value={couponUserLimitTypes.indexOf(type)}>
                {type}
              </option>
            ))}
          </Select>

          {(() => {
            if (couponUserLimitType === 0) {
              return null;
            } else if (couponUserLimitType == 1) {
              return (
                <Select
                  label={t("user")}
                  name="userId"
                  onChange={updateFormik.handleChange}
                  error={updateFormik.errors.userId}
                >
                  {users?.data?.map((user: any) => (
                    <option key={user.id} value={user.id}>
                      {user.userName}
                    </option>
                  ))}
                </Select>
              );
            } else {
              return (
                <Select
                  label={t("role")}
                  name="roleId"
                  onChange={updateFormik.handleChange}
                  error={updateFormik.errors.roleId}
                >
                  {/* {roles?.data?.map((role: any) => (
                    <option key={role.id} value={role.id}>
                      {role.name}
                    </option>
                  ))} */}
                </Select>
              );
            }
          })()}

          <br />

          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateCoupon.isLoading}
          >
            {t("update_coupon")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Coupons;
