import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const transactionwallet = {
  getAll: (
    page?: number,
    size?: number,
    keyword?: string,
    filteredUserId?: string
  ) =>
    post(
      "/transactionwallet/search",
      filteredUserId
        ? {
            advancedSearch: {
              fields: ["userid"],
              keyword: filteredUserId,
            },
            pageNumber: page,
            pageSize: size,
            keyword: keyword,
          }
        : {
            pageNumber: page,
            pageSize: size,
            keyword: keyword,
          }
    ).then((res) => res.data),
  create: (data: IWallet) => post("/transactionwallet", data),
  delete: (id: string) =>
    remove(`/transactionwallet/${id}`).then((res) => res.data),
  update: (id: string, data: IFaq) =>
    put(`/transactionwallet/${id}`, data).then((res) => res.data),
  getCustomerCredits: (
    page?: number,
    size?: number,
    keyword?: string,
    userId?: string
  ) =>
    post("/payments/manager/customer-credits", {
      pageNumber: page,
      pageSize: size,
      keyword,
      userId,
    }).then((res) => res.data),
  getDriverCredits: (
    page?: number,
    size?: number,
    keyword?: string,
    driverId?: string,
    dateFrom?: string,
    dateTo?: string
  ) =>
    post("/payments/manager/driver-credits", {
      pageNumber: page,
      pageSize: size,
      keyword,
      driverId,
      dateFrom,
      dateTo,
    }).then((res) => res.data),
  recordManualPayment: (data: {
    userId: string;
    amount: number;
    transactionType: "credit" | "debit";
    description?: string;
  }) =>
    post("/payments/manager/payments/record", data).then((res) => res.data),
};

export const useWallet = (
  page?: number,
  size?: number,
  keyword?: string,
  filteredUserId?: string
) => {
  return useQuery(
    ["transactionwallet", size, page, keyword, filteredUserId],
    () => transactionwallet.getAll(page, size, keyword, filteredUserId)
  );
};

export const useDeleteWallet = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => transactionwallet.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("transactionwallet");
    },
  });
};

export const useCreateWallet = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IWallet) => transactionwallet.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("transactionwallet");
    },
  });
};

export const useUpdateWallet = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => transactionwallet.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("transactionwallet");
    },
  });
};

export const useCustomerCredits = (
  page?: number,
  size?: number,
  keyword?: string,
  userId?: string
) => {
  return useQuery(
    ["customer-credits", page, size, keyword, userId],
    () => transactionwallet.getCustomerCredits(page, size, keyword, userId),
    {
      enabled: true,
    }
  );
};

export const useDriverCredits = (
  page?: number,
  size?: number,
  keyword?: string,
  driverId?: string,
  dateFrom?: string,
  dateTo?: string
) => {
  return useQuery(
    ["driver-credits", page, size, keyword, driverId, dateFrom, dateTo],
    () =>
      transactionwallet.getDriverCredits(
        page,
        size,
        keyword,
        driverId,
        dateFrom,
        dateTo
      ),
    {
      enabled: true,
    }
  );
};

export const useRecordManualPayment = () => {
  const queryClient = useQueryClient();
  return useMutation(
    (data: {
      userId: string;
      amount: number;
      transactionType: "credit" | "debit";
      description?: string;
    }) => transactionwallet.recordManualPayment(data),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("transactionwallet");
        queryClient.invalidateQueries("customer-credits");
        queryClient.invalidateQueries("driver-credits");
      },
    }
  );
};
