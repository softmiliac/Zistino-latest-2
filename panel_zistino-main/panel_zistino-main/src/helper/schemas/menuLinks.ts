import * as Yup from "yup";

export const MenuLinksSchema = Yup.object().shape({
  name: Yup.string().required("name is required"),

  linkUrl: Yup.string().required("linkUrl is required"),

  // imageUrl: Yup.string().required("imageUrl is required"),

  locale: Yup.string().required("locale is required"),
});
