import { FC, useState } from "react";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { ColumnsType } from "antd/lib/table";
import { useTranslation } from "react-i18next";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";

import {
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  TextArea,
  useCategoryByType,
  useCreateFaq,
  useDeleteFaq,
  useFaqs,
  useUpdateFaq,
  FaqSchema,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  errorAlert,
  ProTable,
  useFaqsGet,
} from "../../";

const Faqs: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState<string>("");
  const [selectedFaqId, setSelectedFaqId] = useState<string>("");
  const { t } = useTranslation();

  const { data: faqs, isLoading } = useFaqs();
  const { data: categories } = useCategoryByType(0);
  const deleteFaq = useDeleteFaq();
  const createFaq = useCreateFaq();

  const updateFaq = useUpdateFaq(selectedFaqId);

  const dataSelectedFaq = useFaqsGet(selectedFaqId) as any;
  const selectedFaq = dataSelectedFaq?.data?.data;

  const createFormik = useFormik({
    initialValues: {
      title: "",
      description: "",
      categoryId: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: FaqSchema,
    onSubmit: (values) => {
      createFaq
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-faq")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      title: selectedFaq?.title,
      description: selectedFaq?.description,
      categoryId: selectedFaq?.category?.id || selectedFaq?.categoryId || "",
      locale: selectedFaq?.locale,
    },
    enableReinitialize: true,
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: FaqSchema,
    onSubmit: (values) => {
      updateFaq
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-faq")?.click();
          updateFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>{t("loading")}</div>;

  const deleteHandler = (id: string) => {
    if (!window.confirm(t("delete_item"))) return;
    toast.promise(deleteFaq.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
    });
  };
  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("faqes"),
      dataIndex: "title",
    },
    {
      title: t("Response") || "پاسخ",
      dataIndex: "description",
      render(value) {
        // Display description/answer, truncate if too long
        if (!value || value.trim() === "") {
          return "-";
        }
        // Show first 100 characters, add ellipsis if longer
        if (value.length > 100) {
          return value.substring(0, 100) + "...";
        }
        return value;
      },
    },
    {
      title: t("category"),
      dataIndex: "categoryName",
      render(value, record) {
        // Use categoryName from backend, or try to get from category object
        if (record.categoryName) {
          return record.categoryName;
        }
        if (record.category && record.category.name) {
          return record.category.name;
        }
        return "-";
      },
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => setSelectedFaqId(record.id)}>
              <label htmlFor="update-faq" className="cursor-pointer">
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
          {t("faqs")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-faq"
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
        dataSource={faqs?.data}
        configData={faqs}
        page={page}
        perPage={perPage}
        setPage={setPage}
        setPerPage={setPerPage}
      />
      <Drawer title={t("create_faq")} html="create-faq" position="right">
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("Question")}
            name="title"
            onChange={createFormik.handleChange}
            value={createFormik.values.title}
            error={createFormik.errors.title}
          />
          <Select
            label={t("category")}
            name="categoryId"
            onChange={(e) => createFormik.setFieldValue("categoryId", e.target.value)}
            value={createFormik.values.categoryId || ""}
            error={createFormik.errors.categoryId}
          >
            <option value="">{t("select") || "انتخاب کنید"}</option>
            {categories?.data?.map((category: any) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </Select>

          <TextArea
            label={t("Response")}
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createFaq.isLoading}
          >
            {t("create_faq")}
          </Button>
        </form>
      </Drawer>

      <Drawer title={t("update_faq")} html="update-faq" position="right">
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("Question")}
            name="title"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.title}
            error={updateFormik.errors.title}
          />
          <Select
            label={t("category")}
            name="categoryId"
            onChange={(e) => updateFormik.setFieldValue("categoryId", e.target.value)}
            value={updateFormik.values.categoryId || ""}
            error={updateFormik.errors.categoryId}
          >
            <option value="">{t("select") || "انتخاب کنید"}</option>
            {categories?.data?.map((category: any) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </Select>

          <TextArea
            label={t("Response")}
            name="description"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.description}
            error={updateFormik.errors.description}
          />
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateFaq.isLoading}
          >
            {t("update_faq")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Faqs;
