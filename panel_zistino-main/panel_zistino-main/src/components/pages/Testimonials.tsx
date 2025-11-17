import { FC, useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { HiPencil, HiPlusSm, HiTrash } from "react-icons/hi";
import { toast } from "react-toastify";
import { Avatar } from "antd";
import { ColumnsType } from "antd/lib/table";
import { useFormik } from "formik";

import {
  ActionIcon,
  Button,
  Drawer,
  Input,
  Select,
  TextArea,
  post,
  APP_DEFAULT_LOCALE,
  APP_LOCALE_LIST,
  useCreateTestimonial,
  useDeleteTestimonial,
  useTestimonial,
  useUpdateTestimonial,
  TestimonialSchema,
  errorAlert,
  successAlert,
} from "../../";

const Testimonials: FC = () => {
  const [searchValue, setSearchValue] = useState("");
  const [image, setImage] = useState<any>("");
  const [uploadedImage, setUploadedImage] = useState<any>("");
  const [uploadLoading, setUploadLoading] = useState<boolean>(false);
  const [selecteId, setSelecteId] = useState<any>("");

  const { t } = useTranslation();

  const { data: testimonials, isLoading, isFetching } = useTestimonial();
  const deleteTestimonial = useDeleteTestimonial();
  const createTestimonial = useCreateTestimonial();
  const updateTestimonial = useUpdateTestimonial(selecteId);

  const selectedTestimonial = testimonials?.data?.filter(
    (t: any) => t.id === selecteId
  )[0];

  useEffect(() => {
    createFormik.setFieldValue("imageUrl", uploadedImage);
  }, [uploadedImage]);

  const createFormik = useFormik<ITestimonial>({
    initialValues: {
      name: "",
      rate: 0,
      text: "",
      imageUrl: "",
      locale: APP_DEFAULT_LOCALE,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: TestimonialSchema,
    onSubmit: (values) => {
      createTestimonial
        .mutateAsync(values)
        .then(() => {
          document.getElementById("create-testimonial")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  const updateFormik = useFormik<ITestimonial>({
    initialValues: {
      name: selectedTestimonial?.name,
      text: selectedTestimonial?.text,
      imageUrl: selectedTestimonial?.imageUrl,
      locale: selectedTestimonial?.locale,
      rate: selectedTestimonial?.rate,
    },
    validateOnBlur: false,
    validateOnChange: false,
    validationSchema: TestimonialSchema,
    enableReinitialize: true,
    onSubmit: (values) => {
      updateTestimonial
        .mutateAsync(values)
        .then(() => {
          document.getElementById("update-testimonial")?.click();
          createFormik.resetForm();
        })
        .catch((err) => {
          /*errorAlert({ title: err?.message })*/
        });
    },
  });

  if (isLoading) return <div>{t("loading")}</div>;

  const deleteHandler = (id: any) => {
    if (!window.confirm("Are you sure you want to delete this item ?")) return;
    toast.promise(deleteTestimonial.mutateAsync(id), {
      pending: t("please_wait"),
      success: t("deleted_successfully"),
      error: t("something_went_wrong"),
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
    { title: t("id"), dataIndex: "id" },
    { title: t("locale"), dataIndex: "locale" },
    { title: t("rate"), dataIndex: "rate" },
    { title: t("name"), dataIndex: "name" },
    { title: t("content"), dataIndex: "text" },
    {
      title: t("image"),
      dataIndex: "imageUrl",
      render(value) {
        return <Avatar src={value} shape="square" />;
      },
    },
    {
      title: t("actions"),
      render(record) {
        return (
          <>
            <ActionIcon onClick={() => setSelecteId(record.id)}>
              <label htmlFor="update-testimonial" className="cursor-pointer">
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
          {t("testimonials")}
        </h2>
        <div className="flex justify-between md:justify-end items-center space-x-4 rtl:space-x-reverse">
          <Input
            placeholder={t("search")}
            className="md:w-[280px] w-full"
            onChange={(e) => setSearchValue(e.target.value)}
          />
          <Button>
            <label
              htmlFor="create-testimonial"
              className="w-full h-full flex items-center cursor-pointer"
            >
              <HiPlusSm className="text-2xl ltr:mr-1 rtl:ml-2" />
              {t("add")}
            </label>
          </Button>
        </div>
      </div>
      {/* <ProTable columns={columns} dataSource={testimonials?.data} /> */}
      {/* <Table
        items={[
          t("id"),
          t("locale"),
          t("rate"),
          t("name"),
          t("content"),
          t("image"),
          t("actions"),
        ]}
      >
        {testimonials?.data
          ?.filter((t) => {
            return t.name.toLowerCase().includes(searchValue.toLowerCase());
          })
          .map((t: ITestimonial) => (
            <tr key={t.id}>
              <td>{t.id}</td>
              <td>{t.locale}</td>
              <td>{t.rate}</td>
              <td>{t.name}</td>
              <td className="max-w-[150px] truncate">{t.text}</td>
              <td>
                <img
                  src={APP_BASE_URL + t.imageUrl}
                  className="w-10 h-10 rounded-full object-cover"
                  alt=" "
                />
              </td>
              <td>
                <ActionIcon onClick={() => setSelecteId(t.id)}>
                  <label
                    htmlFor="update-testimonial"
                    className="cursor-pointer"
                  >
                    <HiPencil className="text-2xl" />
                  </label>
                </ActionIcon>
                <ActionIcon onClick={() => deleteHandler(t.id)}>
                  <HiTrash className="text-2xl text-red-500" />
                </ActionIcon>
              </td>
            </tr>
          ))}
      </Table> */}
      <Drawer
        title={t("create_testimonial")}
        html="create-testimonial"
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
          <TextArea
            label={t("text")}
            name="text"
            onChange={createFormik.handleChange}
            value={createFormik.values.text}
            error={createFormik.errors.text}
          />

          <Input
            type="number"
            min="0"
            max="5"
            label={t("rate")}
            name="rate"
            onChange={createFormik.handleChange}
            value={createFormik.values.rate}
            error={createFormik.errors.rate}
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

          <div className="flex items-end">
            <Input
              type="file"
              label={t("image")}
              name="imageUrl"
              onChange={(e: any) => setImage(e.target.files[0])}
              error={createFormik.errors.imageUrl}
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
            loading={createTestimonial.isLoading}
          >
            {t("create_test")}
          </Button>
        </form>
      </Drawer>
      <Drawer
        title="Update Testimonial"
        html="update-testimonial"
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
          <TextArea
            label={t("text")}
            name="text"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.text}
            error={updateFormik.errors.text}
          />

          <Input
            type="number"
            min="0"
            max="5"
            label={t("rate")}
            name="rate"
            onChange={updateFormik.handleChange}
            value={updateFormik.values.rate}
            error={updateFormik.errors.rate}
          />

          {/* <Select
            label={t("locale")}
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
            loading={updateTestimonial.isLoading}
          >
            {t("create")}
          </Button>
        </form>
      </Drawer>
    </>
  );
};

export default Testimonials;
