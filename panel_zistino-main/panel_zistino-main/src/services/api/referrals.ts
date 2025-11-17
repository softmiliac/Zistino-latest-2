import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const referrals = {
  search: (page?: number, size?: number, keyword?: string, status?: string, fromDate?: string, toDate?: string) =>
    post("/referrals/search", {
      pageNumber: page || 1,
      pageSize: size || 10,
      keyword: keyword || "",
      status: status || "",
    }).then((res) => res.data),
};

export const useReferrals = (
  page?: number,
  size?: number,
  keyword?: string,
  status?: string,
  fromDate?: string,
  toDate?: string
) => {
  return useQuery(
    ["referrals", page, size, keyword, status, fromDate, toDate],
    () => referrals.search(page, size, keyword, status, fromDate, toDate),
    {
      keepPreviousData: true,
    }
  );
};

