import { useMutation } from "react-query";
import { post } from "../..";

const notifications = {
  send: (data: { phoneNumber: string; message: string; userId?: string; sendToAll?: boolean }) =>
    post("/notifications/send", data).then((res) => res.data),
};

export const useSendNotification = () => {
  return useMutation((data: { phoneNumber: string; message: string; userId?: string; sendToAll?: boolean }) =>
    notifications.send(data)
  );
};

