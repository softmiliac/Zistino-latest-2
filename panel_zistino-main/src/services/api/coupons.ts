import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const coupons = {
  getAll: (page?: number, size?: number) =>
    post("/coupons/search", {
      pageNumber: page,
      pageSize: size,
    }).then((res) => res.data),
  create: (data: ICoupon) => post("/coupons", data),
  get: (id?: number) =>
    id ? get(`/coupons/${id}`).then((res) => res.data) : {},
  delete: (id: string) => remove(`/coupons/${id}`).then((res) => res.data),
  update: (id: string, data: ICoupon) =>
    put(`/coupons/${id}`, data).then((res) => res.data),
  getAllUses: (page?: number, size?: number, keyword?: string) =>
    post("/couponuses/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
};

export const useCoupons = (page?: number, size?: number) => {
  return useQuery(["coupons", page], () => coupons.getAll(page, size));
};
export const useCouponsGet = (id?: number) => {
  return useQuery(["coupons-get", id], () => coupons.get(id));
};

export const useCouponUses = (page?: number, size?: number) => {
  return useQuery(["couponsuses", page], () => coupons.getAllUses(page, size));
};

export const useDeleteCoupon = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => coupons.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("coupons");
    },
  });
};

export const useCreateCoupon = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => coupons.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("coupons");
    },
  });
};

export const useUpdateCoupon = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => coupons.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("coupons");
    },
  });
};
