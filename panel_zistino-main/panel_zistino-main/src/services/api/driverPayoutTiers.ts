import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post } from "../..";

const driverPayoutTiers = {
  get: () => get("/manager/driver-payout-tiers").then((res) => res.data),
  set: (tiers: Array<{ min: number; max: number | null; rate: number }>) =>
    post("/manager/driver-payout-tiers", { tiers }).then((res) => res.data),
};

export const useDriverPayoutTiers = () => {
  return useQuery(["driver-payout-tiers"], () => driverPayoutTiers.get(), {
    enabled: true,
  });
};

export const useSetDriverPayoutTiers = () => {
  const queryClient = useQueryClient();
  return useMutation(
    (tiers: Array<{ min: number; max: number | null; rate: number }>) =>
      driverPayoutTiers.set(tiers),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("driver-payout-tiers");
      },
    }
  );
};

