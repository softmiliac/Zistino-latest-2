import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const tags = {
  getAll: (page: number) =>
    post("/tags/search", {
      pageNumber: page,
      pageSize: 8,
    }).then((res) => res.data),
  create: (data: ITag) => post("/tags", data),
  delete: (id: string) => remove(`/tags/${id}`).then((res) => res.data),
  update: (id: string, data: ITag) =>
    put(`/tags/${id}`, data).then((res) => res.data),
};

export const useTags = (page: number) => {
  return useQuery(["tags", page], () => tags.getAll(page));
};

export const useDeleteTag = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => tags.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("tags");
    },
  });
};

export const useCreateTag = () => {
  const queryClient = useQueryClient();

  return useMutation((data: ITag) => tags.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("tags");
    },
  });
};

export const useUpdateTag = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: ITag) => tags.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("tags");
    },
  });
};
