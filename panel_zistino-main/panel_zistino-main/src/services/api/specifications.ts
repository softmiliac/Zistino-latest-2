import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const specifications = {
  getAll: () =>
    post("/productspecifications/search", {}).then((res) => res.data),
  // getById: (id: string) => get(`/roles/${id}`).then(res => res.data),
  create: (data: ISpecifications) => post("/productspecifications", data),
  delete: (id: string) =>
    remove(`/productspecifications/${id}`).then((res) => res.data),
  update: (id: string, data: ISpecifications) =>
    put(`/productspecifications/${id}`, data).then((res) => res.data),
};

export const useSpecifications = () => {
  return useQuery("specifications", specifications.getAll);
};

export const useCreateSpecification = () => {
  const queryClient = useQueryClient();

  return useMutation((data: ISpecifications) => specifications.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("specifications");
    },
  });
};

export const useUpdateSpecification = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation(
    (data: ISpecifications) => specifications.update(id, data),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("specifications");
      },
    }
  );
};

export const useDeleteSpecification = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => specifications.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("specifications");
    },
  });
};
