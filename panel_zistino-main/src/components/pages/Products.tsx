import { FC, useEffect, useState } from "react";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { useDropzone } from "react-dropzone";
import { useTranslation } from "react-i18next";
import { HiPencil, HiPlusSm, HiTrash, HiKey } from "react-icons/hi";

import {
  useCategoryByType,
  useCreateProduct,
  useDeleteProduct,
  useProductsByCategoryType,
  useSpecifications,
  useUpdateProduct,
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  TextArea,
  post,
  APP_BASE_URL,
  APP_DEFAULT_LOCALE,
  errorAlert,
  successAlert,
  ProTable,
  useProductsGet,
  useProductCodes,
  useBulkImportProductCodes,
} from "../../";
import { ColumnsType } from "antd/lib/table";
import { Avatar } from "antd";

const Products: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState("");
  const [images, setImages] = useState<any>([]);
  const [uploadedImages, setUploadedImages] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const [tagData, setTagData] = useState<any>([]);

  const { t } = useTranslation();
  const [viewCategoryType, setViewCategoryType] = useState<number>(1);
  // relations
  const { data: categoriesType1 } = useCategoryByType(1);
  const { data: categoriesType2 } = useCategoryByType(2);
  const categoriesAll = [
    ...(categoriesType1?.data?.map((c: any) => ({ ...c, type: 1 })) || []),
    ...(categoriesType2?.data?.map((c: any) => ({ ...c, type: 2 })) || []),
  ];
  const { data: specifications } = useSpecifications();

  const [selectedProductId, setSelectedProductId] = useState("");
  const [selectedProductForCodes, setSelectedProductForCodes] = useState("");
  const [codeImportText, setCodeImportText] = useState("");
  const [codeStatusFilter, setCodeStatusFilter] = useState<string | undefined>(undefined);

  const [selectedSp, setSelectedSp] = useState("");
  const [selectedSpData, setSelectedSpData] = useState("");

  const [priceItem, setPriceItem] = useState<any>([]);
  const parseCategoryValue = (value: string): { id: string; type: number } => {
    if (!value) {
      return { id: "", type: 1 };
    }
    const [typePart, ...idParts] = value.split("|");
    const id = idParts.join("|");
    const type = Number(typePart) || 1;
    return { id, type };
  };

  const columns: ColumnsType<any> = [
    {
      title: t("Product Name"),
      dataIndex: "name",
    },
    {
      title: t("category"),
      dataIndex: "categories",
      render(value) {
        let parsedValue: any;
        try {
          parsedValue = typeof value === 'string' ? JSON.parse(value) : value;
        } catch (e) {
          parsedValue = [];
        }
        const firstCategory = parsedValue?.[0];
        if (!firstCategory) return "";
        const match = categoriesAll.find(
          (x) => String(x.id) === String(firstCategory.id)
        );
        return match ? `${match.name} ${match.type === 1 ? '(نوع ۱)' : '(نوع ۲)'}` : firstCategory?.name || "";
      },
    },
    {
      title: t("price"),
      dataIndex: "masterPrice",
      render: (value) => value ? `${parseFloat(value).toLocaleString()} ${t("rials") || "ریال"}` : "-",
    },
    {
      title: t("In_Stock") || "موجودی",
      dataIndex: "inStock",
      render: (value) => value !== undefined && value !== null ? value : 0,
    },
    {
      title: t("image"),
      dataIndex: "masterImage",
      render(record) {
        return (
          <>
            <Avatar src={`${APP_BASE_URL}${record}`} shape="square" />
          </>
        );
      },
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => setSelectedProductId(record.id)}>
              <label htmlFor="update-product" className="cursor-pointer">
                <HiPencil className="text-2xl" />
              </label>
            </ActionIcon>
            <ActionIcon onClick={() => {
              setSelectedProductForCodes(record.id);
              setCodeImportText("");
              setCodeStatusFilter(undefined);
            }}>
              <label htmlFor="product-codes" className="cursor-pointer">
                <HiKey className="text-2xl text-blue-500" />
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

  const {
    data: productsClient,
    isLoading,
    isFetching,
  } = useProductsByCategoryType(page, perPage, searchValue, viewCategoryType);
  const products = productsClient?.data;

  //   const { data: warranties } = useWarranties();
  const deleteProduct = useDeleteProduct();
  const createProduct = useCreateProduct();
  const updateProduct = useUpdateProduct(selectedProductId);
  const { data: productCodesData, isLoading: loadingCodes } = useProductCodes(selectedProductForCodes, codeStatusFilter);
  const bulkImportCodes = useBulkImportProductCodes();

  const { getRootProps, getInputProps } = useDropzone({
    accept: "image/*",
    onDrop: (acceptedFiles) => {
      setImages(
        acceptedFiles.map((file) =>
          Object.assign(file, {
            preview: URL.createObjectURL(file),
          })
        )
      );
    },
  });

  const dataSelectedProduct: any = useProductsGet(selectedProductId);
  const selectedProduct = dataSelectedProduct?.data?.data;

  const createFormik = useFormik({
    initialValues: {
      name: "",
      description: "",
      category: "",
      masterPrice: 1,
      imagesList: "",
      masterImage: "",
      // discountPercent: "",
      inStock: 0,
      brandId: "94860000-b419-c60d-9da1-08dc425079d8",
      locale: APP_DEFAULT_LOCALE,
      categories: "",
      categoryIds: [],
      isActive: true,
    },
    //validationSchema: ProductSchema,
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: false,
    onSubmit: (values: any) => {
      const { id, type } = parseCategoryValue(values.category);
      if (!id) {
        errorAlert({ title: t("please_select_category") || "لطفا دسته بندی را انتخاب کنید" });
        return;
      }

      // محصول همیشه type=1 است، اما دسته‌بندی می‌تواند type=1 یا type=2 باشد
      // دسته‌بندی‌های type=2 از منوی "دسته بندی پسماند" ایجاد می‌شوند
      // Backend می‌تواند integer ID را در categoryIds handle کند (با hash lookup)
      // پس category را حذف می‌کنیم و فقط categoryIds را می‌فرستیم
      delete values.category; // حذف category از values تا backend فقط categoryIds را چک کند
      values.categories = JSON.stringify([{ id, type }]);
      values.categoryIds = [id]; // Backend می‌تواند integer ID را در categoryIds handle کند
      values.imagesList = JSON.stringify([values.masterImage]);

      createProduct
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-product")?.click();
          createFormik.resetForm();
          setImages([]);
          setUploadedImages("");
          setPriceItem([]);
          setTagData([]);
          setSelectedSp("");
          setSelectedSpData("");
          successAlert({ title: t("product_created_successfully") || "محصول با موفقیت ایجاد شد" });
        })
        .catch((err) => {
          errorAlert({ title: err?.response?.data?.error?.[0] || err?.message || t("error_occurred") || "خطایی رخ داد" });
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      name: selectedProduct?.name,
      description: selectedProduct?.description,
      category: (() => {
        try {
          const parsed = JSON.parse(selectedProduct?.categories ?? "[]");
          const first = parsed?.[0];
          if (!first) return "";
          // استفاده از type دسته‌بندی از خود داده (نه viewCategoryType)
          const catType = first?.type || 1;
          return `${catType}|${first.id}`;
        } catch (e) {
          return "";
        }
      })(),
      masterPrice: selectedProduct?.masterPrice,
      imagesList: selectedProduct?.imagesList,
      masterImage: selectedProduct?.masterImage,
      // discountPercent: selectedProduct?.discountPercent,
      inStock: selectedProduct?.inStock || 0,
      brandId: "94860000-b419-c60d-9da1-08dc425079d8",
      categories: "",
      categoryIds: [],
      locale: APP_DEFAULT_LOCALE,
      isActive: true,
    },
    //validationSchema: ProductSchema,
    validateOnChange: false,
    validateOnBlur: false,
    enableReinitialize: true,
    onSubmit: (values: any) => {
      const { id, type } = parseCategoryValue(values.category);
      if (!id) {
        errorAlert({ title: t("please_select_category") || "لطفا دسته بندی را انتخاب کنید" });
        return;
      }
      // محصول همیشه type=1 است، اما دسته‌بندی می‌تواند type=1 یا type=2 باشد
      // دسته‌بندی‌های type=2 از منوی "دسته بندی پسماند" ایجاد می‌شوند
      // Backend می‌تواند integer ID را در categoryIds handle کند (با hash lookup)
      // پس category را حذف می‌کنیم و فقط categoryIds را می‌فرستیم
      delete values.category; // حذف category از values تا backend فقط categoryIds را چک کند
      values.categories = JSON.stringify([{ id, type }]);
      values.categoryIds = [id]; // Backend می‌تواند integer ID را در categoryIds handle کند
      values.imagesList = JSON.stringify([values.masterImage]);

      updateProduct
        .mutateAsync(values)
        .then((response) => {
          document.getElementById("update-product")?.click();
          createFormik.resetForm();
          setImages([]);
          setUploadedImages("");
          setPriceItem([]);
          setTagData([]);
          setSelectedSp("");
          setSelectedSpData("");
          setSelectedProductId(""); // Clear selected product to refresh data
          successAlert({ title: t("product_updated_successfully") || "محصول با موفقیت به‌روزرسانی شد" });
        })
        .catch((err) => {
          console.error("Update error:", err);
          errorAlert({ title: err?.response?.data?.message || err?.message || t("error_occurred") || "خطایی رخ داد" });
        });
    },
  });

  useEffect(() => {
    // revoke the data uris to avoid memory leaks
    images.forEach((file: any) => URL.revokeObjectURL(file.preview));
  }, [images]);

  useEffect(() => {
    setPage(1);
  }, [searchValue]);
  useEffect(() => {
    setPage(1);
  }, [viewCategoryType]);

  useEffect(() => {
    createFormik.setFieldValue("masterImage", uploadedImages);
    updateFormik.setFieldValue("masterImage", uploadedImages);
  }, [uploadedImages]);

  useEffect(() => {
    createFormik.setFieldValue("tags", JSON.stringify(tagData));
  }, [tagData]);

  useEffect(() => {
    createFormik.setFieldValue("specifications", selectedSpData);
    updateFormik.setFieldValue("specifications", selectedSpData);
  }, [selectedSpData]);

  useEffect(() => {
    createFormik.setFieldValue("pricesList", JSON.stringify(priceItem));
  }, [priceItem]);

  const deleteHandler = (id: string) => {
    if (!window.confirm(t("delete_item"))) return;

    toast.promise(deleteProduct.mutateAsync(id), {
      pending: "Please wait...",
      success: "Deleted successfully",
      error: "Something went wrong",
    });
  };

  const removeTagData = (indexToRemove: any) => {
    setTagData([
      ...tagData.filter((_: any, index: any) => index !== indexToRemove),
    ]);
  };

  const addTagData = (event: any) => {
    if (event.target.value === "") return;
    setTagData([...tagData, event.target.value]);
    event.target.value = "";
  };

  const handleImageUpload = async () => {
    if (images.length === 0) return;

    setUploadLoading(true);

    try {
      // Upload only the first image (as masterImage)
      const data = new FormData();
      const file = images[0];
      data.append("file", file); // Backend expects "file" not "image"


      // Try the fileuploader endpoint with folder parameter
      const res = await post("/fileuploader/?folder=app", data, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
      });


      // Backend returns: { data: [{ fileUrl: "...", ... }], messages: ["..."], succeeded: true }
      if (res.data?.succeeded && res.data?.data && Array.isArray(res.data.data) && res.data.data.length > 0) {
        const fileUrl = res.data.data[0].fileUrl;
        if (fileUrl) {
          setUploadedImages(fileUrl);
          successAlert({ title: "uploaded" });
          setImages([]); // Clear images after successful upload
        } else {
          // Fallback: use message if fileUrl not available
          const message = res.data.messages?.[0];
          if (message) {
            setUploadedImages(message);
            successAlert({ title: "uploaded" });
            setImages([]);
          } else {
            errorAlert({ title: "Upload failed: No file URL in response" });
          }
        }
      } else {
        console.error("Unexpected response format:", res.data);
        errorAlert({ title: "Upload failed: Invalid response format" });
      }
    } catch (err: any) {
      console.error("Image upload error:", err);
      console.error("Error response:", err?.response?.data);
      errorAlert({ title: err?.response?.data?.message || err?.message || "something went wrong" });
    } finally {
      setUploadLoading(false);
    }
  };

  const handleSpItems = () => {
    const spInputs = document.querySelectorAll(".sp-inputs");
    const items = Array.from(spInputs)?.map((x: any) => {
      return { [x.name]: x.value };
    });
    let newObj = Object.assign({}, ...items);
    setSelectedSpData(JSON.stringify(newObj));
  };

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          {t("products")}
        </h2>
        <div className="flex flex-wrap gap-4 items-center justify-between md:justify-end">
          <div className="flex flex-col">
            <span className="text-sm text-gray-500 dark:text-gray-300 mb-1">
              {t("category_type") || "نوع نمایش"}
            </span>
            <select
              className="select select-bordered select-sm w-48"
              value={viewCategoryType}
              onChange={(e) => setViewCategoryType(Number(e.target.value))}
            >
              <option value={1}>{t("category_type_product") || "محصولات (نوع ۱)"}</option>
              <option value={2}>{t("category_type_waste") || "پسماندها (نوع ۲)"}</option>
            </select>
          </div>
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-product"
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
          dataSource={products?.data}
          configData={products}
          page={page}
          perPage={perPage}
          setPage={setPage}
          setPerPage={setPerPage}
        />
      )}
      {/* <Table
        items={[
          t("name"),
          t("description"),
          t("rate"),
          t("master"),
          t("active"),
          t("tags"),
          t("category"),
          t("brand"),
          t("image"),
          t("actions"),
        ]}
      >
        {products?.data
          ?.filter((product: any) => {
            return product.name
              .toLowerCase()
              .includes(searchValue.toLowerCase());
          })
          ?.map((product: any) => (
            <tr key={product.id}>
              <td>{product.name}</td>
              <td className="truncate max-w-[100px]">{product.description}</td>
              <td>{product.rate}</td>
              <td>
                {product.isMaster ? <HiCheck className="text-xl" /> : <HiX />}
              </td>
              <td>
                {product.isActive ? <HiCheck className="text-xl" /> : <HiX />}
              </td>
              <td>
                <div className="space-x-3 max-w-[200px] truncate pb-2">
                  {jsonDecode(product?.tags)?.map((tag: any, index: any) => (
                    <div
                      className="badge badge-outline text-xs text-gray-700 dark:text-white"
                      key={index}
                    >
                      {tag}
                    </div>
                  ))}
                </div>
              </td>
              <td>{jsonDecode(product?.category)?.name}</td>
              <td className="truncate max-w-[50px] cursor-pointer">
                {product.brandName}
              </td>
              <td>
                <div className="flex flex-row-reverse justify-center">
                  {jsonDecode(product?.imagesList)
                    ?.slice(0, 3)
                    ?.map((path: any, index: any) => (
                      <div
                        key={index}
                        className="flex relative justify-center items-center m-1 mr-2 -ml-5 rounded-full border border-gray-500"
                      >
                        <img
                          className="w-9 h-9 rounded-full object-cover"
                          src={APP_BASE_URL + path}
                          alt=" "
                        />
                      </div>
                    ))}
                </div>
              </td>

              <td>
                <ActionIcon onClick={() => setSelectedProductId(product.id)}>
                  <label htmlFor="update-product" className="cursor-pointer">
                    <HiPencil className="text-2xl" />
                  </label>
                </ActionIcon>
                <ActionIcon onClick={() => deleteHandler(product.id)}>
                  <HiTrash className="text-2xl text-red-500" />
                </ActionIcon>
              </td>
            </tr>
          ))}
      </Table> */}

      {/* <Pagination
        page={page}
        setPage={setPage}
        current={products?.currentPage}
        total={products?.totalPages}
        hasNext={products?.hasNextPage}
        hasPrev={products?.hasPreviousPage}
      /> */}

      <Drawer
        title={t("create_product")}
        html="create-product"
        position="right"
      >
        <form
          onSubmit={createFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Input
            label={t("name")}
            name="name"
            onChange={createFormik.handleChange}
            value={createFormik.values.name}
            error={createFormik.errors.name}
          />
          <TextArea
            label={t("description")}
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />

          <Input
            label={t("price")}
            name="masterPrice"
            type="number"
            min="1"
            onChange={createFormik.handleChange}
            value={createFormik.values.masterPrice}
            error={createFormik.errors.masterPrice}
          />
          {/* <Input
            label="Discount Percent"
            name="discountPercent"
            type="number"
            min="0"
            onChange={createFormik.handleChange}
            value={createFormik.values.discountPercent}
            error={createFormik.errors.discountPercent}
          /> */}
          <Input
            label={t("In_Stock") || "موجودی"}
            name="inStock"
            type="number"
            min="0"
            onChange={(e) => {
              const value = e.target.value === "" ? 0 : parseInt(e.target.value, 10) || 0;
              createFormik.setFieldValue("inStock", value);
            }}
            value={createFormik.values.inStock}
            error={createFormik.errors.inStock}
          />
          <Select
            label={t("category")}
            name="category"
            onChange={(e) => {
              createFormik.setFieldValue("category", e.target.value);
            }}
            value={createFormik.values.category || ""}
            error={createFormik.errors.category}
          >
            <option value="">{t("select")}</option>
            <optgroup label={t("category_type_product") || "دسته‌های نوع ۱ (محصول)"}>
              {categoriesType1?.data?.map((category: any) => (
                <option key={category.id} value={`1|${category.id}`}>
                  {category.name}
                </option>
              ))}
            </optgroup>
            <optgroup label={t("category_type_waste") || "دسته‌های نوع ۲ (پسماند) - از منوی 'دسته بندی پسماند' ایجاد شده‌اند"}>
              {categoriesType2?.data?.map((category: any) => (
                <option key={category.id} value={`2|${category.id}`}>
                  {category.name}
                </option>
              ))}
            </optgroup>
          </Select>
          <p className="text-xs text-gray-500 dark:text-gray-300">
            {t("category_type_hint") || "می‌توانید از دسته‌های نوع ۱ (محصول) یا دسته‌های نوع ۲ (پسماند) که در منوی 'مدیریت پسماند > دسته بندی پسماند' ایجاد شده‌اند، انتخاب کنید."}
          </p>

          <div>
            <label className="label mb-2">
              <span className="label-text dark:text-gray-200 text-gray-500">
                {t("images")}
              </span>
            </label>
            <section className="bg-[#f1f1f1] dark:bg-[#3d4451] p-5 rounded-lg">
              <div {...getRootProps({ className: "dropzone" })}>
                <input {...getInputProps()} />
                <p className="text-sm opacity-75 font-light">
                  {t("content_uploader")}
                </p>
              </div>
              <aside className="flex space-x-3 mt-4">
                {images.map((image: any) => (
                  <div key={image.name}>
                    <div>
                      <img
                        className="rounded-lg w-12 h-12 object-cover"
                        src={image.preview}
                      />
                    </div>
                  </div>
                ))}
              </aside>
              <div className="mt-3 space-x-2">
                <button
                  onClick={handleImageUpload}
                  className="btn btn-xs btn-ghost text-xs"
                  type="button"
                  disabled={uploadLoading}
                >
                  {t("upload")}
                </button>
                <button
                  onClick={() => setImages([])}
                  className="btn btn-xs btn-ghost text-xs"
                  disabled={uploadLoading}
                  type="button"
                >
                  {t("clear")}
                </button>
              </div>
            </section>
          </div>

          <Button
            type="submit"
            loading={createProduct.isLoading}
            className="btn-block font-semibold rtl:font-rtl-semibold"
          >
            {t("create_product")}
          </Button>
        </form>
      </Drawer>

      <Drawer
        title={t("Update_Product")}
        html="update-product"
        position="right"
      >
        <form
          onSubmit={updateFormik.handleSubmit}
          className="space-y-5"
          onKeyDown={(keyEvent) => {
            if ((keyEvent.charCode || keyEvent.keyCode) === 13) {
              keyEvent.preventDefault();
            }
          }}
        >
          <Input
            label={t("name")}
            name="name"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.name}
            error={updateFormik.errors.name}
          />
          <TextArea
            label={t("description")}
            name="description"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.description}
            error={updateFormik.errors.description}
          />

          <div className="grid grid-cols-2 gap-6">
            <Input
              label={t("Master_Price")}
              name="masterPrice"
              type="number"
              min="1"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.masterPrice}
              error={updateFormik.errors.masterPrice}
            />
            {/* <Input
              label="Discount Percent"
              name="discountPercent"
              type="number"
              min="0"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.discountPercent}
              error={updateFormik.errors.discountPercent}
            /> */}

            <Input
              label={t("In_Stock") || "موجودی"}
              name="inStock"
              type="number"
              min="0"
              onChange={(e) => {
                const value = e.target.value === "" ? 0 : parseInt(e.target.value, 10) || 0;
                updateFormik.setFieldValue("inStock", value);
              }}
              value={updateFormik.values.inStock}
              error={updateFormik.errors.inStock}
            />
          </div>

          <Select
            label={t("category")}
            name="category"
            onChange={(e) => {
              updateFormik.setFieldValue("category", e.target.value);
            }}
            value={updateFormik.values.category || ""}
            error={updateFormik.errors.category}
          >
            <option value="">{t("select")}</option>
            <optgroup label={t("category_type_product") || "دسته‌های نوع ۱ (محصول)"}>
              {categoriesType1?.data?.map((category: any) => (
                <option key={category.id} value={`1|${category.id}`}>
                  {category.name}
                </option>
              ))}
            </optgroup>
            <optgroup label={t("category_type_waste") || "دسته‌های نوع ۲ (پسماند) - از منوی 'دسته بندی پسماند' ایجاد شده‌اند"}>
              {categoriesType2?.data?.map((category: any) => (
                <option key={category.id} value={`2|${category.id}`}>
                  {category.name}
                </option>
              ))}
            </optgroup>
          </Select>
          <p className="text-xs text-gray-500 dark:text-gray-300 mb-2">
            {t("category_type_hint") || "می‌توانید از دسته‌های نوع ۱ (محصول) یا دسته‌های نوع ۲ (پسماند) که در منوی 'مدیریت پسماند > دسته بندی پسماند' ایجاد شده‌اند، انتخاب کنید."}
          </p>

          <div>
            <label className="label mb-2">
              <span className="label-text dark:text-gray-200 text-gray-500">
                {t("images")}
              </span>
            </label>
            <section className="bg-[#f1f1f1] dark:bg-[#3d4451] p-5 rounded-lg">
              <div {...getRootProps({ className: "dropzone" })}>
                <input {...getInputProps()} />
                <p className="text-sm opacity-75 font-light">
                  {t("content_uploader")}
                </p>
              </div>
              <aside className="flex space-x-3 mt-4">
                {images.map((image: any) => (
                  <div key={image.name}>
                    <div>
                      <img
                        className="rounded-lg w-12 h-12 object-cover"
                        src={image.preview}
                      />
                    </div>
                  </div>
                ))}
              </aside>
              <div className="mt-3 space-x-2">
                <button
                  onClick={handleImageUpload}
                  className="btn btn-xs btn-ghost text-xs"
                  type="button"
                  disabled={uploadLoading}
                >
                  {t("upload")}
                </button>
                <button
                  onClick={() => setImages([])}
                  className="btn btn-xs btn-ghost text-xs"
                  disabled={uploadLoading}
                  type="button"
                >
                  {t("clear")}
                </button>
              </div>
            </section>
          </div>

          <Button
            type="submit"
            loading={updateProduct.isLoading}
            className="btn-block font-semibold rtl:font-rtl-semibold"
          >
            {t("Update_Product")}
          </Button>
        </form>
      </Drawer>

      {/* Product Codes Management Drawer */}
      <Drawer
        title={t("product_codes") || "مدیریت کدهای محصول"}
        html="product-codes"
        position="right"
      >
        <div className="space-y-4">
          {selectedProductForCodes && (
            <>
              <div className="mb-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
                <p className="text-sm text-gray-700 dark:text-gray-300">
                  {t("product_codes_explanation") || "برای محصولات شارژ سیم‌کارت، کدهای شارژ را در اینجا وارد کنید. هنگام خرید مشتری، کد به صورت خودکار به او اختصاص می‌یابد."}
                </p>
              </div>

              {/* Statistics */}
              {productCodesData && Array.isArray(productCodesData) && (
                <div className="grid grid-cols-3 gap-4 mb-4">
                  <div className="p-3 bg-green-50 dark:bg-green-900/20 rounded-lg text-center">
                    <div className="text-2xl font-bold text-green-600 dark:text-green-400">
                      {productCodesData.filter((c: any) => c.status === 'unused').length}
                    </div>
                    <div className="text-sm text-gray-600 dark:text-gray-400">{t("unused") || "استفاده نشده"}</div>
                  </div>
                  <div className="p-3 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg text-center">
                    <div className="text-2xl font-bold text-yellow-600 dark:text-yellow-400">
                      {productCodesData.filter((c: any) => c.status === 'assigned').length}
                    </div>
                    <div className="text-sm text-gray-600 dark:text-gray-400">{t("assigned") || "اختصاص یافته"}</div>
                  </div>
                  <div className="p-3 bg-gray-50 dark:bg-gray-800 rounded-lg text-center">
                    <div className="text-2xl font-bold text-gray-600 dark:text-gray-400">
                      {productCodesData.filter((c: any) => c.status === 'used').length}
                    </div>
                    <div className="text-sm text-gray-600 dark:text-gray-400">{t("used") || "استفاده شده"}</div>
                  </div>
                </div>
              )}

              {/* Filter */}
              <div className="flex gap-2">
                <Select
                  label={t("filter_by_status") || "فیلتر بر اساس وضعیت"}
                  value={codeStatusFilter || ""}
                  onChange={(e) => setCodeStatusFilter(e.target.value || undefined)}
                >
                  <option value="">{t("all") || "همه"}</option>
                  <option value="unused">{t("unused") || "استفاده نشده"}</option>
                  <option value="assigned">{t("assigned") || "اختصاص یافته"}</option>
                  <option value="used">{t("used") || "استفاده شده"}</option>
                </Select>
              </div>

              {/* Bulk Import */}
              <div className="border rounded-lg p-4">
                <h3 className="font-semibold mb-2">{t("bulk_import_codes") || "وارد کردن کدها"}</h3>
                <TextArea
                  label={t("codes_one_per_line") || "کدها را در هر خط وارد کنید"}
                  value={codeImportText}
                  onChange={(e) => setCodeImportText(e.target.value)}
                  rows={6}
                  placeholder={t("codes_placeholder") || "ABC-123\nXYZ-789\nDEF-456"}
                />
                <Button
                  onClick={() => {
                    if (!codeImportText.trim()) {
                      errorAlert({ title: t("please_enter_codes") || "لطفا کدها را وارد کنید" });
                      return;
                    }
                    const codes = codeImportText
                      .split('\n')
                      .map(line => line.trim())
                      .filter(line => line.length > 0);

                    if (codes.length === 0) {
                      errorAlert({ title: t("no_valid_codes") || "هیچ کد معتبری یافت نشد" });
                      return;
                    }

                    bulkImportCodes
                      .mutateAsync({ productId: selectedProductForCodes, codes })
                      .then((res) => {
                        successAlert({
                          title: `${t("codes_imported_successfully") || "کدها با موفقیت وارد شدند"}: ${res.imported} ${t("imported") || "وارد شده"}, ${res.skipped} ${t("skipped") || "رد شده"}`
                        });
                        setCodeImportText("");
                      })
                      .catch((err) => {
                        errorAlert({ title: err?.response?.data?.detail || err?.message || t("error_occurred") || "خطایی رخ داد" });
                      });
                  }}
                  loading={bulkImportCodes.isLoading}
                  className="mt-2"
                >
                  {t("import_codes") || "وارد کردن کدها"}
                </Button>
              </div>

              {/* Codes List */}
              <div className="border rounded-lg p-4">
                <h3 className="font-semibold mb-2">{t("codes_list") || "لیست کدها"}</h3>
                {loadingCodes ? (
                  <div>{t("loading")}</div>
                ) : productCodesData && Array.isArray(productCodesData) && productCodesData.length > 0 ? (
                  <div className="space-y-2 max-h-96 overflow-y-auto">
                    {productCodesData.map((code: any) => (
                      <div
                        key={code.id}
                        className={`p-3 border rounded-lg flex justify-between items-center ${code.status === 'unused' ? 'bg-green-50 dark:bg-green-900/20' :
                          code.status === 'assigned' ? 'bg-yellow-50 dark:bg-yellow-900/20' :
                            'bg-gray-50 dark:bg-gray-800'
                          }`}
                      >
                        <div className="flex-1">
                          <div className="font-mono text-sm">{code.code}</div>
                          <div className="text-xs text-gray-500">
                            {code.status === 'unused' && t("unused")}
                            {code.status === 'assigned' && `${t("assigned")} - ${code.assignedAt ? new Date(code.assignedAt).toLocaleDateString('fa-IR') : ''}`}
                            {code.status === 'used' && `${t("used")} - ${code.usedAt ? new Date(code.usedAt).toLocaleDateString('fa-IR') : ''}`}
                          </div>
                        </div>
                        <div className="text-xs">
                          {code.status === 'unused' && (
                            <span className="px-2 py-1 bg-green-200 dark:bg-green-800 rounded">{t("unused")}</span>
                          )}
                          {code.status === 'assigned' && (
                            <span className="px-2 py-1 bg-yellow-200 dark:bg-yellow-800 rounded">{t("assigned")}</span>
                          )}
                          {code.status === 'used' && (
                            <span className="px-2 py-1 bg-gray-200 dark:bg-gray-700 rounded">{t("used")}</span>
                          )}
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-8 text-gray-500">
                    {t("no_codes_found") || "هیچ کدی یافت نشد"}
                  </div>
                )}
              </div>
            </>
          )}
        </div>
      </Drawer>
    </>
  );
};

export default Products;
