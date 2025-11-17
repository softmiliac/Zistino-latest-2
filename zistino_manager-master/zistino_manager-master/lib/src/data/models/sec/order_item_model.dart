import '../../../domain/entities/sec/order_item_entity.dart';
import '../base/safe_convert.dart';

class OrderItemModel extends OrderItemsEntity{

  OrderItemModel({
    int? id,
    String? productId,
    String? productName,
    String? productImage,
    int? unitPrice,
    int? unitDiscountPrice,
    int? itemCount,
    int? status,
  }):super(
    id: id ?? 0,
    productId: productId ?? '',
    productName: productName ?? '',
    unitPrice: unitPrice ?? 0,
    unitDiscountPrice: unitDiscountPrice ?? 0,
    itemCount: itemCount ?? 0,
    status: status ?? 0,
    productImage: productImage ?? ''
  );
  static OrderItemModel fromJsonModel(Map<String, dynamic> json) =>
      OrderItemModel.fromJson(json);

  static List<OrderItemModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => OrderItemModel.fromJson(json)).toList();

  factory OrderItemModel.fromJson(Map<String, dynamic>? json) => OrderItemModel(
    id: asT<int>(json, 'id'),
    productId: asT<String>(json, 'productId'),
    productName: asT<String>(json, 'productName'),
    productImage: asT<String>(json, 'productImage'),
    unitPrice: asT<int>(json, 'unitPrice'),
    unitDiscountPrice: asT<int>(json, 'unitDiscountPrice'),
    itemCount: asT<int>(json, 'itemCount'),
    status: asT<int>(json, 'status'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'productId': productId,
    'productName': productName,
    'productImage': productImage,
    'unitPrice': unitPrice,
    'unitDiscountPrice': unitDiscountPrice,
    'itemCount': itemCount,
    'status': status,
  };
}

