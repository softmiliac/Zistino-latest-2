
import 'package:admin_zistino/src/data/models/base/safe_convert.dart';

class LazyRQM {
  final AdvancedSearch? advancedSearch;
  final String keyword;
  final int pageNumber;
  final int pageSize;
  final List<String>? orderBy;
  final String brandId;
  final int? categoryId;
  final int? status;
  final String? productId;
  final String? roleId;
  final int? tripId;

  LazyRQM({
    this.advancedSearch,
    this.keyword = "",
    this.pageNumber = 0,
    this.status,
    this.pageSize = 100,
    this.orderBy,
    this.brandId = "",
    this.categoryId,
    this.productId,
    this.roleId,
    this.tripId = 0,
  });

  factory LazyRQM.fromJson(Map<String, dynamic>? json) => LazyRQM(
    advancedSearch: AdvancedSearch.fromJson(asT<Map<String,dynamic>>(json,'advancedSearch')),
    keyword: asT<String>(json, 'keyword'),
    pageNumber: asT<int>(json, 'pageNumber'),
    pageSize: asT<int>(json, 'pageSize'),
    status: asT<int>(json, 'status'),
    // orderBy: asT<List>(json, 'orderBy').map((e) => e.toString()).toList(),
    orderBy: asT<List<String>>(json, 'orderBy'),
    brandId: asT<String>(json, 'brandId'),
    categoryId: asT<int>(json, 'categoryId'),
    productId: asT<String>(json, 'productId'),
    roleId: asT<String>(json, 'roleId'),
    tripId: asT<int>(json, 'tripId'),
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
    'roleId': roleId,
    'tripId': tripId,
    'advancedSearch': advancedSearch?.toJson(),
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
    // fields: asT<List>(json, 'fields').map((e) => e.toString()).toList(),
    fields: asT<List<String>>(json, 'fields'),
    keyword: asT<String>(json, 'keyword'),
  );

  Map<String, dynamic> toJson() => {
    'fields': fields,
    'keyword': keyword,
  };
}
