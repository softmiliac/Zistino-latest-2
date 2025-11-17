
import 'package:json_annotation/json_annotation.dart';

import '../../../data/models/pro/product_model.dart';



// @Collection()
class ProductSectionEntity {
  // @Id()
  // int localID = Isar.autoIncrement;

  int id;
  String name;
  String page;
  String groupName;
  int version;
  String productId;
  String imagePath;
  ProductSectionSetting setting;
  String description;
  String linkUrl;
  String locale;
  ProductModel? productModel;

  ProductSectionEntity({
    this.id = 0,
    this.name = '',
    this.page = '',
    this.groupName = '',
    this.version = 0,
    this.productId = '',
    this.imagePath = '',
    required this.setting,
    this.description = '',
    this.linkUrl = '',
    this.locale = '',
    this.productModel,
  });
}

class ProductSectionSetting {
  ProductSectionType type;
  DateTime? expireDate;

  ProductSectionSetting(
      {this.type = ProductSectionType.horizontal, this.expireDate});
}

//0 - horizontal , 1 - vertical , 2 - scrollable , 3 - offer , 4 - category
enum ProductSectionType {
@JsonValue("0")
horizontal,
@JsonValue("1")
vertical,
@JsonValue("2")
scrollable,
@JsonValue("3")
offer,
@JsonValue("4")
category,
@JsonValue("5")
banner,
}
