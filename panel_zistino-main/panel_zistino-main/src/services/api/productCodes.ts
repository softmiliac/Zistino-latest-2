import { useQuery, useMutation, useQueryClient } from "react-query";
import { get, post } from "../..";

const productCodes = {
  getByProduct: (productId: string, status?: string) => {
    const url = status 
      ? `/products/${productId}/codes?status=${status}`
      : `/products/${productId}/codes`;
    return get(url).then((res) => res.data);
  },
  bulkImport: (productId: string, codes: string[]) =>
    post(`/products/${productId}/codes/bulk-import`, { codes }).then((res) => res.data),
};

export const useProductCodes = (productId: string, status?: string) => {
  return useQuery(
    ["product-codes", productId, status],
    () => productCodes.getByProduct(productId, status),
    {
      enabled: !!productId,
    }
  );
};

export const useBulkImportProductCodes = () => {
  const queryClient = useQueryClient();
  return useMutation(
    ({ productId, codes }: { productId: string; codes: string[] }) =>
      productCodes.bulkImport(productId, codes),
    {
      onSuccess: (_, variables) => {
        queryClient.invalidateQueries(["product-codes", variables.productId]);
        queryClient.invalidateQueries("products");
      },
    }
  );
};

