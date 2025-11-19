import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post, put, remove } from "../../";

const comment = {
    getAll: (page?: number, size?: number, keyword?: string) =>
        post("/deliverysurveys/search", {
            pageNumber: page || 1,
            pageSize: size || 10,
            keyword: keyword || "",
        }).then((res) => res.data),

};

export const useComments = (
    page?: number,
    size?: number,
    keyword?: string
) => {
    return useQuery(
        ["comment", page, size, keyword],
        () => comment.getAll(page, size, keyword),
        {
            keepPreviousData: true,
        }
    );
};
