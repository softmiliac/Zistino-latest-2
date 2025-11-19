import * as Yup from "yup";

export const LocaleSchema = Yup.object().shape({
  resourceSet: Yup.string().required("resource is required"),

  locale: Yup.string().required("locale is required"),

  key: Yup.string().required("key is required"),

  text: Yup.string().required("text is required"),
});
