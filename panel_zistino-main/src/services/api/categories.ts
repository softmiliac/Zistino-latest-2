import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const categories = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/categories/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  getAllByType: (
    page?: number,
    size?: number,
    keyword?: string,
    type?: number
  ) =>
    post("/categories/search", {
      advancedSearch: {
        fields: ["type"],
        keyword: `${type}`,
      },
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  getById: (id?: number) =>
    id ? get(`/categories/${id}`).then((res) => res.data) : {},
  getByType: (type: number) =>
    get(`/categories/by-type/${type}`).then((res) => res.data),
  getClientByType: (type: number) =>
    get(`/categories/client/by-type/${type}`).then((res) => res.data),
  create: (data: ICategory) => post("/categories/", data),
  delete: (id: string) =>
    remove(`/categories/${id}`).then((res) => res.data),
  update: (id: string, data: ICategory) =>
    put(`/categories/${id}`, data).then((res) => res.data),
};

export const useCategories = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(["categories", page, size, keyword], () =>
    categories.getAll(page, size, keyword)
  );
};

export const useCategoriesGet = (id?: number) => {
  return useQuery(["category", id], () => categories.getById(id));
};

export const useCategoriesByType = (
  page?: number,
  size?: number,
  keyword?: string,
  type?: number
) => {
  return useQuery(
    ["categories", page, size, keyword, type],
    () => categories.getAllByType(page, size, keyword, type),
    {
      enabled: type !== undefined && type !== null, // Only run if type is provided
      keepPreviousData: true,
      refetchOnMount: true,
      refetchOnWindowFocus: false,
    }
  );
};

export const useCategoryByType = (type: number) => {
  return useQuery(["categories-type", type], () => categories.getByType(type));
};

export const useCategoryClientByType = (type: number) => {
  return useQuery(["categories-client-type", type], () => categories.getClientByType(type));
};

export const useDeleteCategory = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => categories.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("categories");
    },
  });
};

export const useCreateCategory = () => {
  const queryClient = useQueryClient();

  return useMutation((data: ICategory) => categories.create(data), {
    onSuccess: () => {
      // Invalidate all category-related queries
      queryClient.invalidateQueries("categories");
      queryClient.invalidateQueries("categories-type");
      queryClient.invalidateQueries("categoriesByType"); // Also invalidate this query key
    },
  });
};

export const useUpdateCategory = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => categories.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("categories");
      queryClient.invalidateQueries("category");
    },
  });
};
