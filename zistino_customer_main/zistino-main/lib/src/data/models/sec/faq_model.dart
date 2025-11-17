import '../../../domain/entities/sec/faq.dart';
import '../../../domain/entities/sec/faq_item.dart';
import '../base/safe_convert.dart';

class FaqModel extends FaqEntity {
  FaqModel(
      {final int? categoryId,
      final String? categoryName,
      final List<FaqsItem>? faqs})
      : super(
            categoryId: categoryId ?? 0,
            categoryName: categoryName ?? '',
            faqs: faqs ?? []);

  factory FaqModel.fromJson(Map<String, dynamic>? json) => FaqModel(
        categoryId: asT<int>(json, 'categoryId'),
        categoryName: asT<String>(json, 'categoryName'),
        faqs: asT<List>(json, 'faqs').map((e) => FaqsItem.fromJson(e)).toList(),
      );

  static List<FaqModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => FaqModel.fromJson(json)).toList();

  FaqModel.castFromEntity(final FaqEntity item)
      : super(
            categoryId: item.categoryId,
            categoryName: item.categoryName,
            faqs: item.faqs);

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'categoryName': categoryName,
        'faqs': faqs.map((e) => e),
      };
}

class FaqsItem extends FaqsItemEntity {
  FaqsItem({final int? id, final String? title, final String? description})
      : super(
          id: id ?? 0,
          title: title ?? '',
          description: description ?? '',
        );

  factory FaqsItem.fromJson(Map<String, dynamic>? json) => FaqsItem(
        id: asT<int>(json, 'id'),
        title: asT<String>(json, 'title'),
        description: asT<String>(json, 'description'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}
