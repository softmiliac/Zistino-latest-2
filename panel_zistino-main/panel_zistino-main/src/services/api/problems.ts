import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const problems = {
  getAll: (page?: number, size?: number) =>
    post("/problems/search", {
      pageNumber: page,
      pageSize: size,
    }).then((res) => res.data),
  // getById: (id: string) => get(`/roles/${id}`).then(res => res.data),
  create: (data: IProblem) => post("/problems", data),
  delete: (id: string) => remove(`/problems/${id}`).then((res) => res.data),
  update: (id: string, data: any) =>
    put(`/problems/${id}`, data).then((res) => res.data),
};

export const useProblems = (page?: number, size?: number) => {
  return useQuery(["problems", page], () => problems.getAll(page, size));
};

export const useDeleteProblem = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => problems.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("problems");
    },
  });
};

export const useCreateProblem = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IProblem) => problems.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("problems");
    },
  });
};

export const useUpdateProblem = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: IProblem) => problems.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("problems");
    },
  });
};
