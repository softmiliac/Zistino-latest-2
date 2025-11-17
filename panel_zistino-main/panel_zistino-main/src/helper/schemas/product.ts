import * as Yup from "yup";

export const ProductSchema = Yup.object().shape({
  name: Yup.string().required("name is required"),
  description: Yup.string().required("description is required"),
  rate: Yup.number().required("rate is required"),
  category: Yup.string().required("category is required"),
  // size: Yup.string().required("size is required"),
  isMaster: Yup.boolean().required("isMaster is required"),
  colorsList: Yup.string().required("colors is required"),
  masterColor: Yup.string().required("masterColor is required"),
  pricesList: Yup.string().required("price list is required"),
  masterPrice: Yup.number().required("price is required"),
  imagesList: Yup.string().required("image list is required"),
  masterImage: Yup.string().required("masterImage is required"),
  warranty: Yup.string().required("warranty is required"),
  specifications: Yup.string().required("specification is required"),
  tags: Yup.string().required("tags is required"),
  brandId: Yup.string().required("brandId is required"),
  locale: Yup.string().required("locale is required"),
});
