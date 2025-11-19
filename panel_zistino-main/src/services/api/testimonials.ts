import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const testimonials = {
  getAll: (page?: number, size?: number) =>
    post("/testimonials/search", {
      pageNumber: page,
      pageSize: size,
      orderBy: ["name"],
    }).then((res) => res.data),
  // getById: (id: string) => get(`/roles/${id}`).then(res => res.data),
  create: (data: ITestimonial) => post("/testimonials", data),
  delete: (id: string) =>
    remove(`/testimonials/${id}`).then((res) => res.data),
  update: (id: string, data: any) =>
    put(`/testimonials/${id}`, data).then((res) => res.data),
};

export const useTestimonial = (page?: number, size?: number) => {
  return useQuery("testimonials", () => testimonials.getAll(page, size));
};

export const useDeleteTestimonial = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => testimonials.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("testimonials");
    },
  });
};

export const useCreateTestimonial = () => {
  const queryClient = useQueryClient();

  return useMutation((data: ITestimonial) => testimonials.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("testimonials");
    },
  });
};

export const useUpdateTestimonial = (id: any) => {
  const queryClient = useQueryClient();

  return useMutation((data: IBrand) => testimonials.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("testimonials");
    },
  });
};
