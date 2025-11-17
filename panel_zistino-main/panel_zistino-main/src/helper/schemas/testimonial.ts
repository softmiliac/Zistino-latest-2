import * as Yup from "yup";

export const TestimonialSchema = Yup.object().shape({
  name: Yup.string().required("name is required"),

  text: Yup.string().required("text is required"),

  rate: Yup.number().min(0).max(5).required("rate is required"),

  imageUrl: Yup.string().required("imageUrl is required"),

  locale: Yup.string().required("locale is required"),
});
