
class LazyResponse<T> {
  final List<T> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  // final List<String> messages;
  final bool succeeded;

  LazyResponse({
    required this.data,
    this.currentPage = 0,
    this.totalPages = 0,
    this.totalCount = 0,
    this.pageSize = 0,
    this.hasPreviousPage = false,
    this.hasNextPage = false,
    // required this.messages,
    this.succeeded = false,
  });
}
