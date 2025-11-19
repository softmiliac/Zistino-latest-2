import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, remove } from "../../";

const users = {
  getAllUserSearch: (page?: number, size?: number, keyword?: string) =>
    post("/users/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  getAllUserSearchByRole: (page?: number, size?: number, keyword?: string) =>
    post("/users/userbyrole", {
      pageNumber: page,
      pageSize: size,
      keyword,
      role: "driver", // Backend expects "driver" or "customer", not roleId
    }).then((res) => res.data),
  getAllUserByRole: () =>
    post("/users/userbyrole", {
      role: "driver", // Backend expects "driver" or "customer", not roleId
    }).then((res) => res.data),
  getAll: () => get("/users/").then((res) => res.data),
  getWallet: (id?: string) =>
    id
      ? get(
          `transactionwallet/drivertransactionwallettotalbyuserid?UserId=${id}`
        ).then((res) => res.data)
      : {},
  getUserData: () => get("/personal/profile").then((res) => res.data),
  getRoles: (id: string) => get(`/users/${id}/roles`).then((res) => res.data),
  setRole: (id: string, data: IUser) =>
    post(`/users/${id}/roles`, data).then((res) => res.data),
  //   getById: (id: string) => get(`/roles/${id}`).then((res) => res.data),
  create: (data: IUser) => post("/identity/register", data),
  // delete: (id: string) => remove(`/roles/${id}`).then((res) => res.data),
};

export const useUsers = (page?: number, size?: number, keyword?: string) => {
  return useQuery(["users", page, size, keyword], () =>
    users.getAllUserSearch(page, size, keyword)
  );
};

export const useUsersByDate = (fromDate: string, toDate: string) => {
  return useQuery(["users-date", fromDate, toDate], () =>
    post(
      `/personal/profiledatebyrepresentativedate`,
      {
        startDate: fromDate,
        endDate: toDate,
      }
    ).then((res) => res.data)
  );
};

export const useGetUserWallet = (id: string) => {
  return useQuery(["user-wallet", id], () => users.getWallet(id));
};

export const useUserData = () => {
  return useQuery(["user-data"], () => users.getUserData());
};

export const useAllUserData = () => {
  return useQuery(["users-all"], () => users.getAll());
};

export const useDriversAll = () => {
  return useQuery(["users"], () => users.getAllUserByRole());
};

export const useUsersByRole = (
  page?: number,
  size?: number,
  keyword?: string
) => {
  return useQuery(["users-drivers", page, size, keyword], () =>
    users.getAllUserSearchByRole(page, size, keyword)
  );
};

export const useUserRoles = (id: string) => {
  return useQuery(["user-roles", id], () => users.getRoles(id), {
    enabled: id.length > 8,
  });
};

export const useSetUserRole = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any): any => users.setRole(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("users");
    },
  });
};

export const useCreateUser = () => {
  const queryClient = useQueryClient();

  return useMutation((data: IUser) => users.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("users");
    },
  });
};
