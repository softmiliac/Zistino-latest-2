import '../base/safe_convert.dart';

class CommentModel {
  final String? files;
  final String productId;
  final int rate;
  final int examId;
  final String text;
  final String title;
  final bool isAccepted;

  CommentModel({
    this.files = "",
    this.productId = "",
    this.rate = 0,
    this.examId = 0,
    this.text = "",
    this.title = "",
    this.isAccepted = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic>? json) => CommentModel(
    files: asT<String>(json, 'files'),
    productId: asT<String>(json, 'productId'),
    rate: asT<int>(json, 'rate'),
    examId: asT<int>(json, 'examId'),
    text: asT<String>(json, 'text'),
    title: asT<String>(json, 'title'),
    isAccepted: asT<bool>(json, 'isAccepted'),
  );

  Map<String, dynamic> toJson() => {
    'files': files,
    'productId': productId,
    'rate': rate,
    'examId': examId,
    'text': text,
    'title': title,
    'isAccepted': isAccepted,
  };
}

