import { useQuery } from "react-query";
import { post } from "../../";

const disapprovals = {
  search: (page?: number, size?: number, type?: string, dateFrom?: string, dateTo?: string) =>
    post("/manager/disapprovals", {
      pageNumber: page || 1,
      pageSize: size || 10,
      type: type || "all",
      dateFrom: dateFrom || "",
      dateTo: dateTo || "",
    }).then((res) => res.data),
};

export const useDisapprovals = (
  page?: number,
  size?: number,
  type?: string,
  dateFrom?: string,
  dateTo?: string
) => {
  return useQuery(
    ["disapprovals", page, size, type, dateFrom, dateTo],
    () => disapprovals.search(page, size, type, dateFrom, dateTo),
    {
      keepPreviousData: true,
    }
  );
};

