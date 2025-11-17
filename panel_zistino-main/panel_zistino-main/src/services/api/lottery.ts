import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const lottery = {
  // User-facing Lottery endpoints
  getActive: () => get("/lotteries/active").then((res) => res.data),
  getDetail: (id: string) => get(`/lotteries/${id}/detail`).then((res) => res.data),
  buyTickets: (id: string, data: any) =>
    post(`/lotteries/${id}/buy-tickets`, data).then((res) => res.data),
  getMyTickets: () => get("/lotteries/my-tickets").then((res) => res.data),
  getWinners: () => get("/lotteries/winners").then((res) => res.data),
  
  // Admin/Manager Lottery Management endpoints
  getAll: (page?: number, size?: number, keyword?: string) =>
    post("/lotteries/search", {
      pageNumber: page,
      pageSize: size,
      keyword,
    }).then((res) => res.data),
  get: (id: string) => get(`/lotteries/${id}`).then((res) => res.data),
  create: (data: any) => post("/lotteries", data).then((res) => res.data),
  update: (id: string, data: any) => put(`/lotteries/${id}`, data).then((res: any) => res.data),
  partialUpdate: (id: string, data: any) =>
    put(`/lotteries/${id}`, data).then((res: any) => res.data),
  delete: (id: string) => remove(`/lotteries/${id}`).then((res) => res.data),
  drawWinner: (id: string, data?: any) =>
    post(`/lotteries/${id}/draw-winner`, data || {}).then((res) => res.data),
  endLottery: (id: string) =>
    post(`/lotteries/${id}/end`, {}).then((res) => res.data),
  getParticipants: (id: string) =>
    get(`/lotteries/${id}/participants`).then((res) => res.data),
  getEligibleDrivers: (id: string, minPoints?: number) =>
    get(`/lotteries/${id}/eligible-drivers${minPoints !== undefined ? `?min_points=${minPoints}` : ''}`).then((res) => res.data),
  
  // Points endpoints
  getMyBalance: () => get("/points/my-balance").then((res) => res.data),
  getMyHistory: () => get("/points/my-history").then((res) => res.data),
  // Admin points search
  searchPoints: (page?: number, size?: number, keyword?: string, source?: string) =>
    post("/points/search", {
      pageNumber: page || 1,
      pageSize: size || 20,
      keyword: keyword || "",
      source: source || "",
    }).then((res) => res.data),
  
  // Referrals endpoints
  getMyCode: () => get("/referrals/my-code").then((res) => res.data),
  getMyReferrals: () => get("/referrals/my-referrals").then((res) => res.data),
};

// Lottery hooks
export const useActiveLotteries = () => {
  return useQuery(["lotteries-active"], () => lottery.getActive());
};

export const useLotteryDetail = (id: string) => {
  return useQuery(["lottery-detail", id], () => lottery.getDetail(id), {
    enabled: !!id,
  });
};

export const useBuyLotteryTickets = () => {
  const queryClient = useQueryClient();

  return useMutation(
    ({ id, data }: { id: string; data: any }) => lottery.buyTickets(id, data),
    {
      onSuccess: () => {
        queryClient.invalidateQueries("lotteries-active");
        queryClient.invalidateQueries("lottery-detail");
        queryClient.invalidateQueries("lotteries-my-tickets");
        queryClient.invalidateQueries("points-my-balance");
        queryClient.invalidateQueries("points-my-history");
      },
    }
  );
};

export const useMyLotteryTickets = () => {
  return useQuery(["lotteries-my-tickets"], () => lottery.getMyTickets());
};

export const useLotteryWinners = () => {
  return useQuery(["lotteries-winners"], () => lottery.getWinners());
};

// Points hooks
export const useMyPointsBalance = () => {
  return useQuery(["points-my-balance"], () => lottery.getMyBalance());
};

export const useMyPointsHistory = () => {
  return useQuery(["points-my-history"], () => lottery.getMyHistory());
};

// Admin points search hook
export const usePointsSearch = (page?: number, size?: number, keyword?: string, source?: string) => {
  return useQuery(
    ["points-search", page, size, keyword, source],
    () => lottery.searchPoints(page, size, keyword, source),
    {
      keepPreviousData: true,
    }
  );
};

// Referrals hooks
export const useMyReferralCode = () => {
  return useQuery(["referrals-my-code"], () => lottery.getMyCode());
};

export const useMyReferrals = () => {
  return useQuery(["referrals-my-referrals"], () => lottery.getMyReferrals());
};

// Admin/Manager Lottery Management hooks
export const useLotteries = (page?: number, size?: number, keyword?: string) => {
  return useQuery(["lotteries", page, size, keyword], () =>
    lottery.getAll(page, size, keyword)
  );
};

export const useLotteryGet = (id: string) => {
  return useQuery(["lottery-get", id], () => lottery.get(id), {
    enabled: !!id,
  });
};

export const useCreateLottery = () => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => lottery.create(data), {
    onSuccess: () => {
      queryClient.invalidateQueries("lotteries");
    },
  });
};

export const useUpdateLottery = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => lottery.update(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("lotteries");
      queryClient.invalidateQueries("lottery-get");
    },
  });
};

export const usePartialUpdateLottery = (id: string) => {
  const queryClient = useQueryClient();

  return useMutation((data: any) => lottery.partialUpdate(id, data), {
    onSuccess: () => {
      queryClient.invalidateQueries("lotteries");
      queryClient.invalidateQueries("lottery-get");
    },
  });
};

export const useDeleteLottery = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => lottery.delete(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("lotteries");
    },
  });
};

export const useDrawLotteryWinner = () => {
  const queryClient = useQueryClient();

  return useMutation(({ id, data }: { id: string; data?: any }) => 
    post(`/lotteries/${id}/draw-winner`, data || {}).then((res) => res.data), {
    onSuccess: () => {
      queryClient.invalidateQueries("lotteries");
      queryClient.invalidateQueries("lottery-get");
      queryClient.invalidateQueries("lotteries-winners");
      queryClient.invalidateQueries("lottery-eligible-drivers");
    },
  });
};

export const useEndLottery = () => {
  const queryClient = useQueryClient();

  return useMutation((id: string) => lottery.endLottery(id), {
    onSuccess: () => {
      queryClient.invalidateQueries("lotteries");
      queryClient.invalidateQueries("lottery-get");
      queryClient.invalidateQueries("lotteries-active");
    },
  });
};

export const useLotteryParticipants = (id: string) => {
  return useQuery(["lottery-participants", id], () => lottery.getParticipants(id), {
    enabled: !!id,
  });
};

export const useLotteryEligibleDrivers = (id: string, minPoints?: number) => {
  return useQuery(["lottery-eligible-drivers", id, minPoints], () => lottery.getEligibleDrivers(id, minPoints), {
    enabled: !!id,
  });
};

