
import 'package:recycling_machine/src/data/models/base/safe_convert.dart';

class LazyRQM {
  final String keyword;
  final int pageNumber;
  final int pageSize;
  final List<String>? orderBy;
  final String brandId;
  final int? categoryId;
  final int? status;
  final String? productId;

  LazyRQM({
    this.keyword = "",
    this.pageNumber = 0,
    this.status,
    this.pageSize = 100,
    this.orderBy,
    this.brandId = "",
    this.categoryId,
    this.productId,
  });

  factory LazyRQM.fromJson(Map<String, dynamic>? json) => LazyRQM(
    keyword: asT<String>(json, 'keyword'),
    pageNumber: asT<int>(json, 'pageNumber'),
    pageSize: asT<int>(json, 'pageSize'),
    status: asT<int>(json, 'status'),
    // orderBy: asT<List>(json, 'orderBy').map((e) => e.toString()).toList(),
    orderBy: asT<List<String>>(json, 'orderBy'),
    brandId: asT<String>(json, 'brandId'),
    categoryId: asT<int>(json, 'categoryId'),
    productId: asT<String>(json, 'productId'),
  );

  Map<String, dynamic> toJson() => {
    'keyword': keyword,
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'orderBy': orderBy,
    'brandId': brandId,
    'categoryId': categoryId,
    'productId': productId,
    'status': status,
  };
}

class AdvancedSearch {
  final List<String> fields;
  final String keyword;

  AdvancedSearch({
    required this.fields,
    this.keyword = "",
  });

  factory AdvancedSearch.fromJson(Map<String, dynamic>? json) => AdvancedSearch(
    fields: asT<List>(json, 'fields').map((e) => e.toString()).toList(),
    keyword: asT<String>(json, 'keyword'),
  );

  Map<String, dynamic> toJson() => {
    'fields': fields.map((e) => e),
    'keyword': keyword,
  };
}
