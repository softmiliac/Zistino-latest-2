import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const configurations = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/configurations/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  getById: (id: string) =>
    id ? get(`/configurations/${id}`).then((res) => res.data) : {},
  create: (data: any) => post("/configurations", data),
  delete: (id: string) =>
    remove(`/configurations/${id}`).then((res) => res.data),
  update: (id: string, data: any) =>
    put(`/configurations/${id}`, data).then((res) => res.data),
};

export const useConfigurations = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(
    ["configurations", page, size, keyword],
    () => configurations.getAll(page, size, keyword),
    {
      keepPreviousData: true,
    }
  );
};

export const useConfigurationById = (id: string) =>
  useQuery(["configuration", id], async () => await configurations.getById(id));

export const useCreateConfiguration = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => configurations.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("configurations");
    },
  });
};

export const useDeleteConfiguration = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => configurations.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("configurations");
    },
  });
};

export const useUpdateConfiguration = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => configurations.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("configurations");
    },
  });
};
