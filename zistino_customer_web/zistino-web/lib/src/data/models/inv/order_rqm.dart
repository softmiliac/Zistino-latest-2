

import '../base/safe_convert.dart';

class OrderRqm {
  final int totalPrice;
  final String address1;
  final String address2;
  final String phone1;
  final String phone2;
  final String createOrderDate;
  final String submitPriceDate;
  final String sendToPostDate;
  final String postStateNumber;
  final String paymentTrackingCode;
  final int status;
  final String userId;
  final List<OrderItem> orderItems;

  OrderRqm({
    this.totalPrice = 0,
    this.address1 = "",
    this.address2 = "",
    this.phone1 = "",
    this.phone2 = "",
    this.createOrderDate = "",
    this.submitPriceDate = "",
    this.sendToPostDate = "",
    this.postStateNumber = "",
    this.paymentTrackingCode = "",
    this.status = 0,
    this.userId = "",
    required this.orderItems,
  });

  factory OrderRqm.fromJson(Map<String, dynamic>? json) => OrderRqm(
    totalPrice: asT<int>(json, 'totalPrice'),
    address1: asT<String>(json, 'address1'),
    address2: asT<String>(json, 'address2'),
    phone1: asT<String>(json, 'phone1'),
    phone2: asT<String>(json, 'phone2'),
    createOrderDate: asT<String>(json, 'createOrderDate'),
    submitPriceDate: asT<String>(json, 'submitPriceDate'),
    sendToPostDate: asT<String>(json, 'sendToPostDate'),
    postStateNumber: asT<String>(json, 'postStateNumber'),
    paymentTrackingCode: asT<String>(json, 'paymentTrackingCode'),
    status: asT<int>(json, 'status'),
    userId: asT<String>(json, 'userId'),
    orderItems: asT<List>(json, 'orderItems').map((e) => OrderItem.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'totalPrice': totalPrice,
    'address1': address1,
    'address2': address2,
    'phone1': phone1,
    'phone2': phone2,
    'postStateNumber': postStateNumber,
    'paymentTrackingCode': paymentTrackingCode,
    'status': status,
    'userId': userId,
    'orderItems': orderItems.map((e) => e.toJson()).toList(),
  };
}

class OrderItem {
  final String productId;
  final int unitPrice;
  final int unitDiscountPrice;
  final int itemCount;
  final int status;
  final String description;

  OrderItem({
    this.productId = "",
    this.unitPrice = 0,
    this.unitDiscountPrice = 0,
    this.itemCount = 0,
    this.status = 0,
    this.description = "",
  });

  factory OrderItem.fromJson(Map<String, dynamic>? json) => OrderItem(
    productId: asT<String>(json, 'productId'),
    unitPrice: asT<int>(json, 'unitPrice'),
    unitDiscountPrice: asT<int>(json, 'unitDiscountPrice'),
    itemCount: asT<int>(json, 'itemCount'),
    status: asT<int>(json, 'status'),
    description: asT<String>(json, 'description'),
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'unitPrice': unitPrice,
    'unitDiscountPrice': unitDiscountPrice,
    'itemCount': itemCount,
    'status': status,
    'description': description,
  };
}

