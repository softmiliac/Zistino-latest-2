import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const warranties = {
  getAll: () => post("/warranties/search", {}).then((res) => res.data),
  // getById: (id: string) => get(`/roles/${id}`).then(res => res.data),
  create: (data: IWarranty) => post("/warranties", data),
  delete: (id: string) =>
    remove(`/warranties/${id}`).then((res) => res.data),
  update: (id: string, data: any) =>
    put(`/warranties/${id}`, data).then((res) => res.data),
};

export const useWarranties = () => {
  return useQuery("warranties", warranties.getAll);
};

export const useDeleteWarranty = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => warranties.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("warranties");
    },
  });
};

export const useCreateWarranty = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IWarranty) => warranties.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("warranties");
    },
  });
};

export const useUpdateWarranty = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: IWarranty) => warranties.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("warranties");
    },
  });
};
