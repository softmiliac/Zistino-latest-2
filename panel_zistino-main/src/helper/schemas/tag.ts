import * as Yup from "yup";

export const tagSchema = Yup.object().shape({
  text: Yup.string().required("text is required"),

  locale: Yup.string().required("locale is required"),

  //   description: Yup.string()
  //     .min(5, "Too Short!")
  //     .max(200, "Too Long!")
  //     .required("description is required"),
});
