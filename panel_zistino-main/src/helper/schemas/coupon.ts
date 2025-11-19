import * as Yup from "yup";

export const CouponSchema = Yup.object().shape({
  key: Yup.string().required("key is required"),

  startDateTime: Yup.string().required("startDateTime is required"),

  endDateTime: Yup.string().required("endDateTime is required"),

  maxUseCount: Yup.number().required("maxUseCount is required"),

  percent: Yup.number().required("percent is required"),

  price: Yup.number().required("price is required"),

  userId: Yup.string().required("userId is required"),

  roleId: Yup.string().required("roleId is required"),

  type: Yup.number().required("type is required"),

  limitationType: Yup.number().required("limitationType is required"),

  userLimitationType: Yup.number().required("userLimitationType is required"),
});
