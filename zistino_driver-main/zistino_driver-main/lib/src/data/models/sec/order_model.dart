import '../../../domain/entities/sec/order_entity.dart';
import '../base/safe_convert.dart';
import 'coupons_model.dart';
import 'order_item_model.dart';

class OrderModel extends OrderEntity{

  OrderModel({
    int? id,
    int? totalPrice,
    int? status,
    CouponsModel? coupon,
    String? userId,
    String? address1 = "",
    String? address2 = "",
    String? phone1 = "",
    String? phone2 = "",
    String? createOrderDate = "",
    String? submitPriceDate = "",
    String? sendToPostDate = "",
    String? postStateNumber = "",
    String? userFullName,
    String? paymentTrackingCode,
    String? userPhoneNumber,
    List<OrderItemModel>? orderItems,
  }):super(
    id: id ?? 0,
    totalPrice: totalPrice ?? 0,
    status: status ?? 0,
    coupon: coupon,
    userId: userId ?? "",
    address1: address1 ?? "",
    address2: address2 ?? "",
    phone1: phone1 ?? "",
    phone2: phone2 ?? "",
    createOrderDate: createOrderDate ?? "",
    submitPriceDate: submitPriceDate ?? "",
    sendToPostDate: sendToPostDate ?? "",
    postStateNumber: postStateNumber ?? "",
    paymentTrackingCode: paymentTrackingCode ?? "",
    userFullName: userFullName ?? "",
    userPhoneNumber: userPhoneNumber ?? "",
    orderItems: orderItems ?? [],
  );
  static OrderModel fromJsonModel(Map<String, dynamic> json) =>
      OrderModel.fromJson(json);

  static List<OrderModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => OrderModel.fromJson(json)).toList();

  factory OrderModel.fromJson(Map<String, dynamic>? json) => OrderModel(
    id: asT<int>(json, 'id'),
    totalPrice: asT<int>(json, 'totalPrice'),
    status: asT<int>(json, 'status'),
    coupon: CouponsModel.fromJson(asT<Map<String, dynamic>>(json, 'coupon')),
    userId: asT<String>(json, 'userId'),
    address1: asT<String>(json, 'address1'),
    address2: asT<String>(json, 'address2'),
    phone1: asT<String>(json, 'phone1'),
    phone2: asT<String>(json, 'phone2'),
    createOrderDate: asT<String>(json, 'createOrderDate'),
    submitPriceDate: asT<String>(json, 'submitPriceDate'),
    sendToPostDate: asT<String>(json, 'sendToPostDate'),
    postStateNumber: asT<String>(json, 'postStateNumber'),
    paymentTrackingCode: asT<String>(json, 'paymentTrackingCode'),
    userPhoneNumber: asT<String>(json, 'userPhoneNumber'),
    userFullName: asT<String>(json, 'userFullname'),
    orderItems: asT<List>(json, 'orderItems').map((e) => OrderItemModel.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'totalPrice': totalPrice,
    'coupon': coupon,
    'status': status,
    'userId': userId,
    'address1': address1,
    'address2': address2,
    'phone1': phone1,
    'phone2': phone2,
    'createOrderDate': createOrderDate,
    'submitPriceDate': submitPriceDate,
    'sendToPostDate': sendToPostDate,
    'postStateNumber': postStateNumber,
    'paymentTrackingCode': paymentTrackingCode,
    'userFullname': userFullName,
    'userPhoneNumber': userPhoneNumber,
    'orderItems': orderItems,
  };
}

