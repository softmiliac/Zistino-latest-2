
class DriverDeliveryEntity {
  final int id;
  final String userId;
  final String? deliveryUserId;
  final String? setUserId;
  final String description;
  final int addressId;
  final int? orderId;
  final int? preOrderId;
  final int? examId;
  final int? requestId;
  final int? zoneId;
  final int status;
  final double latitude;
  final double longitude;
  final String deliveryDate;
  final String creator;
  final String address;
  final String createdOn;
  final String phoneNumber;
  final String dirver;

  DriverDeliveryEntity({
    this.id = 0,
    this.description = "",
    this.userId = "",
    this.deliveryUserId = "",
    this.setUserId = "",
    this.addressId =0,
    this.orderId ,
    this.preOrderId ,
    this.examId ,
    this.requestId ,
    this.zoneId,
    this.status = 0,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.deliveryDate ='',
    this.creator ='',
    this.createdOn ='',
    this.address ='',
    this.phoneNumber ='',
    this.dirver ='',
  });


}

