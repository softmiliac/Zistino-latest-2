import * as Yup from "yup";

export const ProblemSchema = Yup.object().shape({
  title: Yup.string().required("title is required"),

  description: Yup.string().required("description is required"),

  repairDuration: Yup.number().required("repairDuration is required"),

  price: Yup.number().required("price is required"),

  productId: Yup.string().required("product is required"),

  priority: Yup.number().required("priority is required"),

  locale: Yup.string().required("locale is required"),
});
