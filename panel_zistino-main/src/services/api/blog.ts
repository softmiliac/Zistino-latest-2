import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../..";

const blog = {
  // posts
  getAllPosts: (page?: number, size?: number, keyword?: string) =>
    post("/blogposts/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
    }).then((res) => res.data),
  getById: (id: any) => get(`/blogposts/${id}`).then((res) => res.data),
  deletePost: (id: string) =>
    remove(`/blogposts/${id}`).then((res) => res.data),
  createPost: (data: any) => post("/blogposts", data),
  updatePost: (id: string, data: any) =>
    put(`/blogposts/${id}`, data).then((res) => res.data),

  // categories
  getAllCategories: (page?: number, size?: number, keyword?: string) =>
    post("/blogcategories/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
    }).then((res) => res.data),
  deleteCategory: (id: string) =>
    remove(`/blogcategories/${id}`).then((res) => res.data),
  updateCategory: (id: string, data: any) =>
    put(`/blogcategories/${id}`, data).then((res) => res.data),
  createCategory: (data: any) => post("/blogcategories", data),

  // tags
  getAllTags: (page?: number, size?: number, keyword?: string) =>
    post("/blogtags/search", {
      pageNumber: page,
      pageSize: size,
      keyword: keyword,
    }).then((res) => res.data),
  deleteTag: (id: string) =>
    remove(`/blogtags/${id}`).then((res) => res.data),
  updateTag: (id: string, data: any) =>
    put(`/blogtags/${id}`, data).then((res) => res.data),
  createTag: (data: any) => post("/blogtags", data),
};

// posts
export const useBlogPosts = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(
    ["blog-posts", page, keyword],
    () => blog.getAllPosts(page, size, keyword),
    {
      keepPreviousData: true,
    }
  );
};
export const useBlogPost = (id: any) => {
  return useQuery(["blog-posts", id], () => blog.getById(id), {
    keepPreviousData: true,
    enabled: !!id,
  });
};
export const useDeleteBlogPost = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => blog.deletePost(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-posts");
    },
  });
};
export const useCreateBlogPost = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => blog.createPost(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-posts");
    },
  });
};
export const useUpdateBlogPost = (id: any) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => blog.updatePost(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-posts");
    },
  });
};

// categories
export const useBlogCategories = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(
    ["blog-categories", page, keyword],
    () => blog.getAllCategories(page, size, keyword),
    {
      keepPreviousData: true,
    }
  );
};
export const useDeleteBlogCategories = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => blog.deleteCategory(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-categories");
    },
  });
};
export const useUpdateBlogCategories = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => blog.updateCategory(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-categories");
    },
  });
};
export const useCreateBlogCategories = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => blog.createCategory(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-categories");
    },
  });
};

// tags
export const useBlogTags = (page?: number, size?: number, keyword?: string) => {
  return useQuery(
    ["blog-tags", page, keyword],
    () => blog.getAllTags(page, size, keyword),
    {
      keepPreviousData: true,
    }
  );
};
export const useCreateBlogTag = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => blog.createTag(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-tags");
    },
  });
};
export const useDeleteBlogTag = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => blog.deleteTag(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-tags");
    },
  });
};
export const useUpdateBlogTag = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => blog.updateTag(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("blog-tags");
    },
  });
};
