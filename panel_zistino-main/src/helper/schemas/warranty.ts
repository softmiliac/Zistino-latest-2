import * as Yup from "yup";

export const WarrantySchema = Yup.object().shape({
  name: Yup.string().required("name is required"),

  description: Yup.string().required("description is required"),

  imageUrl: Yup.string().required("image is required"),

  locale: Yup.string().required("locale is required"),
});
