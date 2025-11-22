import { FC, useEffect, useState } from "react";
import { toast } from "react-toastify";
import { useFormik } from "formik";
import { useDropzone } from "react-dropzone";
import { useTranslation } from "react-i18next";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";

import {
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
  useCategoryByType,
  useCategoryClientByType,
  post,
  APP_BASE_URL,
  APP_DEFAULT_LOCALE,
  errorAlert,
  successAlert,
  ProTable,
  useProductsGet,
} from "../..";
import { ColumnsType } from "antd/lib/table";
import { Avatar } from "antd";

const ProductsRecycle: FC = () => {
  const [page, setPage] = useState<number>(1);
  const [perPage, setPerPage] = useState<number>(5);
  const [searchValue, setSearchValue] = useState("");
  const [images, setImages] = useState<any>([]);
  const [uploadedImages, setUploadedImages] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const [tagData, setTagData] = useState<any>([]);

  const { t } = useTranslation();

  const [selectedProductId, setSelectedProductId] = useState("");

  const [selectedSp, setSelectedSp] = useState("");
  const [selectedSpData, setSelectedSpData] = useState("");

  const [priceItem, setPriceItem] = useState<any>([]);
  const columns: ColumnsType<any> = [
    {
      title: t("name"),
      dataIndex: "name",
    },
    {
      title: t("category"),
      dataIndex: "categories",
      render(value) {
        let parsedValue;
        try {
          parsedValue = typeof value === 'string' ? JSON.parse(value) : value;
        } catch (e) {
          parsedValue = [];
        }
        // Handle both UUID strings and integer IDs
        if (parsedValue && parsedValue.length > 0 && parsedValue[0]) {
          const categoryId = parsedValue[0].id;
          const category = categories?.data?.find(
            (x: any) => {
              // Compare as strings for UUIDs, or as numbers for integers
              return String(x.id) === String(categoryId) ||
                (typeof x.id === 'number' && typeof categoryId === 'number' && x.id === categoryId);
            }
          );
          // Return category name if found, otherwise try to get name from parsedValue
          return category?.name || parsedValue[0]?.name || "";
        }
        return "";
      },
    },
    {
      title: t("In_Stock"),
      dataIndex: "inStock",
    },
    {
      title: t("price"),
      dataIndex: "masterPrice",
      render: (value) => value ? `${parseFloat(value).toLocaleString()} ${t("rials") || "ریال"}` : "-",
    },
    {
      title: t("image"),
      dataIndex: "masterImage",
      render(record) {
        if (!record) return "-";
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
  } = useProductsByCategoryType(page, perPage, searchValue, 2);
  const products = productsClient?.data;
  // const { data: warranties } = useWarranties();
  const deleteProduct = useDeleteProduct();
  const createProduct = useCreateProduct();
  const updateProduct = useUpdateProduct(selectedProductId);

  // relations - Use client endpoint to get sequential IDs that match product categories field
  const { data: categories } = useCategoryClientByType(2);
  const { data: specifications } = useSpecifications();

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
      inStock: "",
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
      values.categories = JSON.stringify([{ id: values.category, type: 2 }]);
      values.categoryIds = [values.category];
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
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik({
    initialValues: {
      name: selectedProduct?.name,
      description: selectedProduct?.description,
      category: (() => {
        try {
          return JSON.parse(selectedProduct?.categories ?? "[]")?.[0]?.id;
        } catch (e) {
          return undefined;
        }
      })(),
      masterPrice: selectedProduct?.masterPrice,
      imagesList: selectedProduct?.imagesList,
      masterImage: selectedProduct?.masterImage,
      // discountPercent: selectedProduct?.discountPercent,
      inStock: selectedProduct?.inStock,
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
      values.categories = JSON.stringify([{ id: values.category }]);
      values.categoryIds = [values.category];
      values.imagesList = JSON.stringify([values.masterImage]);
      updateProduct
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-product")?.click();
          createFormik.resetForm();
          setImages([]);
          setUploadedImages("");
          setPriceItem([]);
          setTagData([]);
          setSelectedSp("");
          setSelectedSpData("");
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  useEffect(() => {
    // revoke the data uris to avoid memory leaks
    return () => {
      images.forEach((file: any) => {
        if (file.preview) {
          URL.revokeObjectURL(file.preview);
        }
      });
    };
  }, [images]);

  useEffect(() => {
    setPage(1);
  }, [searchValue]);

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

  //  if (isLoading) return <div>Loading...</div>;

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
          {t("recycles")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
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

      <Drawer
        title={t("create_Residue")}
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
            label={t("In_Stock")}
            name="inStock"
            type="number"
            min="1"
            onChange={createFormik.handleChange}
            value={createFormik.values.inStock}
            error={createFormik.errors.inStock}
          />
          <Select
            label={t("category")}
            name="category"
            onChange={createFormik.handleChange}
            value={createFormik.values.category}
            error={createFormik.errors.category}
          >
            <option value="">انتخاب</option>
            {categories?.data?.map((category: any) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </Select>

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
                        onError={(e) => {
                          // Hide image if blob URL fails
                          e.currentTarget.style.display = 'none';
                        }}
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
            {t("create_Residue")}
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
            label={t("firstname")}
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
              label={t("In_Stock")}
              name="inStock"
              type="number"
              min="1"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.inStock}
              error={updateFormik.errors.inStock}
            />
          </div>

          <Select
            label={t("category")}
            name="category"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.category}
            error={updateFormik.errors.category}
          >
            {categories?.data?.map((category: any) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </Select>

          <div>
            <label className="label mb-2">
              <span className="label-text dark:text-gray-200 text-gray-500">
                {t("image")}
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
                        onError={(e) => {
                          // Hide image if blob URL fails
                          e.currentTarget.style.display = 'none';
                        }}
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
    </>
  );
};

export default ProductsRecycle;
