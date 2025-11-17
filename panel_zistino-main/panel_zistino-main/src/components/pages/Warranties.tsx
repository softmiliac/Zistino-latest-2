import { FC, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { ColumnsType } from "antd/lib/table";

import {
  useCreateWarranty,
  useDeleteWarranty,
  useUpdateWarranty,
  useWarranties,
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  TextArea,
  WarrantySchema,
  APP_BASE_URL,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  post,
  errorAlert,
  successAlert,
} from "../../";

const Warranties: FC = () => {
  const [searchValue, setSearchValue] = useState<string>("");
  const [image, setImage] = useState<any>("");
  const [uploadedImage, setUploadedImage] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const [selecteDWarrantyId, setSelecteDWarrantyId] = useState<any>("");

  const { data: warranties, isLoading } = useWarranties();
  const deleteWarranty = useDeleteWarranty();
  const createWarranty = useCreateWarranty();
  const updateWarranty = useUpdateWarranty(selecteDWarrantyId);

  const selectedWarranty = warranties?.data?.filter(
    (w: any) => w.id === selecteDWarrantyId
  )[0];
  const { t } = useTranslation();
  useEffect(() => {
    createFormik.setFieldValue("imageUrl", uploadedImage);
  }, [uploadedImage]);

  const createFormik = useFormik<IWarranty>({
    initialValues: {
      name: "",
      description: "",
      imageUrl: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: WarrantySchema,
    onSubmit: (values) => {
      createWarranty
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-warranty")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik<IWarranty>({
    initialValues: {
      name: selectedWarranty?.name,
      description: selectedWarranty?.description,
      imageUrl: selectedWarranty?.imageUrl,
      locale: selectedWarranty?.locale,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: WarrantySchema,
    enableReinitialize: true,
    onSubmit: (values) => {
      updateWarranty
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-warranty")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>{t("loading")}</div>;

  const deleteHandler = (id: string) => {
    if (!window.confirm("Are you sure you want to delete this warranty ?"))
      return;
    toast.promise(deleteWarranty.mutateAsync(id), {
      pending: t("please_wait"),
      success: t("deleted_successfully"),
      error: t("something_went_wrong"),
    });
  };

  const handleImageUpload = async () => {
    if (image === "") return;

    setUploadLoading(true);

    const data = new FormData();
    data.append("image", image);

    try {
      const res = await post("/fileuploader/?folder=app", data, {
        headers: {
          "content-type": "multipart/form-data",
        },
      });

      setUploadedImage(res.data.data.path);

      if (res.status === 200) {
        successAlert({ title: "uploaded" });
        setUploadLoading(false);
        setImage("");
      }
    } catch (err) {
      console.info(err);
      setImage("");
      errorAlert({ title: "something went wrong" });
    }
    setUploadLoading(false);
    setImage("");
  };
  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("locale"),
      dataIndex: "locale",
    },
    {
      title: t("name"),
      dataIndex: "name",
    },
    {
      title: t("description"),
      dataIndex: "description",
    },
    {
      title: t("image"),
      dataIndex: "imageUrl",
      render(value) {
        return (
          <>
            <img
              src={APP_BASE_URL + value.imageUrl}
              className="w-10 h-10 rounded-full object-cover"
              alt=" "
            />
          </>
        );
      },
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => setSelecteDWarrantyId(record.id)}>
              <label htmlFor="update-warranty" className="cursor-pointer">
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
          {t("warranties")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4">
          <Input
            placeholder={t("search")}
            className="md:w-[260px] w-full me-5"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-warranty"
              className="w-full h-full  flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl mr-1" />
              {t("add_warranty")}
            </label>
          </Button>
        </div>
      </div>
      {/* <ProTable columns={columns} dataSource={warranties?.data} /> */}

      <Drawer
        title={t("create_warranty")}
        html="create-warranty"
        position="right"
      >
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("name")}
            name="name"
            onChange={createFormik.handleChange}
            value={createFormik.values.name}
            error={createFormik.errors.name}
          />
          {/* 
          <Select
            label={t("locale")}
            name="locale"
            onChange={createFormik.handleChange}
            error={createFormik.errors.locale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option key={index} value={locale}>
                {locale}
              </option>
            ))}
          </Select> */}

          <TextArea
            label={t("description")}
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />
          <div className="flex items-end">
            <Input
              type="file"
              label={t("image")}
              name="imageUrl"
              onChange={(e: any) => setImage(e.target.files[0])}
              error={createFormik.errors.imageUrl}
              className="w-5/6 file:bg-transparent file:border-0 file:text-white file:mt-2"
            />
            <Button
              type="button"
              onClick={handleImageUpload}
              loading={uploadLoading}
              disabled={image === ""}
            >
              {t("upload")}
            </Button>
          </div>
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createWarranty.isLoading}
          >
            {t("create_warranty")}
          </Button>
        </form>
      </Drawer>
      <Drawer
        title={t("update-warranties")}
        html="update-warranty"
        position="right"
      >
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("name")}
            name="name"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.name}
            error={updateFormik.errors.name}
          />

          {/* <Select
            label={t("locale")}
            name="locale"
            onChange={updateFormik.handleChange}
            error={updateFormik.errors.locale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option key={index} value={locale}>
                {locale}
              </option>
            ))}
          </Select> */}

          <TextArea
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
            loading={createWarranty.isLoading}
          >
            {t("update-warranties")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Warranties;
