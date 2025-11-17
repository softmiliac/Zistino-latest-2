import * as Yup from "yup";

export const UserSchema = Yup.object().shape({
  firstName: Yup.string()
    .min(3, "Too Short!")
    .max(20, "Too Long!")
    .required("firstName is required"),

  lastName: Yup.string()
    .min(3, "Too Short!")
    .max(30, "Too Long!")
    .required("lastName is required"),

  email: Yup.string().email("invalid email").required("email is required"),

  userName: Yup.string().min(3, "Too Short!").required("userName is required"),

  password: Yup.string().min(8, "Too Short!").required("password is required"),

  confirmPassword: Yup.string().oneOf(
    [Yup.ref("password"), null],
    "passwords must match"
  ),
});

export const DriverSchema = Yup.object().shape({
  userId: Yup.string().required("driverId is required"),
  zoneId: Yup.string().required("zoneId is required"),
});
