import * as Yup from "yup";

export const RoleSchema = Yup.object().shape({
  name: Yup.string()
    .min(3, "Too Short!")
    .max(50, "Too Long!")
    .required("name is required"),

  description: Yup.string()
    .min(5, "Too Short!")
    .max(50, "Too Long!")
    .required("description is required"),
});
