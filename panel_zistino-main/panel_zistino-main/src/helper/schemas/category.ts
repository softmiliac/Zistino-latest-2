import * as Yup from "yup";

export const CategorySchema = Yup.object().shape({
  name: Yup.string().required("name is required"),

  description: Yup.string().required("description is required"),

  // imagePath: Yup.string().required("imageUrl is required"),

  type: Yup.number().required("type is required"),

  locale: Yup.string().required("locale is required"),
});
export const FaqCategorySchema = Yup.object().shape({
  name: Yup.string().required("name is required"),

  description: Yup.string().required("description is required"),

  // imagePath: Yup.string().required("imageUrl is required"),

  //   type: Yup.number().required("type is required"),

  locale: Yup.string().required("locale is required"),
});
