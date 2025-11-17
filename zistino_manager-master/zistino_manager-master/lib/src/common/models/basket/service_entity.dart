import 'package:hive/hive.dart';

import '../../utils/hive_utils/hive_constants.dart';


part 'service_entity.g.dart';

@HiveType(typeId: HiveTypeIdConstants.basketItemTableId)
class ServiceBasket extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String acceptorProfileId;
  @HiveField(2)
  String serviceName;
  @HiveField(3)
  String description;
  @HiveField(4)
  String discount;
  @HiveField(5)
  String companyShares;
  @HiveField(6)
  String lawyerCenter;
  @HiveField(7)
  String price;
  @HiveField(8)
  int quantity;
  @HiveField(9)
  String startDate;
  @HiveField(10)
  String endDate;
  @HiveField(11)
  String image;
  @HiveField(12)
  String status;
  @HiveField(13)
  String createdAt;
  @HiveField(14)
  String updatedAt;


  ServiceBasket({
    required this.id,
    required this.acceptorProfileId,
    required this.serviceName,
    required this.description,
    required this.discount,
    required this.companyShares,
    required this.lawyerCenter,
    required this.price,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
