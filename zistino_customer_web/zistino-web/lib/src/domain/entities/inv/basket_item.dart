import 'package:hive_flutter/adapters.dart';

import '../../../common/utils/hive_utils/hive_constants.dart';

part 'basket_item.g.dart';
@HiveType(typeId: HiveTypeIdConstants.basketItemTableId)
class BasketItem extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String masterImage;
  @HiveField(4)
  int price;
  @HiveField(5)
  int discountPercent;
  @HiveField(6)
  int quantity;
  @HiveField(7)
  int itemTotal;

  BasketItem({
    required this.id,
    required this.price,
    required this.masterImage,
    required this.name,
    required this.discountPercent,
    required this.description,
    required this.itemTotal,
    required this.quantity,
  });
}
