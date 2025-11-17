import 'package:hive/hive.dart';
import '../../../domain/entities/inv/basket_item.dart';
import '../../../domain/entities/sec/location_item.dart';
import '../../models/basket/service_entity.dart';
class Boxes {
  static String basketBox = "BasketBox";
  // static String locationBox = "LocationBox";

  // static Box<BasketItem> getBasketBox() => Hive.box(basketBox);
  static Box<BasketItem> getBasketBox() => Hive.box(basketBox);
  // static Box<LocationItem> getLocationBox() => Hive.box(locationBox);
}
