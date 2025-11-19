import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const menu = {
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/menulinks/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
      orderBy: ["name"],
    }).then((res) => res.data),
  getList: () => get("/menulinks/all").then((res) => res.data),
  create: (data: any) => post("/menulinks", data),
  delete: (id: string) => remove(`/menulinks/${id}`).then((res) => res.data),
  update: (id: string, data: any) =>
    put(`/menulinks/${id}`, data).then((res) => res.data),
};

export const useMenuLinks = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(["menu-links", page, keyword], () =>
    menu.getAll(page, size, keyword)
  );
};

export const useMenuLinkList = () => {
  return useQuery("menu-links-list", menu.getList);
};

export const useCreateMenuLink = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => menu.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("menu-links");
    },
  });
};

export const useDeleteMenuLink = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => menu.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("menu-links");
    },
  });
};

export const useUpdateMenuLink = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => menu.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("menu-links");
    },
  });
};
