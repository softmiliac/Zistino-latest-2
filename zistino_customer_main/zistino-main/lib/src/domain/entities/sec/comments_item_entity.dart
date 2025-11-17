class CommentItems {
  final int id;
  final int parentId;
  final int rate;
  final String userId;
  final String productId;
  final String productImage;
  final String userFullName;
  final String userImageUrl;
  final String text;
  final String createdOn;
  final bool isAccepted;
  final List<CommentItems>? children;


  CommentItems({
    this.id = 0,
    this.parentId = 0,
    this.productId = '',
    this.productImage = '',
    this.userId = '',
    this.userFullName = '',
    this.userImageUrl = '',
    this.rate = 0,
    this.text = '',
    this.createdOn = '',
    this.isAccepted = false,
    this.children,
  });
}
// class LazyResponse<T> {
//   final List<T> data;
//   final int currentPage;
//   final int totalPages;
//   final int totalCount;
//   final int pageSize;
//   final bool hasPreviousPage;
//   final bool hasNextPage;
//
//   // final List<String> messages;
//   final bool succeeded;
//
//   LazyResponse({
//     required this.data,
//     this.currentPage = 0,
//     this.totalPages = 0,
//     this.totalCount = 0,
//     this.pageSize = 0,
//     this.hasPreviousPage = false,
//     this.hasNextPage = false,
//     // required this.messages,
//     this.succeeded = false,
//   });
// }
