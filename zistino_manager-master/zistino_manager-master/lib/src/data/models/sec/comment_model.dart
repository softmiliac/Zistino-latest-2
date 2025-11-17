

import '../base/safe_convert.dart';

class CommentModel {
  final int? id;
  final String? parentId;
  final String productId;
  final int rate;
  final String text;
  final bool isAccepted;

  CommentModel({
    this.id = 0,
    this.parentId = "",
    this.productId = "",
    this.rate = 0,
    this.text = "",
    this.isAccepted = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic>? json) => CommentModel(
    id: asT<int>(json, 'id'),
    parentId: asT<String>(json, 'parentId'),
    productId: asT<String>(json, 'productId'),
    rate: asT<int>(json, 'rate'),
    text: asT<String>(json, 'text'),
    isAccepted: asT<bool>(json, 'isAccepted'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'parentId': parentId,
    'productId': productId,
    'rate': rate,
    'text': text,
    'isAccepted': isAccepted,
  };
}

