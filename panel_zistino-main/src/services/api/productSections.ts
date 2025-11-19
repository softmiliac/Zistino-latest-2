import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const sections = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/productsections/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  // getById: (id: string) => get(`/roles/${id}`).then(res => res.data),
  create: (data: any) => post("/productsections/", data).then((res) => res.data),
  delete: (id: string) =>
    remove(`/productsections/${id}`).then((res) => res.data),
  get: (id?: string) =>
    id ? get(`/productsections/${id}`).then((res) => res.data) : {},
  update: (id: string, data: any) =>
    put(`/productsections/${id}`, data).then((res) => res.data),
};

export const useProductSections = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(["product-sections", page, keyword], () =>
    sections.getAll(page, size, keyword)
  );
};
export const useProductSectionsGet = (id?: string) => {
  return useQuery(["product-sections-get", id], () => sections.get(id));
};

export const useDeleteSection = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => sections.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("product-sections");
    },
  });
};

export const useCreateSection = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => sections.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("product-sections");
      queryClient.invalidateQueries("product-sections-get");
    },
  });
};

export const useUpdateSection = (id: any) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => sections.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("product-sections");
      queryClient.invalidateQueries("product-sections-get");
    },
  });
};
