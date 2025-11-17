import 'coupon.dart';
import 'order_item_entity.dart';

class OrderEntityClient {
  final int id;
  final int totalPrice;
   int status;
  final CouponEntity? coupon; //todo change type
  final String userId; //todo change type
  final String address1;
  final String address2;
  final String phone1;
  final String phone2;
  final String createOrderDate;
  final String submitPriceDate;
  final String sendToPostDate;
  final String postStateNumber;
  final String userFullName;
  final String paymentTrackingCode;
  final String userPhoneNumber;
  final List<OrderItemsEntity>? orderItems;

  OrderEntityClient({
    this.id = 0,
    this.totalPrice = 0,
    this.coupon,
    this.status = 0,
    this.userId = "",
    this.address1 = "",
    this.address2 = "",
    this.phone1 = "",
    this.phone2 = "",
    this.createOrderDate = "",
    this.submitPriceDate = "",
    this.sendToPostDate = "",
    this.postStateNumber = "",
    this.paymentTrackingCode = "",
    this.userFullName = "",
    this.userPhoneNumber = "",
    this.orderItems,
  });
}
class OrderEntityDriver {
  final int id;
  final int totalPrice;
  int status;
  final CouponEntity? coupon; //todo change type
  final String userId; //todo change type
  final String address1;
  final String address2;
  final String phone1;
  final String phone2;
  final String createOrderDate;
  final String submitPriceDate;
  final String sendToPostDate;
  final String postStateNumber;
  final String userFullName;
  final String paymentTrackingCode;
  final String userPhoneNumber;
  final List<OrderItemsEntity>? orderItems;

  OrderEntityDriver({
    this.id = 0,
    this.totalPrice = 0,
    this.coupon,
    this.status = 0,
    this.userId = "",
    this.address1 = "",
    this.address2 = "",
    this.phone1 = "",
    this.phone2 = "",
    this.createOrderDate = "",
    this.submitPriceDate = "",
    this.sendToPostDate = "",
    this.postStateNumber = "",
    this.paymentTrackingCode = "",
    this.userFullName = "",
    this.userPhoneNumber = "",
    this.orderItems,
  });
}
