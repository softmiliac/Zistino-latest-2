import Swal, { SweetAlertOptions } from "sweetalert2";

import "animate.css";
import "../../assets/styles/alert.css";

interface PropsSimple {
  title: string;
}
type TSimpleAlert = ({ title }: PropsSimple) => void;

interface PropsAdvance {
  title: string;
  titleConfirmed?: string;
  titleDenied?: string;
  titleDismissed?: string;
  isConfirmedMethod?: () => void;
  isDeniedMethod?: () => void;
  isDismissedMethod?: () => void;
}
type TAdvanceAlert = ({
  title,
  titleConfirmed,
  titleDenied,
  titleDismissed,
  isConfirmedMethod,
  isDeniedMethod,
  isDismissedMethod,
}: PropsAdvance) => void;

const defaultAlert: SweetAlertOptions<any, any> = {
  toast: true,
  position: "bottom-start",
  showConfirmButton: false,
  timer: 1500,
  iconColor: "white",
  showClass: {
    popup: "animate__animated animate__fadeInLeft",
  },
  hideClass: {
    popup: "animate__animated animate__fadeOutLeft",
  },
  timerProgressBar: true,
  customClass: {
    popup: "colored-toast",
  },
};

export const infoAlert: TSimpleAlert = ({ title }) => {
  Swal.fire({
    icon: "info",
    title: title,
    ...defaultAlert,
  });
};

export const infoAlertConfirm: TAdvanceAlert = ({
  title,
  titleConfirmed,
  titleDenied,
  titleDismissed,
  isConfirmedMethod,
  isDeniedMethod,
  isDismissedMethod,
}) => {
  Swal.fire({
    ...defaultAlert,
    icon: "question",
    title: title,
    showClass: {
      popup: "animate__animated animate__fadeInLeft",
    },
    timer: undefined,
    showConfirmButton: titleConfirmed ? true : false,
    showDenyButton: titleDenied ? true : false,
    showCancelButton: titleDismissed ? true : false,
    confirmButtonText: titleConfirmed,
    denyButtonText: titleDenied,
    cancelButtonText: titleDismissed,
  }).then(({ isConfirmed, isDenied, isDismissed }) => {
    if (isConfirmed)
      if (isConfirmedMethod) isConfirmedMethod();
      else if (isDenied)
        if (isDeniedMethod) isDeniedMethod();
        else if (isDismissed) if (isDismissedMethod) isDismissedMethod();
  });
};

export const errorAlert: TSimpleAlert = ({ title }) => {
  Swal.fire({
    icon: "error",
    title: title,
    ...defaultAlert,
  });
};

export const successAlert: TSimpleAlert = ({ title }) => {
  Swal.fire({
    icon: "success",
    title: title,
    ...defaultAlert,
  });
};

export const warningAlert: TSimpleAlert = ({ title }) => {
  Swal.fire({
    title: title,
    icon: "warning",
    ...defaultAlert,
  });
};
