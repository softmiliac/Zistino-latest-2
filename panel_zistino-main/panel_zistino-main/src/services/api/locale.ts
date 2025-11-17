import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const locale = {
  getAll: () => post("/localizations/search", {}).then((res) => res.data),
  getResources: () =>
    get(`/localizations/resourcesets`).then((res) => res.data),
  create: (data: ILocale) => post("/localizations", data),
  delete: (id: string) =>
    remove(`/localizations/${id}`).then((res) => res.data),
  update: (id: string, data: ILocale) =>
    put(`/localizations/${id}`, data).then((res) => res.data),
};

export const useLocale = () => {
  return useQuery("localizations", locale.getAll);
};

export const useResourceSets = () => {
  return useQuery("resourceSets", locale.getResources);
};

export const useCreateLocale = () => {
  const queryClient = useQueryClient();

  return useMutation((data: ILocale) => locale.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("localizations");
    },
  });
};

export const useDeleteLocale = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => locale.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("localizations");
    },
  });
};

export const useUpdateLocale = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: ILocale) => locale.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("localizations");
    },
  });
};
