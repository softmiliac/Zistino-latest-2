import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, remove } from "../../";

const roles = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/roles/search", {
      pageNumber: page || 1,
      pageSize: size || 100,
      keyword,
    }).then((res) => res.data),
  getAllSimple: (page?: number, size?: number) =>
    get(`/roles/all?pageNumber=${page || 1}&pageSize=${size || 100}`).then((res) => res.data),
  get: (id: string) => get(`/roles/${id}`).then((res) => res.data),
  create: (data: { id?: string; name: string; description?: string }) =>
    post("/roles", data).then((res) => res.data),
  delete: (id: string) => remove(`/roles/${id}`).then((res) => res.data),
  getCount: () => get("/roles/count").then((res) => res.data),
  getPermissions: () => get("/roles/permissionslist").then((res) => res.data),
};

export const useRoles = (page?: number, size?: number, keyword?: string) => {
  return useQuery(["roles", page, size, keyword], () =>
    roles.getAll(page, size, keyword)
  );
};

export const useRolesSimple = (page?: number, size?: number) => {
  return useQuery(["roles-simple", page, size], () =>
    roles.getAllSimple(page, size)
  );
};

export const useRole = (id: string) => {
  return useQuery(["role", id], () => roles.get(id), {
    enabled: !!id && id.length > 0,
  });
};

export const useCreateRole = () => {
  const queryClient = useQueryClient();

  return useMutation((data: { id?: string; name: string; description?: string }) => roles.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("roles");
      queryClient.invalidateQueries("roles-simple");
    },
  });
};

export const useDeleteRole = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => roles.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("roles");
      queryClient.invalidateQueries("roles-simple");
      queryClient.invalidateQueries("user-roles");
    },
  });
};

export const useRolesCount = () => {
  return useQuery(["roles-count"], () => roles.getCount());
};

export const useRolesPermissions = () => {
  return useQuery(["roles-permissions"], () => roles.getPermissions());
};

export default roles;

