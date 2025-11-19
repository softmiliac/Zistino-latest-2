import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const mapZone = {
  getAllSearch: (page?: number, size?: number, keyword?: string) =>
    post("/mapzone/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  getAll: () => post("/mapzone/search", {}).then((res) => res.data),
  create: (data: IZone) => post("/mapzone", data),
  createUserZone: (data: { userId: string; zoneId: number; priority?: number }) => post("/mapzone/createuserinzone", data),
  userInZone: (id: string) =>
    id ? post(`/mapzone/userinzone?userid=${id}`, {}) : {},
  delete: (id: string) => remove(`/mapzone/${id}`).then((res) => res.data),
  delUserInZone: (id: number) =>
    remove(`/mapzone/userinzone/${id}`).then((res) => res.data),
  update: (id: string, data: any) =>
    put(`/mapzone/${id}`, data).then((res) => res.data),
};

export const useZone = (page?: number, size?: number, keyword?: string) => {
  return useQuery(["mapzone", page, size, keyword], () =>
    mapZone.getAllSearch(page, size, keyword)
  );
};

export const useZoneAll = () => {
  return useQuery(["mapzone"], () => mapZone.getAll());
};

export const useGetUserInZone = (id: string) => {
  return useQuery(["user-in-zone", id], () => mapZone.userInZone(id));
};

export const useDeleteZone = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => mapZone.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("mapzone");
    },
  });
};

export const useDeleteZoneInZone = () => {
  const queryClient = useQueryClient();

  return useMutation((id: number) => mapZone.delUserInZone(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("user-in-zone");
    },
  });
};

export const useCreateZone = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IZone) => mapZone.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("mapzone");
    },
  });
};

export const useCreateUserInZone = () => {
  const queryClient = useQueryClient();

  return useMutation((data: { userId: string; zoneId: number; priority?: number }) => mapZone.createUserZone(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("users-drivers");
      queryClient.invalidateQueries("user-in-zone");
      queryClient.invalidateQueries("mapzone");
    },
  });
};

export const useUpdateZone = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: IZone) => mapZone.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("mapzone");
    },
  });
};
