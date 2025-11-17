import { Dispatch, FC, SetStateAction } from "react";
import { ConfigProvider, Pagination, Table, TableProps } from "antd";
import { ColumnsType } from "antd/lib/table";

import fa_IR from "antd/es/locale/fa_IR";
import en_US from "antd/es/locale/en_US";
import "../../assets/styles/table.css";

interface Props {
  columns: ColumnsType<any> | undefined;
  dataSource: readonly any[] | undefined;
  configData: any;
  page: number;
  perPage: number;
  setPage: Dispatch<SetStateAction<number>>;
  setPerPage: Dispatch<SetStateAction<number>>;
  notHavePaging?: boolean;
}

export const ProTable: FC<Props> = ({
  columns,
  dataSource,
  configData,
  page,
  perPage,
  setPage,
  setPerPage,
  notHavePaging,
}) => {
  const isLangFa = localStorage.getItem("i18nextLng") === "fa";
  // Ensure dataSource is always an array to prevent Ant Design errors
  const safeDataSource = Array.isArray(dataSource) ? dataSource : [];
  const tableProps: TableProps<any> = {
    size: "middle",
    columns,
    dataSource: safeDataSource,
    pagination: false,
    rowKey: () => Math.random(),
  };

  const onChangePage = (page: number, pageSize: number) => {
    if (pageSize) {
      setPerPage(pageSize);
      setPage(1);
    }
    if (page) setPage(page);
  };

  return (
    <ConfigProvider
      direction={isLangFa ? "rtl" : "ltr"}
      locale={isLangFa ? fa_IR : en_US}
    >
      <Table {...tableProps} />
      {!notHavePaging && (
        <Pagination
          size="small"
          total={configData?.totalCount}
          defaultPageSize={perPage}
          current={page}
          onChange={onChangePage}
        />
      )}
    </ConfigProvider>
  );
};
