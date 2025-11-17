import 'package:hive/hive.dart';
import '../../../domain/entities/inv/basket_item.dart';
import '../../models/basket/service_entity.dart';
class Boxes {
  static String basketBox = "BasketBox";

  // static Box<BasketItem> getBasketBox() => Hive.box(basketBox);
  static Box<BasketItem> getBasketBox() => Hive.box(basketBox);
}
