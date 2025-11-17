import { useQuery, useMutation } from "react-query";
import { post, get } from "../..";

const driverRoutes = {
  getRoutes: (driverId: string, date?: string) => {
    const data = date ? { date } : {};
    return post(`/manager/drivers/${driverId}/routes`, data).then((res) => res.data);
  },
  getAvailableDates: (driverId: string) =>
    get(`/manager/drivers/${driverId}/available-dates`).then((res) => res.data),
};

export const useDriverRoutes = (driverId: string, date?: string) => {
  return useQuery(
    ["driver-routes", driverId, date],
    () => driverRoutes.getRoutes(driverId, date),
    {
      enabled: !!driverId && !!date,
    }
  );
};

export const useDriverAvailableDates = (driverId: string) => {
  return useQuery(
    ["driver-available-dates", driverId],
    () => driverRoutes.getAvailableDates(driverId),
    {
      enabled: !!driverId,
    }
  );
};

