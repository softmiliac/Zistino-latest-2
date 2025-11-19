import { useEffect } from "react";

import NProgress from "nprogress";

import "../../assets/styles/nprogress.css";

export const Loading = () => {
  // config
  NProgress.configure({ showSpinner: false });

  useEffect(() => {
    NProgress.start();

    return () => {
      NProgress.done();
    };
  });
  return <></>;
};
