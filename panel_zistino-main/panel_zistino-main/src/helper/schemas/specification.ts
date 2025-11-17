import * as Yup from "yup";

export const SpecificationSchema = Yup.object().shape({
  category: Yup.string().required("category is required"),
  content: Yup.string().required("content is required"),
  locale: Yup.string().required("locale is required"),
});
