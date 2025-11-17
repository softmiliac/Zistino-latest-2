import { FC, useEffect, useState } from "react";
import { toast } from "react-toastify";
import { useTranslation } from "react-i18next";
import { useFormik } from "formik";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";

import {
  useCreateMenuLink,
  useDeleteMenuLink,
  useMenuLinkList,
  useMenuLinks,
  useUpdateMenuLink,
  ActionIcon,
  Button,
  Drawer,
  Input,
  SingleSelect,
  Table,
  Pagination,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  MenuLinksSchema,
  errorAlert,
} from "../../";

const MenuLinks: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [selectedLocale, setSelectedLocale] = useState(APP_DEFAULT_LOCALE);
  const [selectedParentId, setSelectedParentId] = useState<any>(null);
  const [selectedId, setSelectedId] = useState("");
  const [page, setPage] = useState(1);

  const { t } = useTranslation();

  const { data: menuLinks, isFetching } = useMenuLinks(page, 7, searchValue);
  const { data: menuLinkList } = useMenuLinkList();
  const createMenuLink = useCreateMenuLink();
  const deleteMenuLink = useDeleteMenuLink();
  const updateMenuLink = useUpdateMenuLink(selectedId);

  const selectedItem = menuLinks?.data?.filter(
    (item: any) => item.id === selectedId
  )[0];

  useEffect(() => {
    createFormik.setFieldValue("parentId", parseInt(selectedParentId));
    updateFormik.setFieldValue("parentId", parseInt(selectedParentId));
  }, [selectedParentId]);

  useEffect(() => {
    createFormik.setFieldValue("locale", selectedLocale);
    updateFormik.setFieldValue("locale", selectedLocale);
  }, [selectedLocale]);

  useEffect(() => {
    setSelectedLocale(selectedItem?.locale);
    setSelectedParentId(selectedItem?.parentId);
  }, [selectedItem]);

  const createFormik = useFormik({
    initialValues: {
      name: "",
      linkUrl: "",
      parentId: null,
      imageUrl: null,
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: MenuLinksSchema,
    onSubmit: (values) => {
      createMenuLink
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-menu-link")?.click();
          createFormik.resetForm();
          setSelectedParentId(null);
          setSelectedLocale(APP_DEFAULT_LOCALE);
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      name: selectedItem?.name,
      linkUrl: selectedItem?.linkUrl,
      parentId: selectedItem?.parentId,
      imageUrl: selectedItem?.imageUrl,
      locale: selectedItem?.locale,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: MenuLinksSchema,
    enableReinitialize: true,
    onSubmit: (values) => {
      updateMenuLink
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-menu-link")?.click();
          createFormik.resetForm();
          setSelectedParentId(null);
          setSelectedLocale(APP_DEFAULT_LOCALE);
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const deleteHandler = (id: any) => {
    if (!window.confirm("Are you sure you want to delete this item ?")) return;
    toast.promise(deleteMenuLink.mutateAsync(id), {
      pending: t("please_wait"),
      success: t("deleted_successfully"),
      error: t("something_went_wrong"),
    });
  };

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("menu_links")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-menu-link"
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
          t("url"),
          t("locale"),
          t("parent_id"),
          t("actions"),
        ]}
      >
        {menuLinks?.data?.map((item: any) => (
          <tr>
            <td>{item.id}</td>
            <td>{item.name}</td>
            <td>{item.linkUrl}</td>
            <td>{item.locale}</td>
            <td>{item.parentId ? item.parentId : "- - -"}</td>
            <td>
              <ActionIcon onClick={() => deleteHandler(item.id)}>
                <HiTrash className="text-2xl text-red-500" />
              </ActionIcon>
              <ActionIcon onClick={() => setSelectedId(item.id)}>
                <label htmlFor="update-menu-link" className="cursor-pointer">
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
        current={menuLinks?.currentPage}
        total={menuLinks?.totalPages}
        hasNext={menuLinks?.hasNextPage}
        hasPrev={menuLinks?.hasPreviousPage}
      />

      <Drawer
        title={t("create_menu_link")}
        html="create-menu-link"
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

          <Input
            label={t("url")}
            name="linkUrl"
            onChange={createFormik.handleChange}
            value={createFormik.values.linkUrl}
            error={createFormik.errors.linkUrl}
          />

          <SingleSelect
            id="select-locale"
            label={t("locale")}
            placeholder={t("locale")}
            handler={(value: any) => setSelectedLocale(value)}
            defaultValue={APP_DEFAULT_LOCALE}
            value={selectedLocale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option key={index} value={locale}>
                {locale}
              </option>
            ))}
          </SingleSelect>

          <SingleSelect
            label={t("parent_link")}
            placeholder={t("dont_select_if_parent")}
            handler={(value: any) => setSelectedParentId(value ? value : null)}
            value={selectedParentId}
          >
            {menuLinkList?.data?.map((item: any, index: any) => (
              <option key={index} value={item.id}>
                {item.name}
              </option>
            ))}
          </SingleSelect>
          <br />

          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createMenuLink.isLoading}
          >
            {t("create_menu_link")}
          </Button>
        </form>
      </Drawer>

      <Drawer
        title={t("update_menu_link")}
        html="update-menu-link"
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

          <Input
            label={t("url")}
            name="linkUrl"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.linkUrl}
            error={updateFormik.errors.linkUrl}
          />

          <SingleSelect
            id="select-locale"
            label={t("locale")}
            placeholder={t("locale")}
            handler={(value: any) => setSelectedLocale(value)}
            value={selectedLocale}
          >
            {APP_LOCALE_LIST.map((locale, index) => (
              <option key={index} value={locale}>
                {locale}
              </option>
            ))}
          </SingleSelect>

          <SingleSelect
            label={t("parent_link")}
            placeholder={t("dont_select_if_parent")}
            handler={(value: any) => setSelectedParentId(value ? value : null)}
            value={selectedParentId}
          >
            {menuLinkList?.data?.map((item: any, index: any) => (
              <option key={index} value={item.id}>
                {item.name}
              </option>
            ))}
          </SingleSelect>
          <br />

          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateMenuLink.isLoading}
          >
            {t("update_menu_link")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default MenuLinks;
