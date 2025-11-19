import { warningAlert } from "./massage";

export const checkImage = (file: any) => {
  const fileType = ["image/png", "image/jpeg"];
  if (file.size > 500000) {
    warningAlert({ title: "سایز فایل نمیتواند از 500KB بیشتر باشد." });
    return false;
  }
  if (!fileType.includes(file.type)) {
    warningAlert({ title: "نوع فایل میبایست تصویر باشد (jpg,jpeg,png)." });
    return false;
  }
  return true;
};
