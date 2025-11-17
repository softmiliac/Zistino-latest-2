import '../base/safe_convert.dart';

class DeleteDriverDeliveryRQM {
  final int id;
  final String? userId;
  final String? deliveryUserId;
  final String? deliveryDate;
  final String? setUserId;
  final int? addressId;
  final int? orderId;
  final int? examId;
  final int? requestId;
  final int? zoneId;
  final int? status;
  final String? description;

  DeleteDriverDeliveryRQM({
    this.id = 0,
    this.userId = "",
    this.deliveryUserId = "",
    this.deliveryDate = "",
    this.setUserId = "",
    this.addressId = 0,
    this.orderId = 0,
    this.examId = 0,
    this.requestId = 0,
    this.zoneId = 0,
    this.status = 0,
    this.description = "",
  });

  factory DeleteDriverDeliveryRQM.fromJson(Map<String, dynamic>? json) => DeleteDriverDeliveryRQM(
    userId: asT<String>(json, 'userId'),
    deliveryUserId: asT<String>(json, 'deliveryUserId'),
    deliveryDate: asT<String>(json, 'deliveryDate'),
    setUserId: asT<String>(json, 'setUserId'),
    addressId: asT<int>(json, 'addressId'),
    orderId: asT<int>(json, 'orderId'),
    examId: asT<int>(json, 'examId'),
    requestId: asT<int>(json, 'requestId'),
    zoneId: asT<int>(json, 'zoneId'),
    status: asT<int>(json, 'status'),
    description: asT<String>(json, 'description'),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'deliveryUserId': deliveryUserId,
    'deliveryDate': deliveryDate,
    'setUserId': setUserId,
    'addressId': addressId,
    'orderId': orderId,
    'examId': examId,
    'requestId': requestId,
    'zoneId': zoneId,
    'status': status,
    'description': description,
  };
}

