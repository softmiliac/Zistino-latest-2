import { useQuery } from "react-query";
import { post } from "../..";

const weightShortfalls = {
  search: (data: {
    pageNumber?: number;
    pageSize?: number;
    userId?: string;
    isDeducted?: boolean;
    dateFrom?: string;
    dateTo?: string;
  }) => post("/manager/weight-shortfalls", data).then((res) => res.data),
};

export const useWeightShortfalls = (
  page?: number,
  pageSize?: number,
  userId?: string,
  isDeducted?: boolean,
  dateFrom?: string,
  dateTo?: string
) => {
  return useQuery(
    ["weight-shortfalls", page, pageSize, userId, isDeducted, dateFrom, dateTo],
    () =>
      weightShortfalls.search({
        pageNumber: page,
        pageSize: pageSize,
        userId: userId,
        isDeducted: isDeducted,
        dateFrom: dateFrom,
        dateTo: dateTo,
      }),
    {
      enabled: true,
    }
  );
};

