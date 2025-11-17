import { useQuery } from "react-query";
import { post, get } from "../../";

const orders = {
  getAll: (page?: number, size?: number, keyword?: string) =>
      post("/orders/searchsp", {
      pageNumber: page,
      pageSize: size,
      keyword,
      status: -1,
    }).then((res) => res.data),
  get: (id?: string) =>
    id ? get(`/orders/${id}`).then((res) => res.data) : {},
};

export const useOrders = (page?: number, size?: number, keyword?: string) => {
  return useQuery(["orders", page, size, keyword], () =>
    orders.getAll(page, size, keyword)
  );
};

export const useOrdersGet = (id?: string) => {
  return useQuery(
    ["orders-get", id],
    () => orders.get(id),
    {
      enabled: !!id, // Only run query when id is provided
    }
  );
};
