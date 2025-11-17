import { FC, SetStateAction, useEffect, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { ColumnsType } from "antd/lib/table";
import { useTranslation } from "react-i18next";

import { post } from "../../services/config/api";
import {
  useCategoriesByType,
  useCreateCategory,
  useDeleteCategory,
  useUpdateCategory,
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  TextArea,
  APP_BASE_URL,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  FaqCategorySchema,
  errorAlert,
  successAlert,
  ProTable,
  useCategoriesGet,
} from "../../";
import { Avatar } from "antd";

const RecycleCategories: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [perPage, setPerPage] = useState<number>(5);
  const [page, setPage] = useState<number>(1);
  const [image, setImage] = useState<any>("");
  const [uploadedImage, setUploadedImage] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const [selectedCategoryId, setSelectedCategoryId] = useState<any>("");

  const { t } = useTranslation();

  const categoryTypes = [
    //{ id: 0, value: 0, title: t("faqs") },
    // { id: 1, value: 1, title: t("products") },
    { id: 2, value: 2, title: t("recycle") },
  ];

  const { data: categories, isLoading } = useCategoriesByType(
    page,
    perPage,
    searchValue,
    2
  );
  const deleteCategory = useDeleteCategory();
  const createCategory = useCreateCategory();
  const updateCategory = useUpdateCategory(selectedCategoryId);

  useEffect(() => {
    createFormik.setFieldValue("imagePath", uploadedImage);
    updateFormik.setFieldValue("imagePath", uploadedImage);
  }, [uploadedImage]);

  // const selectedCategory = categories?.data?.filter(
  //   (c: any) => c.id === selectedCategoryId
  // )[2];
  const dataSelectedCategory: any = useCategoriesGet(selectedCategoryId);
  const selectedCategory = dataSelectedCategory?.data?.data;

  const createFormik = useFormik<ICategory>({
    initialValues: {
      name: "",
      description: "",
      parentId: 0,
      imagePath: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnBlur: false,
    validateOnChange: false,
    // validationSchema: FaqCategorySchema,
    onSubmit: (values: any) => {
      const data: any = {
        name: values.name,
        description: values.description,
        parentId: parseInt(values.parentId.toString()),
        imagePath: values.imagePath,
        thumbnail: values.imagePath,

        locale: values.locale,
        type: 2,
      };
      createCategory
        .mutateAsync(data)
        .then(() => {
          document.getElementById("create-category")?.click();
          createFormik.resetForm();
          // @ts-ignore
          document.getElementById("create-category-type").selectedIndex = "2";
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik<ICategory>({
    initialValues: {
      name: selectedCategory?.name,
      description: selectedCategory?.description,
      parentId: selectedCategory?.parentId,
      imagePath: selectedCategory?.imagePath,
      locale: selectedCategory?.locale,
      type: selectedCategory?.type,
    },
    validateOnBlur: false,
    validateOnChange: false,
    // validationSchema: FaqCategorySchema,
    enableReinitialize: true,
    onSubmit: (values: any) => {
      const data: any = {
        name: values.name,
        description: values.description,
        parentId: parseInt(values.parentId.toString()),
        imagePath: values.imagePath,
        thumbnail: values.imagePath,

        locale: values.locale,
        type: 2,
      };
      updateCategory
        .mutateAsync(data)
        .then(() => {
          document.getElementById("update-category")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const deleteHandler = (id: string) => {
    if (!window.confirm(t("delete_item"))) return;
    toast.promise(deleteCategory.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
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
      title: t("image"),
      dataIndex: "thumbnail",
      render(record) {
        return (
          <>
            <Avatar src={`${APP_BASE_URL}${record}`} shape="square" />
          </>
        );
      },
    },
    {
      title: t("Residue name"),
      dataIndex: "name",
    },
    {
      title: t("actions"),
      render(value, record, index) {
        return (
          <>
            <ActionIcon onClick={() => setSelectedCategoryId(record.id)}>
              <label htmlFor="update-category" className="cursor-pointer">
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
          {t("recycle_categories")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-category"
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
          dataSource={categories?.data}
          configData={categories}
          page={page}
          perPage={perPage}
          setPerPage={setPerPage}
          setPage={setPage}
        />
      )}
      <Drawer
        title={t("create_category")}
        html="create-category"
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
          <div className="flex items-end">
            <Input
              type="file"
              label={t("image")}
              name="imagePath"
              onChange={(e: any) => setImage(e.target.files[0])}
              error={createFormik.errors.imagePath}
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
            loading={createCategory.isLoading}
          >
            {t("create_category")}
          </Button>
        </form>
      </Drawer>

      <Drawer
        title={t("update_category")}
        html="update-category"
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
          <div className="flex items-end">
            <Input
              type="file"
              label={t("image")}
              name="imagePath"
              onChange={(e: any) => setImage(e.target.files[0])}
              error={updateFormik.errors.imagePath}
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
            loading={updateCategory.isLoading}
          >
            {t("update_category")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default RecycleCategories;
