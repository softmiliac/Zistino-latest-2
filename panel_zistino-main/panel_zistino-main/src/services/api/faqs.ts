import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const faqs = {
  getAll: () => post("/faqs/search", {}).then((res) => res.data),
  // getById: (id: string) => get(`/roles/${id}`).then(res => res.data),
  create: (data: any) => post("/faqs/", data).then((res) => res.data),
  delete: (id: string) => remove(`/faqs/${id}`).then((res) => res.data),
  get: (id?: string) =>
    id ? get(`/faqs/${id}`).then((res) => res.data) : {},
  update: (id: string, data: any) =>
    put(`/faqs/${id}`, data).then((res) => res.data),
};

export const useFaqs = () => {
  return useQuery("faqs", faqs.getAll);
};

export const useFaqsGet = (id?: string) => {
  return useQuery(["faqs-get", id], () => faqs.get(id));
};

export const useCreateFaq = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => faqs.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("faqs");
    },
  });
};

export const useDeleteFaq = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => faqs.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("faqs");
    },
  });
};

export const useUpdateFaq = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => faqs.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("faqs");
    },
  });
};
