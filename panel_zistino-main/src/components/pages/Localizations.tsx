import { FC, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { useFormik } from "formik";
import { toast } from "react-toastify";

import {
  useCreateLocale,
  useDeleteLocale,
  useLocale,
  useResourceSets,
  useUpdateLocale,
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  Table,
  LocaleSchema,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  errorAlert,
} from "../../";

const Localizations: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [selectedLocaleId, setSelectedLocaleId] = useState("");

  const { data: localizations, isLoading } = useLocale();
  const { data: resourceSets } = useResourceSets();
  const createLocale = useCreateLocale();
  const deleteLocale = useDeleteLocale();
  const updateLocale = useUpdateLocale(selectedLocaleId);

  const selectedItem = localizations?.data?.filter(
    (l: any) => l.id === selectedLocaleId
  )[0];

  const createFormik = useFormik({
    initialValues: {
      resourceSet: "",
      locale: APP_DEFAULT_LOCALE,
      key: "",
      text: "",
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: LocaleSchema,
    onSubmit: (values: any) => {
      createLocale
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-locale")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      resourceSet: selectedItem?.resourceSet,
      locale: selectedItem?.locale,
      key: selectedItem?.key,
      text: selectedItem?.text,
    },
    enableReinitialize: true,
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: LocaleSchema,
    onSubmit: (values: any) => {
      updateLocale
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-locale")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>Loading...</div>;

  const deleteHandler = (id: string) => {
    if (!window.confirm("Are you sure you want to delete this item ?")) return;
    toast.promise(deleteLocale.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
    });
  };

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          Localizations
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4">
          <Input
            placeholder="Search"
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-locale"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl mr-1" />
              Add Item
            </label>
          </Button>
        </div>
      </div>
      <Table items={["id", "key", "text", "locale", "resource Set", "actions"]}>
        {localizations?.data
          .filter((lc: any) => {
            return lc.key.toLowerCase().includes(searchValue.toLowerCase());
          })
          .map((lcx: any, index: any) => (
            <tr key={lcx.id}>
              <td>{index + 1}</td>
              <td className="max-w-[200px] truncate">{lcx.key}</td>
              <td className="max-w-[200px] truncate">{lcx.text}</td>
              <td>{lcx.locale}</td>
              <td>{lcx.resourceSet}</td>
              <td>
                <ActionIcon onClick={() => setSelectedLocaleId(lcx.id)}>
                  <label htmlFor="update-locale" className="cursor-pointer">
                    <HiPencil className="text-2xl" />
                  </label>
                </ActionIcon>
                <ActionIcon onClick={() => deleteHandler(lcx.id)}>
                  <HiTrash className="text-2xl text-red-500" />
                </ActionIcon>
              </td>
            </tr>
          ))}
      </Table>
      <Drawer title="Create Item" html="create-locale" position="right">
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label="Key"
            name="key"
            onChange={createFormik.handleChange}
            value={createFormik.values.key}
            error={createFormik.errors.key}
          />
          <Input
            label="Text"
            name="text"
            onChange={createFormik.handleChange}
            value={createFormik.values.text}
            error={createFormik.errors.text}
          />
          <Select
            onChange={createFormik.handleChange}
            error={createFormik.errors.resourceSet}
            label="Resource Set"
            name="resourceSet"
          >
            <option value="">select resource</option>
            {resourceSets?.data?.map((r: any, index: any) => (
              <option key={index} value={r}>
                {r}
              </option>
            ))}
          </Select>

          {/* <Select
            label="Locale"
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
            loading={createLocale.isLoading}
          >
            Create Item
          </Button>
        </form>
      </Drawer>

      <Drawer title="Update Item" html="update-locale" position="right">
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label="Key"
            name="key"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.key}
            error={updateFormik.errors.key}
          />
          <Input
            label="Text"
            name="text"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.text}
            error={updateFormik.errors.text}
          />
          <Select
            onChange={updateFormik.handleChange}
            error={updateFormik.errors.resourceSet}
            label="Resource Set"
            name="resourceSet"
          >
            {resourceSets?.data?.map((r: any, index: any) => (
              <option key={index} value={r}>
                {r}
              </option>
            ))}
          </Select>
          {/* 
          <Select
            label="Locale"
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

          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateLocale.isLoading}
          >
            Create Item
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Localizations;
