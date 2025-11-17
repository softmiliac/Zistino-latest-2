
import 'dart:convert' as convert;

import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/inv/basket_item.dart';
import '../base/safe_convert.dart';

class BasketItemModel extends BasketItem {
  BasketItemModel(
      {required int price,
        required String id,
        required String name,
        required String description,
        required String masterImage,
        required int discountPercent,
        required int quantity,
        required int itemTotal})
      : super(
    id: id,
    price: price,
    name: name,
    description: description,
    masterImage: masterImage,
    discountPercent: discountPercent,
    quantity: quantity,
    itemTotal: itemTotal,
  );

  factory BasketItemModel.fromJson(Map<String, dynamic>? json) =>
      BasketItemModel(
        price: asT<int>(json, 'price'),
        id: asT<String>(json, 'id'),
        name: asT<String>(json, 'name'),
        description: asT<String>(json, 'description'),
        masterImage: asT<String>(json, 'masterImage'),
        discountPercent: asT<int>(json, 'discountPercent'),
        quantity: asT<int>(json, 'quantity'),
        itemTotal: asT<int>(json, 'itemTotal'),
      );

  static List<String> toJsonList(List<BasketItem> items) {
    try {
      var json = items
          .map((json) =>
          BasketItemModel.castFromEntity(json).toJson().toString())
          .toList();

      return json;
      // String __json = convert.json.encode(_json);
      // return __json;
    } catch (e) {
      AppLogger.e('$e');
      return [];
    }
  }

  static List<BasketItemModel> fromJsonList(List<String> list) {
    try {
      return list.map((str) {

        Map<String, dynamic> map = convert.json.decode(str);
        var a = BasketItemModel.fromJson(map);

        return a;
      }).toList();
    } catch (e) {
      AppLogger.e('$e');
      return [];
    }
  }

  static BasketItemModel fromJsonString(String string) {
    try {
      Map<String, dynamic>? json = convert.json.decode(string);
      return BasketItemModel.fromJson(json ?? {});
    } catch (e) {
      AppLogger.e('$e');
      throw ('$e');
    }
  }

  Map<String, dynamic> toJson() => {
    'price': price,
    'id': id,
    'name': name,
    'description': description,
    'masterImage': masterImage,
    'discountPercent': discountPercent,
    'quantity': quantity,
    'itemTotal': itemTotal,
  };

  BasketItemModel.castFromEntity(final BasketItem item)
      : super(
      id: item.id,
      name: item.name,
      price: item.price,
      itemTotal: item.itemTotal,
      quantity: item.quantity,
      masterImage: item.masterImage,
      discountPercent: item.discountPercent,
      description: item.description);
}
