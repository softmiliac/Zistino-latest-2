import * as Yup from "yup";

export const brandSchema = Yup.object().shape({
  name: Yup.string().required("name is required"),

  description: Yup.string().required("description is required"),

  imageUrl: Yup.string().required("imageUrl is required"),

  locale: Yup.string().required("locale is required"),
});
