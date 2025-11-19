import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const products = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/products/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
      orderBy: ["name"],
    }).then((res) => res.data),
  getAllByCategoryType: (
    page?: number,
    size?: number,
    keyword?: string,
    categoryType?: number
  ) =>
    post("/products/client/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
      categoryType,
    }).then((res) => res.data),
  create: (data: IProduct) => post("/products/", data),
  delete: (id: string) => remove(`/products/${id}`).then((res) => res.data),
  get: (id?: string) =>
    id ? get(`/products/${id}`).then((res) => res.data) : {},
  update: (id: string, data: IFaq) =>
    put(`/products/${id}`, data).then((res) => res.data),
};

export const useProducts = (page?: number, size?: number, keyword?: string) => {
  return useQuery(["products", page, keyword], () =>
    products.getAll(page, size, keyword)
  );
};
export const useProductsGet = (id?: string) => {
  return useQuery(["products-get", id], () => products.get(id));
};

export const useProductsByCategoryType = (
  page?: number,
  size?: number,
  keyword?: string,
  categoryType?: number
) => {
  return useQuery(["products-categoryType", page, keyword, categoryType], () =>
    products.getAllByCategoryType(page, size, keyword, categoryType)
  );
};

export const useDeleteProduct = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => products.delete(id), {
    onSuccess: () => {
      // Invalidate all product-related queries
      queryClient.invalidateQueries("products");
      queryClient.invalidateQueries("products-categoryType");
      queryClient.invalidateQueries("products-get");
    },
  });
};

export const useCreateProduct = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IProduct) => products.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("products");
      queryClient.invalidateQueries("products-categoryType");
    },
  });
};

export const useUpdateProduct = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => products.update(id, data), {
    onSuccess: () => {
      // Invalidate all product-related queries
      queryClient.invalidateQueries("products");
      queryClient.invalidateQueries("products-categoryType");
      queryClient.invalidateQueries("products-get");
    },
  });
};
