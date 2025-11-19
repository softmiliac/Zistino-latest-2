import * as Yup from "yup";

export const ZoneSchema = Yup.object().shape({
  zone: Yup.string().max(30, "Too Long!").required("zone is required"),

  description: Yup.string()
    .min(3, "Too Short!")
    .max(120, "Too Long!")
    .required("description is required"),
});
