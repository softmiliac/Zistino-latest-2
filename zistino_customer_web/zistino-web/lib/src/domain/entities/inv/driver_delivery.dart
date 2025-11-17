class DriverDeliveryEntity {
  int id;
  String userId;
  String phoneNumber;
  String? deliveryUserId;
  String? setUserId;
  String description;
  String driver;
  String driverPhone;
  int addressId;
  int? orderId;
  int? preOrderId;
  int? examId;
  int? requestId;
  int? zoneId;
  int status;
  String? deliveryDate;
  String creator;
  String createdOn;
  String address;
  double latitude;
  double longitude;

  DriverDeliveryEntity({
    this.id = 0,
    this.description = "",
    this.phoneNumber = "",
    this.userId = "",
    this.deliveryUserId,
    this.setUserId = "",
    required this.addressId,
    this.orderId,
    this.preOrderId,
    this.examId,
    this.requestId,
    this.zoneId,
    this.status = 0,
    this.deliveryDate,
    this.creator ='',
    this.createdOn ='',
    this.address ='',
    this.driver ='',
    this.driverPhone ='',
    this.latitude = 0.0,
    this.longitude = 0.0,
  });


}

