
import '../../../domain/entities/sec/comments_item_entity.dart';
import '../base/safe_convert.dart';

class CommentsItemsModel extends CommentItems {
  CommentsItemsModel({
    int? id,
    int? parentId,
    int? rate,
    String? userId,
    String? productId,
    String? productImage,
    String? userFullName,
    String? userImageUrl,
    String? text,
    String? createdOn,
    bool? isAccepted,
    List<CommentItems>? children,
  }) : super(
            parentId: parentId ?? 0,
            productId: productId ?? '',
            productImage: productImage ?? '',
            userId: userId ?? '',
            id: id ?? 0,
            userFullName: userFullName ?? '',
            userImageUrl: userImageUrl ?? '',
            text: text ?? '',
            rate: rate ?? 0,
            createdOn: createdOn ?? '',
            children: children ?? [],
            isAccepted: isAccepted ?? false);

  factory CommentsItemsModel.fromJson(Map<String, dynamic> json) {
    return CommentsItemsModel(
      id: asT<int>(json, 'id'),
      userId: asT<String>(json, 'userId'),
      productId: asT<String>(json, 'productId'),
      productImage: asT<String>(json, 'productImage'),
      parentId: asT<int>(json, 'parentId'),
      userFullName: asT<String>(json, 'userFullName'),
      userImageUrl: asT<String>(json, 'userImageUrl'),
      rate: asT<int>(json, 'rate'),
      text: asT<String>(json, 'text'),
      createdOn: asT<String>(json, 'createdOn'),
      children:
          // items,
          asT<List>(json, 'children')
              .map((e) => CommentsItemsModel.fromJson(e))
              .toList(),
      isAccepted: asT<bool>(json, 'isAccepted'),
    );
  }

  static List<CommentsItemsModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => CommentsItemsModel.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        'parentId': parentId,
        'productId': productId,
        'productImage': productImage,
        'userId': userId,
        'id': id,
        'userFullName': userFullName,
        'userImageUrl': userImageUrl,
        'text': text,
        'rate': rate,
        'createdOn': createdOn,
        'children': children?.map((e) => e),
        'isAccepted': isAccepted,
      };
}
