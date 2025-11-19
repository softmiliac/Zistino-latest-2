import { FC, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { useTranslation } from "react-i18next";

import {
  useCreateTag,
  useDeleteTag,
  useTags,
  useUpdateTag,
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  Table,
  TextArea,
  Pagination,
  tagSchema,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  errorAlert,
} from "../../";

const Tags: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [selectedTagId, setSelectedTagId] = useState("");
  const [page, setPage] = useState(1);

  const { t } = useTranslation();

  const { data: tags, isLoading, isFetching } = useTags(page);
  const deleteTag = useDeleteTag();
  const createTag = useCreateTag();
  const updateTag = useUpdateTag(selectedTagId);

  const selectedTag = tags?.data?.filter(
    (tag: any) => tag.id === selectedTagId
  )[0];

  const createFormik = useFormik({
    initialValues: {
      text: "",
      description: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validationSchema: tagSchema,
    onSubmit: (values) => {
      createTag
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-tag")?.click();
          setPage(1);
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      text: selectedTag?.text,
      description: selectedTag?.description,
      locale: selectedTag?.locale,
    },
    validationSchema: tagSchema,
    enableReinitialize: true,
    onSubmit: (values) => {
      updateTag
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-tag")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>{t("loading")}</div>;

  const deleteHandler = (id: string) => {
    if (!window.confirm("Are you sure you want to delete this tag ?")) return;
    toast.promise(deleteTag.mutateAsync(id), {
      pending: t("please_wait"),
      success: t("deleted_successfully"),
      error: t("something_went wrong"),
    });
  };

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("tags")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-tag"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("add")}
            </label>
          </Button>
        </div>
      </div>

      <Table
        items={[
          t("id"),
          t("name"),
          t("locale"),
          t("description"),
          t("actions"),
        ]}
      >
        {tags?.data
          .filter((tag: any) => {
            return tag.text.toLowerCase().includes(searchValue.toLowerCase());
          })
          .map((tag: any) => (
            <tr key={tag.id}>
              <td>{tag.id}</td>
              <td>{tag.text}</td>
              <td>{tag.locale}</td>
              <td className="max-w-[300px] truncate">{tag.description}</td>
              <td>
                <ActionIcon onClick={() => deleteHandler(tag.id)}>
                  <HiTrash className="text-2xl text-red-500" />
                </ActionIcon>
                <ActionIcon onClick={() => setSelectedTagId(tag.id)}>
                  <label htmlFor="update-tag" className="cursor-pointer">
                    <HiPencil className="text-2xl" />
                  </label>
                </ActionIcon>
              </td>
            </tr>
          ))}
      </Table>

      <Pagination
        page={page}
        setPage={setPage}
        current={tags.currentPage}
        total={tags.totalPages}
        hasNext={tags.hasNextPage}
        hasPrev={tags.hasPreviousPage}
      />

      <Drawer title={t("create_tag")} html="create-tag" position="right">
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("text")}
            name="text"
            onChange={createFormik.handleChange}
            value={createFormik.values.text}
            error={createFormik.errors.text}
          />
          <TextArea
            label={t("description")}
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />
          {/* <Select
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
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createTag.isLoading}
          >
            {t("create_tag")}
          </Button>
        </form>
      </Drawer>

      <Drawer title={t("update_tag")} html="update-tag" position="right">
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label={t("text")}
            name="text"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.text}
            error={updateFormik.errors.text}
          />
          <TextArea
            label={t("description")}
            name="description"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.description}
            error={updateFormik.errors.description}
          />
          {/* <Select
            label={t("Locale")}
            name="locale"
            onChange={updateFormik.handleChange}
            error={updateFormik.errors.locale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option
                key={index}
                value={locale}
                selected={locale === selectedTag?.locale}
              >
                {locale}
              </option>
            ))}
          </Select> */}
          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateTag.isLoading}
          >
            {t("update_tag")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Tags;
