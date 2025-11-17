// import 'package:hive_flutter/adapters.dart';



import '../../../data/models/inv/basket_item_model.dart';

class BasketEntity  {

  int? id;

  String? userId;

  List<BasketItemModel>? items;

  bool? isEmpty;

  int? totalItems;

  int? totalUniqueItems;

  int? cartTotal;

  BasketEntity({
    this.id = 0,
    this.userId = "",
    this.items,
    this.isEmpty = false,
    this.totalItems = 0,
    this.totalUniqueItems = 0,
    this.cartTotal = 0,
  });

  BasketEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    userId = json['userId'] ?? "";
    items = json['items'];
    isEmpty = json['isEmpty'] ?? false;
    totalItems = json['totalItems'] ?? 0;
    totalUniqueItems = json['totalUniqueItems'] ?? 0;
    cartTotal = json['cartTotal'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['items'] = items;
    data['isEmpty'] = isEmpty;
    data['totalItems'] = totalItems;
    data['totalUniqueItems'] = totalUniqueItems;
    data['cartTotal'] = cartTotal;
    return data;
  }
}
