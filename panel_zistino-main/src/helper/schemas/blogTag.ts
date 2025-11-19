import * as Yup from "yup";

export const BlogTagSchema = Yup.object().shape({
  title: Yup.string().required("title is required"),

  // slug: Yup.string().required("slug is required"),

  // content: Yup.string().required("content is required"),

  locale: Yup.string().required("locale is required"),
});
