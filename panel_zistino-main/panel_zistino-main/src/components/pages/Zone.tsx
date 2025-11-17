import { FC, SetStateAction, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash, HiUserGroup } from "react-icons/hi";
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
  APP_DEFAULT_LOCALE,
  useZone,
  useCreateZone,
  useDeleteZone,
  useUpdateZone,
  useZoneAll,
  useDriversAll,
  useCreateUserInZone,
  useGetUserInZone,
  useDeleteZoneInZone,
  ZoneSchema,
  errorAlert,
  successAlert,
  ProTable,
} from "../..";

const Zone: FC = () => {
  const [searchValue, setSearchValue] = useState<string>("");
  const [selectedZoneId, setSelectedZoneId] = useState<any>("");
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [showDriverAssignment, setShowDriverAssignment] = useState<boolean>(false);
  const [selectedZoneForAssignment, setSelectedZoneForAssignment] = useState<number | null>(null);

  const { data: zone, isLoading } = useZone(page, perPage, searchValue);
  const { data: allZones } = useZoneAll();
  const { data: driversData } = useDriversAll();
  const drivers = driversData?.data || driversData || [];
  const deleteZone = useDeleteZone();
  const createZone = useCreateZone();
  const updateZone = useUpdateZone(selectedZoneId);
  const createUserInZone = useCreateUserInZone();
  const deleteUserInZone = useDeleteZoneInZone();
  const { t } = useTranslation();
  const selectedZone = zone?.data?.filter(
    (c: any) => c.id === selectedZoneId
  )[0];

  // Get drivers in selected zone
  const { data: userZonesData } = useGetUserInZone(selectedZoneForAssignment?.toString() || "");
  const userZones = Array.isArray(userZonesData) ? userZonesData : (userZonesData?.data || []);

  const createFormik = useFormik<IZone>({
    initialValues: {
      zone: "",
      description: "",
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: ZoneSchema,
    onSubmit: (values) => {
      createZone
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-zone")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik<IZone>({
    initialValues: {
      zone: selectedZone?.zone,
      description: selectedZone?.description,
    },
    enableReinitialize: true,
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: ZoneSchema,
    onSubmit: (values: any) => {
      updateZone
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-zone")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const deleteHandler = (id: any) => {
    if (!window.confirm("Are you sure you want to delete this color ?")) return;
    toast.promise(deleteZone.mutateAsync(id), {
      pending: t("please_wait"),
      success: t("deleted_successfully"),
      error: t("something_went_wrong"),
    });
  };
  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("Name Zone"),
      dataIndex: "zone",
    },
    {
      title: t("description"),
      dataIndex: "description",
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => {
              setSelectedZoneForAssignment(record.id);
              document.getElementById("assign-driver-zone")?.click();
            }}>
              <label htmlFor="assign-driver-zone" className="cursor-pointer">
                <HiUserGroup className="text-2xl text-blue-500" title={t("assign_driver") || "اختصاص راننده"} />
              </label>
            </ActionIcon>
            <ActionIcon onClick={() => setSelectedZoneId(record.id)}>
              <label htmlFor="update-zone" className="cursor-pointer">
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
          {t("zones")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4">
          <Input
            placeholder={t("search")}
            className="md:w-[260px] w-full me-5"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-zone"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl mr-1" />
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
          dataSource={zone?.data}
          configData={zone}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}

      <Drawer title={t("Add area")} html="create-zone" position="right">
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("Name Zone")}
            name="zone"
            onChange={createFormik.handleChange}
            value={createFormik.values.zone}
            error={createFormik.errors.zone}
          />

          <Input
            label={t("description")}
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />

          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createZone.isLoading}
          >
            {t("Add area")}
          </Button>
        </form>
      </Drawer>
      <Drawer title={t("update area")} html="update-zone" position="right">
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("Name Zone")}
            name="zone"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.zone}
            error={updateFormik.errors.zone}
          />

          <Input
            label={t("description")}
            name="description"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.description}
            error={updateFormik.errors.description}
          />

          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateZone.isLoading}
          >
            {t("update area")}
          </Button>
        </form>
      </Drawer>

      {/* Driver Assignment Drawer */}
      <Drawer
        title={t("assign_driver_to_zone") || "اختصاص راننده به منطقه"}
        html="assign-driver-zone"
        position="right"
      >
        <DriverAssignmentForm
          zoneId={selectedZoneForAssignment}
          zones={allZones?.data || []}
          drivers={drivers}
          userZones={userZones}
          onCreate={createUserInZone}
          onDelete={deleteUserInZone}
          onClose={() => {
            setShowDriverAssignment(false);
            setSelectedZoneForAssignment(null);
          }}
        />
      </Drawer>
    </>
  );
};

// Driver Assignment Form Component
const DriverAssignmentForm: FC<{
  zoneId: number | null;
  zones: any[];
  drivers: any[];
  userZones: any[];
  onCreate: any;
  onDelete: any;
  onClose: () => void;
}> = ({ zoneId, zones, drivers, userZones, onCreate, onDelete, onClose }) => {
  const { t } = useTranslation();
  const [selectedDriverId, setSelectedDriverId] = useState<string>("");
  const [priority, setPriority] = useState<number>(0);

  const assignmentFormik = useFormik({
    initialValues: {
      userId: "",
      zoneId: zoneId || 0,
      priority: 0,
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: true,
    onSubmit: (values) => {
      if (!values.userId || !values.zoneId) {
        errorAlert({ title: t("please_select_driver_and_zone") || "لطفا راننده و منطقه را انتخاب کنید" });
        return;
      }
      onCreate
        .mutateAsync({
          userId: values.userId,
          zoneId: values.zoneId,
          priority: values.priority || 0,
        })
        .then(() => {
          assignmentFormik.resetForm({
            values: {
              userId: "",
              zoneId: zoneId || 0,
              priority: 0,
            },
          });
          setSelectedDriverId("");
          setPriority(0);
          successAlert({ title: t("driver_assigned_successfully") || "راننده با موفقیت اختصاص یافت" });
        })
        .catch((err: any) => {
          errorAlert({ title: err?.response?.data?.error_message || err?.message || t("error_occurred") || "خطایی رخ داد" });
        });
    },
  });

  const deleteUserZoneHandler = (userZoneId: number) => {
    if (!window.confirm(t("confirm_remove_driver") || "آیا از حذف راننده از این منطقه مطمئن هستید؟")) return;
    onDelete
      .mutateAsync(userZoneId)
      .then(() => {
        successAlert({ title: t("driver_removed_successfully") || "راننده با موفقیت حذف شد" });
      })
      .catch((err: any) => {
        errorAlert({ title: err?.message || t("error_occurred") || "خطایی رخ داد" });
      });
  };

  return (
    <div className="space-y-4">
      <form onSubmit={assignmentFormik.handleSubmit} className="space-y-4">
        <Select
          label={t("zone") || "منطقه"}
          name="zoneId"
          value={assignmentFormik.values.zoneId}
          onChange={(e) => assignmentFormik.setFieldValue("zoneId", parseInt(e.target.value))}
        >
          <option value="">{t("select") || "انتخاب کنید"}</option>
          {zones?.map((zone: any) => (
            <option key={zone.id} value={zone.id}>
              {zone.zone}
            </option>
          ))}
        </Select>

        <Select
          label={t("driver") || "راننده"}
          name="userId"
          value={assignmentFormik.values.userId}
          onChange={(e) => {
            assignmentFormik.setFieldValue("userId", e.target.value);
            setSelectedDriverId(e.target.value);
          }}
        >
          <option value="">{t("select") || "انتخاب کنید"}</option>
          {drivers?.map((driver: any) => (
            <option key={driver.id} value={driver.id}>
              {driver.firstName} {driver.lastName} - {driver.phoneNumber}
            </option>
          ))}
        </Select>

        <Input
          label={t("priority") || "اولویت"}
          name="priority"
          type="number"
          min="0"
          value={assignmentFormik.values.priority}
          onChange={(e) => {
            const val = parseInt(e.target.value) || 0;
            assignmentFormik.setFieldValue("priority", val);
            setPriority(val);
          }}
          helpText={t("priority_explanation") || "عدد بالاتر = اولویت بیشتر (پیش‌فرض: 0)"}
        />

        <Button
          type="submit"
          className="btn-block font-semibold rtl:font-rtl-semibold"
          loading={onCreate.isLoading}
        >
          {t("assign") || "اختصاص"}
        </Button>
      </form>

      {/* Assigned Drivers List */}
      {zoneId && userZones.length > 0 && (
        <div className="mt-6 border-t pt-4">
          <h3 className="font-semibold mb-3">{t("assigned_drivers") || "رانندگان اختصاص یافته"}:</h3>
          <div className="space-y-2">
            {userZones.map((uz: any) => (
              <div key={uz.id} className="flex justify-between items-center p-3 border rounded">
                <div>
                  <div className="font-semibold">{uz.firstName} {uz.lastName}</div>
                  <div className="text-sm text-gray-500">{t("priority") || "اولویت"}: {uz.priority || 0}</div>
                </div>
                <ActionIcon onClick={() => deleteUserZoneHandler(uz.id)}>
                  <HiTrash className="text-xl text-red-500" />
                </ActionIcon>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default Zone;
