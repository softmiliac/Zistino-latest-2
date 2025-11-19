import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post } from "../..";

const weightRangeMinimums = {
  getRanges: () => get("/manager/weight-range-minimums").then((res) => res.data),
  setRanges: (ranges: Array<{ value: string; min: number }>) =>
    post("/manager/weight-range-minimums", { ranges }).then((res) => res.data),
};

export const useWeightRangeMinimums = () => {
  return useQuery(["weight-range-minimums"], () => weightRangeMinimums.getRanges(), {
    enabled: true,
  });
};

export const useSetWeightRangeMinimums = () => {
  const queryClient = useQueryClient();
  return useMutation(
    (ranges: Array<{ value: string; min: number }>) => weightRangeMinimums.setRanges(ranges),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("weight-range-minimums");
      },
    }
  );
};

