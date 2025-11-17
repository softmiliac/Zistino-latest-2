import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const driverdelivery = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/driverdelivery/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
    }).then((res) => res.data),
  getAllSP: (
    page?: number,
    size?: number,
    keyword?: string,
    searchValueTag?: number
  ) =>
    post("/driverdelivery/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
      status: searchValueTag,
    }).then((res) => res.data),
  create: (data: IDriverDelivery) => post("/driverdelivery", data),
  createAll: (data: IDriverDelivery) =>
    post("/identity/register-with-phonecall", data),
  delete: (id: string) =>
    remove(`/driverdelivery/${id}`).then((res) => res.data),
  update: (id: string, data: IFaq) =>
    put(`/driverdelivery/${id}`, data).then((res) => res.data),
  getMyRequests: (
    page?: number,
    size?: number,
    keyword?: string,
    status?: number
  ) =>
    post("/driverdelivery/myrequests", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
      status: status,
    }).then((res) => res.data),
  getPrice: (id: string) =>
    get(`/manager/deliveries/${id}/price`).then((res) => res.data),
  centerConfirm: (id: string) =>
    post(`/deliveries/${id}/center-confirm`, {}).then((res) => res.data),
  createTelephoneRequest: (data: any) =>
    post("/manager/telephone-requests", data).then((res) => res.data),
};

export const useDriverDelivery = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(["driverdelivery", page, keyword], () =>
    driverdelivery.getAll(page, size, keyword)
  );
};
export const useDriverDeliverySP = (
  page?: number,
  size?: number,
  keyword?: string,
  searchValueTag?: number
) => {
  return useQuery(
    ["driverdelivery-sp", page, size, keyword, searchValueTag],
    () => driverdelivery.getAllSP(page, size, keyword, searchValueTag)
  );
};

export const useDeleteDriverDelivery = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => driverdelivery.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("driverdelivery");
    },
  });
};

export const useCreateDriverDelivery = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IDriverDelivery) => driverdelivery.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("driverdelivery");
    },
  });
};

export const useCreateAllDriverDelivery = () => {
  const queryClient = useQueryClient();

  return useMutation(
    (data: IDriverDelivery) => driverdelivery.createAll(data),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("driverdelivery");
      },
    }
  );
};

export const useUpdateDriverDelivery = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => driverdelivery.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("driverdelivery");
    },
  });
};

export const useDriverMyRequests = (
  page?: number,
  size?: number,
  keyword?: string,
  status?: number
) => {
  return useQuery(
    ["driver-myrequests", page, size, keyword, status],
    () => driverdelivery.getMyRequests(page, size, keyword, status),
    {
      enabled: true, // Always enabled for drivers
    }
  );
};

export const useDeliveryPrice = (id: string) => {
  return useQuery(
    ["delivery-price", id],
    () => driverdelivery.getPrice(id),
    {
      enabled: !!id,
    }
  );
};

export const useCenterConfirm = () => {
  const queryClient = useQueryClient();
  return useMutation(
    (id: string) => driverdelivery.centerConfirm(id),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("driverdelivery");
        queryClient.invalidateQueries("driver-myrequests");
      },
    }
  );
};

export const useCreateTelephoneRequest = () => {
  const queryClient = useQueryClient();
  return useMutation(
    (data: any) => driverdelivery.createTelephoneRequest(data),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("driverdelivery");
        queryClient.invalidateQueries("orders");
      },
    }
  );
};
