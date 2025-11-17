import { FC, useEffect, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { ColumnsType } from "antd/lib/table";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";

import {
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  TagInput,
  useSpecifications,
  useDeleteSpecification,
  useCreateSpecification,
  useCategories,
  useUpdateSpecification,
  SpecificationSchema,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  errorAlert,
} from "../../";

const Specifications: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [selectedSpId, setSelectedSpId] = useState<string>("");
  const [spData, setSpData] = useState<any>([]);

  const { t } = useTranslation();

  const { data: specifications, isLoading } = useSpecifications();
  const { data: categories } = useCategories();
  const deleteSpecification = useDeleteSpecification();
  const createSpecification = useCreateSpecification();
  const updateSpecification = useUpdateSpecification(selectedSpId);

  const selectedSp = specifications?.data?.filter(
    (sp: any) => sp.id === selectedSpId
  )[0];

  useEffect(() => {
    createFormik.setFieldValue("content", JSON.stringify(spData));
  }, [spData]);

  useEffect(() => {
    if (selectedSp?.content) {
      try {
        setSpData(JSON.parse(selectedSp.content));
      } catch (e) {
        setSpData([]);
      }
    }
  }, [selectedSp]);

  useEffect(() => {
    updateFormik.setFieldValue("content", JSON.stringify(spData));
  }, [spData]);

  const createFormik = useFormik({
    initialValues: {
      category: "",
      content: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnChange: false,
    validateOnBlur: false,
    // enableReinitialize: false,
    validationSchema: SpecificationSchema,
    onSubmit: (values) => {
      // document
      //   ?.getElementById("createForm")
      //   ?.addEventListener("keyup", function (event) {
      //     if (event.key === "Enter") setEKey(true);
      //   });
      // setEKey(false);

      createSpecification
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-sp")?.click();
          createFormik.resetForm();
          setSpData([]);
          // setEKey(true);
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      category: "",
      content: selectedSp?.content,
      locale: selectedSp?.locale,
    },
    enableReinitialize: true,
    validationSchema: SpecificationSchema,
    onSubmit: (values) => {
      // document
      //   ?.getElementById("updateForm")
      //   ?.addEventListener("keyup", function (event) {
      //     if (event.key === "Enter") setEKey(true);
      //   });
      // !ekey &&
      updateSpecification
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-sp")?.click();
          createFormik.resetForm();
          setSpData([]);
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>{t("loading")}</div>;

  const removeTagData = (indexToRemove: any) => {
    setSpData([
      ...spData.filter((_: any, index: any) => index !== indexToRemove),
    ]);
  };

  const addTagData = (event: any) => {
    if (event.target.value === "") return;
    setSpData([...spData, event.target.value]);
    event.target.value = "";
  };

  const deleteHandler = (id: string) => {
    if (!window.confirm("Are you sure you want to delete this item ?")) return;
    toast.promise(deleteSpecification.mutateAsync(id), {
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
      title: t("category"),
      dataIndex: "category",
    },
    {
      title: t("content"),
      dataIndex: "content",
    },
    {
      title: t("locale"),
      dataIndex: "locale",
    },
    {
      title: t("actions"),
      render(value, record, index) {
        return (
          <>
            <ActionIcon onClick={() => deleteHandler(record.id)}>
              <HiTrash className="text-2xl text-red-500" />
            </ActionIcon>
            <ActionIcon onClick={() => setSelectedSpId(record.id)}>
              <label htmlFor="update-sp" className="cursor-pointer">
                <HiPencil className="text-2xl" />
              </label>
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
          {t("specifications")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-sp"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("add")}
            </label>
          </Button>
        </div>
      </div>
      {/* <ProTable columns={columns} dataSource={specifications?.data} /> */}
      <Drawer
        title={t("create_specification")}
        html="create-sp"
        position="right"
      >
        <form
          id="createForm"
          onSubmit={createFormik.handleSubmit}
          className="space-y-5"
        >
          {/* <Select
            label={t("locale")}
            className="mb-5"
            name="locale"
            onChange={createFormik.handleChange}
            value={createFormik.values.locale}
            error={createFormik.errors.locale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option key={index} value={locale}>
                {locale}
              </option>
            ))}
          </Select> */}
          {/* <TextArea
            label="Content"
            name="content"
            onChange={createFormik.handleChange}
            value={createFormik.values.content}
            error={createFormik.errors.content}
          /> */}
          <TagInput
            tags={spData}
            addHandler={addTagData}
            removeHandler={removeTagData}
            placeholder={t("add_item")}
          />

          <Select
            label={t("category")}
            name="category"
            onChange={createFormik.handleChange}
            value={createFormik.values.category}
            error={createFormik.errors.category}
          >
            <option value="">{t("category")}</option>
            {categories?.data.map((category: any) => (
              <option value={category.name}>{category.name}</option>
            ))}
          </Select>

          <br />
          <Button
            type="submit"
            className="btn-block"
            loading={createSpecification.isLoading}
          >
            {t("create_specification")}
          </Button>
        </form>
      </Drawer>
      <Drawer
        title={t("update_specification")}
        html="update-sp"
        position="right"
      >
        <form
          id="updateForm"
          onSubmit={updateFormik.handleSubmit}
          className="space-y-5"
        >
          {/* <Select
            label={t("locale")}
            name="locale"
            onChange={updateFormik.handleChange}
            error={updateFormik.errors.locale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option
                key={index}
                value={locale}
                selected={locale === updateFormik.values.locale}
              >
                {locale}
              </option>
            ))}
          </Select> */}
          {/* <TextArea
            label="Content"
            name="content"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.content}
            error={updateFormik.errors.content}
          /> */}
          <TagInput
            tags={spData}
            addHandler={addTagData}
            removeHandler={removeTagData}
            placeholder={t("add_item")}
          />
          {/* <Select
            label="Category"
            name="category"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.category}
            error={updateFormik.errors.category}
          >
            <option  value="">
              select category
            </option>
            {categories?.data.map((category) => (
              <option
                value={category.name}
                // selected={selectedSp?.category?.name === category?.name}
              >
                {category.name}
              </option>
            ))}
          </Select> */}
          <br />
          <Button
            type="submit"
            className="btn-block"
            loading={updateSpecification.isLoading}
          >
            {t("update_specification")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Specifications;
