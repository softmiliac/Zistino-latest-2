
import 'package:admin_dashboard/src/data/models/base/safe_convert.dart';

class LazyRQM {
  final String keyword;
  final int pageNumber;
  final int pageSize;
  final int? status;
  final List<String>? orderBy;
  final String? brandId;
  final int? categoryType;
  final int? categoryId;
  final String? productId;

  LazyRQM({
    this.keyword = "",
    this.pageNumber = 0,
    this.pageSize = 100,
    this.status,
    this.orderBy,
    this.brandId,
    this.categoryType,
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
    categoryType: asT<int>(json, 'categoryType'),
    categoryId: asT<int>(json, 'categoryId'),
    productId: asT<String>(json, 'productId'),
  );

  Map<String, dynamic> toJson() => {
    'keyword': keyword,
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'orderBy': orderBy,
    'status': status,
    'brandId': brandId,
    'categoryType': categoryType,
    'categoryId': categoryId,
    'productId': productId,
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
