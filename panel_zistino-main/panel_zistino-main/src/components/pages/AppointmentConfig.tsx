import { FC, useEffect, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { ColumnsType } from "antd/lib/table";
import { useTranslation } from "react-i18next";

import {
  useCreateConfiguration,
  useDeleteConfiguration,
  useUpdateConfiguration,
  useConfigurations,
  ActionIcon,
  Button,
  Drawer,
  Input,
  errorAlert,
  ProTable,
} from "../../";

const AppointmentConfig: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [perPage, setPerPage] = useState<number>(5);
  const [page, setPage] = useState<number>(1);
  const [selectedCategoryId, setSelectedCategoryId] = useState<any>("");

  const { t } = useTranslation();

  const { data: configurations, isLoading } = useConfigurations(
    page,
    perPage,
    searchValue
  );
  const deleteConfiguration = useDeleteConfiguration();
  const createConfiguration = useCreateConfiguration();
  const updateConfiguration = useUpdateConfiguration(selectedCategoryId);

  const selectedConfigData = configurations?.data?.filter(
    (c: any) => c.id === selectedCategoryId
  )?.[0];

  const selectedConfig = selectedConfigData?.value;

  const selectedConfiguration = (() => {
    try {
      return JSON.parse(selectedConfig ?? "{}");
    } catch (e) {
      return {};
    }
  })();
  const createFormik = useFormik<any>({
    initialValues: {
      start: "",
      end: "",
      split: "",
    },
    validateOnBlur: false,
    validateOnChange: false,
    onSubmit: ({ start, end, split }) => {
      const data: any = {
        name: `config`,
        type: 1,
        value: JSON.stringify({
          start,
          end,
          split,
        }),
      };
      createConfiguration
        .mutateAsync(data)
        .then(() => {
          document.getElementById("create-configuration")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik<any>({
    initialValues: {
      start: selectedConfiguration?.start,
      end: selectedConfiguration?.end,
      split: selectedConfiguration?.split,
    },
    validateOnBlur: false,
    validateOnChange: false,
    enableReinitialize: true,
    onSubmit: ({ start, end, split }) => {
      // Use the existing configuration's name and type from selectedConfigData
      const data: any = {
        name: selectedConfigData?.name || "config",
        type: selectedConfigData?.type || 1,
        value: JSON.stringify({
          start,
          end,
          split,
        }),
      };
      updateConfiguration
        .mutateAsync(data)
        .then(() => {
          document.getElementById("update-configuration")?.click();
          updateFormik.resetForm();
          setSelectedCategoryId("");
        })
        .catch((err: any) => {
          errorAlert({ title: err?.response?.data?.error?.[0] || err?.message || "خطایی رخ داد" });
        });
    },
  });
  const deleteHandler = (id: string) => {
    if (!window.confirm(t("delete_item"))) return;
    toast.promise(deleteConfiguration.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
    });
  };

  const columns: ColumnsType<any> = [
    // {
    //   title: t("id"),
    //   dataIndex: "id",
    // },
    {
      title: t("start"),
      dataIndex: "value",
      render: (value) => {
        if (!value) return "";
        try {
          const parsed = typeof value === 'string' ? JSON.parse(value) : value;
          return parsed?.start || "";
        } catch (e) {
          return "";
        }
      },
    },
    {
      title: t("end"),
      dataIndex: "value",
      render: (value) => {
        if (!value) return "";
        try {
          const parsed = typeof value === 'string' ? JSON.parse(value) : value;
          return parsed?.end || "";
        } catch (e) {
          return "";
        }
      },
    },
    {
      title: t("split"),
      dataIndex: "value",
      render: (value) => {
        if (!value) return "";
        try {
          const parsed = typeof value === 'string' ? JSON.parse(value) : value;
          return parsed?.split || "";
        } catch (e) {
          return "";
        }
      },
    },
    {
      title: t("actions"),
      render(value, record, index) {
        return (
          <>
            <ActionIcon onClick={() => setSelectedCategoryId(record.id)}>
              <label htmlFor="update-configuration" className="cursor-pointer">
                <HiPencil className="text-2xl" />
              </label>
            </ActionIcon>
            {/* <ActionIcon onClick={() => deleteHandler(record.id)}>
              <HiTrash className="text-2xl text-red-500" />
            </ActionIcon> */}
          </>
        );
      },
    },
  ];
  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("appointmentConfig")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          {/* <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          /> */}
          {/* <Button>
            <label
              htmlFor="create-configuration"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("add")}
            </label>
          </Button> */}
        </div>
      </div>
      {isLoading ? (
        <div>{t("loading")}</div>
      ) : (
        <ProTable
          columns={columns}
          dataSource={configurations?.data}
          configData={configurations}
          page={page}
          perPage={perPage}
          setPerPage={setPerPage}
          setPage={setPage}
        />
      )}

      <Drawer
        title={t("create_configuration")}
        html="create-configuration"
        position="right"
      >
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("start")}
            name="start"
            onChange={createFormik.handleChange}
            value={createFormik.values.start}
            error={createFormik.errors.start}
          />
          <Input
            label={t("end")}
            name="end"
            onChange={createFormik.handleChange}
            value={createFormik.values.end}
            error={createFormik.errors.end}
          />
          <Input
            label={t("split")}
            name="split"
            onChange={createFormik.handleChange}
            value={createFormik.values.split}
            error={createFormik.errors.split}
          />
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createConfiguration.isLoading}
          >
            {t("create_configuration")}
          </Button>
        </form>
      </Drawer>

      <Drawer
        title={t("update_configuration")}
        html="update-configuration"
        position="right"
      >
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("start")}
            name="start"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.start}
            error={updateFormik.errors.start}
          />
          <Input
            label={t("end")}
            name="end"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.end}
            error={updateFormik.errors.end}
          />
          <Input
            label={t("split")}
            name="split"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.split}
            error={updateFormik.errors.split}
          />
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateConfiguration.isLoading}
          >
            {t("update_configuration")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default AppointmentConfig;
