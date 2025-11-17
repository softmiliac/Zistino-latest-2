import { FC, useCallback, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import {
  Pagination,
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  Table,
  TextArea,
  post,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  useCategoryByType,
  useCreateSection,
  useDeleteSection,
  useProducts,
  useProductSections,
  useUpdateSection,
  errorAlert,
  successAlert,
  ProTable,
  useProductSectionsGet,
} from "../../";
import { ColumnsType } from "antd/lib/table";

const ProductSection: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState("");
  const [selectedItemId, setSelectedItemId] = useState<string>("");
  const [image, setImage] = useState<any>("");
  const [uploadedImage, setUploadedImage] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const { t } = useTranslation();
  const columns: ColumnsType<any> = [
    {
      title: t("id"),
      dataIndex: "id",
    },
    {
      title: t("group_name"),
      dataIndex: "groupName",
    },
    {
      title: t("page_name"),
      dataIndex: "page",
    },
    // {
    //   title: t("locale"),
    //   dataIndex: "locale",
    // },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => deleteHandler(record.id)}>
              <HiTrash className="text-2xl text-red-500" />
            </ActionIcon>
            {/* <ActionIcon onClick={() => setSelectedItemId(record.id)}>
              <label htmlFor="update-item" className="cursor-pointer">
                <HiPencil className="text-2xl" />
              </label>
            </ActionIcon> */}
          </>
        );
      },
    },
  ];
  // 0 - product , 1 - banner
  const [selectedPsType, setSelectedPsType] = useState<number>(0);
  // 0 - horizontal , 1 - vertical , 2 - scrollable , 3 - offer , 4 - category, 5 - banner
  const [selectedOrderType, setSelectedOrderType] =
    useState<any>('{"type": 0}');

  const [expireDate, setExpireDate] = useState<any>("");
  const [selectedCategoryId, setSelectedCategoryId] = useState<any>("");

  const { data: sections, isFetching } = useProductSections(
    page,
    perPage,
    searchValue
  );
  const { data: categories } = useCategoryByType(1);
  const deleteProductSection = useDeleteSection();
  const createProductSection = useCreateSection();
  const updateProductSection = useUpdateSection(selectedItemId);

  const { data: products } = useProducts();

  const dataSelectedItem = useProductSectionsGet(selectedItemId) as any;
  const selectedItem = dataSelectedItem?.data?.data;

  useEffect(() => {
    createFormik.setFieldValue("imagePath", uploadedImage);
  }, [uploadedImage]);
  const handleValues = useCallback(
    (values: any) => {
      const namesG =
        selectedPsType == 1
          ? "بنر"
          : selectedOrderType == '{"type": 0}'
            ? "افقی"
            : selectedOrderType == '{"type": 1}'
              ? "عمودی"
              : selectedOrderType == '{"type": 2}'
                ? "اسکرول"
                : "دسته بندی";
      return {
        groupName: namesG, // values.groupName,
        name: namesG, //values.name,
        page: "home", //values.page,
        productId: values.productId === "" ? null : values.productId,
        description: "", // values.description,
        imagePath: values.imagePath === "" ? null : values.imagePath,
        linkUrl: values.linkUrl === "" ? null : values.linkUrl,
        locale: values.locale,
        setting:
          selectedPsType == 0
            ? values.productId === ""
              ? null
              : selectedOrderType == '{"type": 3}'
                ? JSON.stringify({
                  type: 3,
                  expireDate: new Date(expireDate).toISOString(),
                })
                : selectedOrderType == '{"type": 4}'
                  ? JSON.stringify({ type: 4, categoryId: selectedCategoryId })
                  : selectedOrderType
            : '{"type": 5}',
      };
    },
    [
      selectedOrderType,
      expireDate,
      selectedCategoryId,
      selectedPsType,
      uploadedImage,
    ]
  );
  const createFormik = useFormik({
    initialValues: {
      groupName: "",
      name: "",
      // page: "",
      productId: "",
      description: "",
      imagePath: "",
      linkUrl: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: false,
    onSubmit: (values: any) => {
      // if (values.groupName == "") return;
      // if (values.page == "") return;
      if (selectedPsType == 0 && values.productId == "") return;

      const data = handleValues(values);

      createProductSection
        .mutateAsync(data)
        .then(() => {
          document.getElementById("create-item")?.click();

          if (document.getElementById("select-product-id")) {
            // @ts-ignore
            document.getElementById("select-product-id").selectedIndex = "0";
          }
          if (document.getElementById("select-ot-id")) {
            // @ts-ignore
            document.getElementById("select-ot-id").selectedIndex = "0";
          }
          if (document.getElementById("select-ps-type")) {
            // @ts-ignore
            document.getElementById("select-ps-type").selectedIndex = "0";
          }
          setSelectedPsType(0);
          setImage("");

          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      // groupName: selectedItem?.groupName,
      page: "home", //selectedItem?.page,
      productId: selectedItem?.product?.id,
      description: "", // selectedItem?.description,
      locale: selectedItem?.locale,
    },
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: true,
    onSubmit: (values: any) => {
      // if (updateFormik.values.groupName == "") return;
      // if (updateFormik.values.page == "") return;
      if (updateFormik.values.productId == "") return;

      updateProductSection
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-item")?.click();
          // @ts-ignore
          document.getElementById("select-product-id").selectedIndex = "0";
          // @ts-ignore
          document.getElementById("select-ps-type").selectedIndex = "0";
          updateFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const deleteHandler = (id: string) => {
    if (!window.confirm("Are you sure you want to delete this item ?")) return;
    toast.promise(deleteProductSection.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
    });
  };

  const handleImageUpload = async () => {
    if (image === "") return;

    setUploadLoading(true);

    const data = new FormData();
    data.append("file", image); // Backend expects "file" not "image"

    try {
      const res = await post("/fileuploader/?folder=app", data, {
        headers: {
          "content-type": "multipart/form-data",
        },
      });

      // Backend returns: { data: [{ fileUrl: "...", ... }], messages: ["..."], succeeded: true }
      if (res.data?.succeeded && res.data?.data && Array.isArray(res.data.data) && res.data.data.length > 0) {
        const fileUrl = res.data.data[0].fileUrl;
        if (fileUrl) {
          setUploadedImage(fileUrl);
          successAlert({ title: "uploaded" });
          setImage("");
        } else {
          // Fallback: use message if fileUrl not available
          const message = res.data.messages?.[0];
          if (message) {
            setUploadedImage(message);
            successAlert({ title: "uploaded" });
            setImage("");
          } else {
            errorAlert({ title: "Upload failed: No file URL in response" });
          }
        }
      } else if (res.data?.data?.path) {
        // Fallback for old response format
        setUploadedImage(res.data.data.path);
        successAlert({ title: "uploaded" });
        setImage("");
      } else {
        errorAlert({ title: "Upload failed: Invalid response format" });
      }
    } catch (err: any) {
      console.error("Image upload error:", err);
      errorAlert({ title: err?.response?.data?.message || err?.message || "something went wrong" });
    } finally {
      setUploadLoading(false);
      setImage("");
    }
  };

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("product_sections")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-item"
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
        dataSource={sections?.data}
        configData={sections}
        page={page}
        perPage={perPage}
        setPage={setPage}
        setPerPage={setPerPage}
      />
      <Drawer
        title={t("create_product_section")}
        html="create-item"
        position="right"
      >
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          {/* <Input
            label={t("group_name")}
            name="groupName"
            onChange={createFormik.handleChange}
            value={createFormik.values.groupName}
            error={createFormik.errors.groupName}
          /> */}

          {/* <Input
            label={t("page_name")}
            name="page"
            onChange={createFormik.handleChange}
            value={createFormik.values.page}
            error={createFormik.errors.page}
          /> */}
          {/* <Input
            label={t("name")}
            name="name"
            onChange={createFormik.handleChange}
            value={createFormik.values.name}
            error={createFormik.errors.name}
          /> */}
          {/* <TextArea
            label={t("description")}
            name="description"
            placeholder={t("optional")}
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          /> */}

          <Select
            id="select-ps-type"
            label={t("type")}
            onChange={(e: any) => setSelectedPsType(e.target.value)}
          >
            <option value="0">{t("product")}</option>
            <option value="1">{t("banner")}</option>
          </Select>

          {selectedPsType == 0 && (
            <>
              <Select
                id="select-product-id"
                label={t("product")}
                name="productId"
                onChange={createFormik.handleChange}
                error={createFormik.errors.productId}
              >
                <option value="">{t("select_product")}</option>
                {products?.data?.map((item: any) => {
                  return (
                    <option key={item.id} value={item.id}>
                      {item.name}
                    </option>
                  );
                })}
              </Select>

              <Select
                label={t("order_type")}
                id="select-ot-id"
                onChange={(e: any) => setSelectedOrderType(e.target.value)}
              >
                <option value='{"type": 0}'>{t("horizontal")}</option>
                <option value='{"type": 1}'>{t("vertical")}</option>
                <option value='{"type": 2}'>{t("scrollable")}</option>
                {/* <option value='{"type": 3}'>{t("offer")}</option> */}
                <option value='{"type": 4}'>{t("category")}</option>
              </Select>

              {selectedOrderType == '{"type": 3}' && (
                <>
                  {/* <Input
                    label={t("offer_expire_date")}
                    //type="datetime-local"
                    onChange={(e) => setExpireDate(e.target.value)}
                  /> */}
                </>
              )}

              {selectedOrderType == '{"type": 4}' && (
                <>
                  <Select
                    id="select-category-id"
                    label={t("category")}
                    onChange={(e) => setSelectedCategoryId(e.target.value)}
                  >
                    <option value="">{t("category")}</option>
                    {categories?.data?.map((item: any) => {
                      return (
                        <option key={item.id} value={item.id}>
                          {item.name}
                        </option>
                      );
                    })}
                  </Select>
                </>
              )}
            </>
          )}

          {selectedPsType == 1 && (
            <>
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
              <Input
                label={t("url")}
                name="linkUrl"
                onChange={createFormik.handleChange}
                placeholder="/http://examples.exp"
                value={createFormik.values.linkUrl}
                error={createFormik.errors.linkUrl}
              />
            </>
          )}

          {/* <Select
            label={t("category")}
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
            loading={createProductSection.isLoading}
          >
            {t("create_product_section")}
          </Button>
        </form>
      </Drawer>

      <Drawer
        title={t("update_product_section")}
        html="update-item"
        position="right"
      >
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          {/* <Input
            label={t("group_name")}
            name="groupName"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.groupName}
            error={updateFormik.errors.groupName}
          /> */}
          {/* <Input
            label={t("page_name")}
            name="page"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.page}
            error={updateFormik.errors.page}
          /> */}
          {/* <TextArea
            label={t("description")}
            name="description"
            placeholder="optional"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.description}
            error={updateFormik.errors.description}
          /> */}

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
                selected={locale === selectedItem?.locale}
              >
                {locale}
              </option>
            ))}
          </Select> */}

          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createProductSection.isLoading}
          >
            {t("update_product_section")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default ProductSection;
