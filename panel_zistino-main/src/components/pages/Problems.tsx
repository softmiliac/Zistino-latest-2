import { FC, useEffect, useState } from "react";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { useFormik } from "formik";

import {
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
  useCreateProblem,
  useDeleteProblem,
  useProblems,
  useProducts,
  useUpdateProblem,
  ProblemSchema,
  errorAlert,
  successAlert,
} from "../../";

const Problems: FC = () => {
  const [searchValue, setSearchValue] = useState<string>("");
  const [image, setImage] = useState<any>("");
  const [uploadedImage, setUploadedImage] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const [selectedProblemId, setSelectedProblemId] = useState<any>("");

  const { data: problems, isLoading } = useProblems();
  const { data: products } = useProducts();
  const deleteProblem = useDeleteProblem();
  const createProblem = useCreateProblem();
  const updateProblem = useUpdateProblem(selectedProblemId);

  const selectedProblem = problems?.data?.filter(
    (p: any) => p.id === selectedProblemId
  )[0];

  useEffect(() => {
    createFormik.setFieldValue("iconUrl", uploadedImage);
  }, [uploadedImage]);

  const createFormik = useFormik<IProblem>({
    initialValues: {
      title: "",
      description: "",
      iconUrl: "",
      parentId: 0,
      repairDuration: 0,
      price: 0,
      productId: "",
      priority: 0,
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: ProblemSchema,
    onSubmit: (values) => {
      if (values.parentId === 0) {
        delete values.parentId;
      }
      createProblem
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-problem")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik<IProblem>({
    initialValues: {
      title: selectedProblem?.title,
      description: selectedProblem?.description,
      iconUrl: selectedProblem?.iconUrl,
      parentId: selectedProblem?.parent?.id,
      repairDuration: selectedProblem?.repairDuration,
      price: selectedProblem?.price,
      productId: selectedProblem?.product?.id,
      priority: selectedProblem?.priority,
      locale: selectedProblem?.locale,
    },
    enableReinitialize: true,
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: ProblemSchema,
    onSubmit: (values) => {
      if (values.parentId === 0) {
        delete values.parentId;
      }
      updateProblem
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-problem")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>Loading...</div>;

  const deleteHandler = (id: any) => {
    if (!window.confirm("Are you sure you want to delete this problem ?"))
      return;
    toast.promise(deleteProblem.mutateAsync(id), {
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

  return (
    <>
      <div className="md:flex space-y-6 md:space-y-0 items-center justify-between pb-[1.7rem] border-b border-gray-400/30 dark:border-gray-300/20">
        <h2 className="text-[1.4rem] font-semibold rtl:font-rtl-semibold">
          Problems
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4">
          <Input
            placeholder="Search"
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-problem"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl mr-1" />
              Add Item
            </label>
          </Button>
        </div>
      </div>

      <Table
        items={[
          "title",
          "locale",
          "parent",
          "product",
          "repair duration",
          "priority",
          "price",
          "Actions",
        ]}
      >
        {problems?.data
          ?.filter((p: any) => {
            return p.title.toLowerCase().includes(searchValue.toLowerCase());
          })
          .map((p: IProblem) => (
            <tr key={p.id}>
              <td>{p.title}</td>
              <td>{p.locale}</td>
              <td>{p.parent ? p.parent.title : "-"}</td>
              <td>{p.product?.name}</td>
              <td>{p.repairDuration}</td>
              <td>{p.priority}</td>
              <td>{p.price}</td>
              <td>
                <ActionIcon onClick={() => setSelectedProblemId(p.id)}>
                  <label htmlFor="update-problem" className="cursor-pointer">
                    <HiPencil className="text-2xl" />
                  </label>
                </ActionIcon>
                <ActionIcon onClick={() => deleteHandler(p.id)}>
                  <HiTrash className="text-2xl text-red-500" />
                </ActionIcon>
              </td>
            </tr>
          ))}
      </Table>

      <Drawer title="Create Item" html="create-problem" position="right">
        <form onSubmit={createFormik.handleSubmit} className="space-y-5">
          <Input
            label="Title"
            name="title"
            onChange={createFormik.handleChange}
            value={createFormik.values.title}
            error={createFormik.errors.title}
          />

          <TextArea
            label="Description"
            name="description"
            onChange={createFormik.handleChange}
            value={createFormik.values.description}
            error={createFormik.errors.description}
          />

          <div className="grid grid-cols-2 gap-10">
            <Input
              type="number"
              label="Price"
              name="price"
              min="0"
              onChange={createFormik.handleChange}
              value={createFormik.values.price}
              error={createFormik.errors.price}
            />
            {/* 
            <Select
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

            <Input
              type="number"
              label="Priority"
              name="priority"
              min="0"
              onChange={createFormik.handleChange}
              value={createFormik.values.priority}
              error={createFormik.errors.priority}
            />

            <Input
              type="number"
              label="Repair Duration (min)"
              name="repairDuration"
              min="1"
              onChange={createFormik.handleChange}
              value={createFormik.values.repairDuration}
              error={createFormik.errors.repairDuration}
            />
          </div>

          <Select
            onChange={createFormik.handleChange}
            error={createFormik.errors.productId}
            label="Product"
            name="productId"
          >
            <option value="">select product</option>
            {products?.data?.map((product: any, index: any) => (
              <option key={index} value={product.id}>
                {product.name}
              </option>
            ))}
          </Select>

          <Select
            label="Parent Problem"
            name="parentId"
            onChange={createFormik.handleChange}
            error={createFormik.errors.parentId}
          >
            <option value="">don't select if this problem is a parent</option>
            {problems?.data?.map((p: any, index: any) => (
              <option key={index} value={p.id}>
                {p.title}
              </option>
            ))}
          </Select>

          <div className="flex items-end">
            <Input
              type="file"
              label="Icon"
              name="iconUrl"
              onChange={(e: any) => setImage(e.target.files[0])}
              error={createFormik.errors.iconUrl}
              className="w-5/6 file:bg-transparent file:border-0 file:text-white file:mt-2"
            />
            <Button
              type="button"
              onClick={handleImageUpload}
              loading={uploadLoading}
              disabled={image === ""}
            >
              upload
            </Button>
          </div>

          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={createProblem.isLoading}
          >
            Create
          </Button>
        </form>
      </Drawer>

      <Drawer title="Update Item" html="update-problem" position="right">
        <form onSubmit={updateFormik.handleSubmit} className="space-y-5">
          <Input
            label="Title"
            name="title"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.title}
            error={updateFormik.errors.title}
          />

          <TextArea
            label="Description"
            name="description"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.description}
            error={updateFormik.errors.description}
          />

          <div className="grid grid-cols-2 gap-10">
            <Input
              type="number"
              label="Price"
              name="price"
              min="0"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.price}
              error={updateFormik.errors.price}
            />
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

            <Input
              type="number"
              label="Priority"
              name="priority"
              min="0"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.priority}
              error={updateFormik.errors.priority}
            />

            <Input
              type="number"
              label="Repair Duration (min)"
              name="repairDuration"
              min="1"
              onChange={updateFormik.handleChange}
              value={updateFormik.values.repairDuration}
              error={updateFormik.errors.repairDuration}
            />
          </div>

          <Select
            onChange={updateFormik.handleChange}
            error={updateFormik.errors.productId}
            label="Product"
            name="productId"
          >
            {products?.data?.map((product: any, index: any) => (
              <option key={index} value={product.id}>
                {product.name}
              </option>
            ))}
          </Select>

          {/* <Select
            label="Parent Problem"
            name="parentId"
            onChange={updateFormik.handleChange}
            error={updateFormik.errors.parentId}
          >
            <option value="">don't select if this problem is a parent</option>
            {problems?.data?.map((p, index) => (
              <option key={index} value={p.id}>
                {p.title}
              </option>
            ))}
          </Select> */}

          {/* <div className="flex items-end">
            <Input
              type="file"
              label="Icon"
              name="iconUrl"
              onChange={(e: any) => setImage(e.target.files[0])}
              error={updateFormik.errors.iconUrl}
              className="w-5/6 file:bg-transparent file:border-0 file:text-white file:mt-2"
            />
            <Button
              type="button"
              onClick={handleImageUpload}
              loading={uploadLoading}
              disabled={image === ""}
            >
              upload
            </Button>
          </div> */}

          <br />
          <Button
            type="submit"
            className="btn-block font-semibold rtl:font-rtl-semibold"
            loading={updateProblem.isLoading}
          >
            Create
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Problems;
