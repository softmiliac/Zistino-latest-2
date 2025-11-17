
import '../../../domain/entities/inv/basket.dart';
import '../base/safe_convert.dart';
import 'basket_item_model.dart';

class BasketModel extends BasketEntity {
  BasketModel(
      {final int? id,
        final String? userId,
        final List<BasketItemModel>? items,
        final bool? isEmpty,
        final int? totalItems,
        final int? totalUniqueItems,
        final int? cartTotal})
      : super(
      id: id ?? 0,
      userId: userId ?? '',
      cartTotal: cartTotal ?? 0,
      isEmpty: isEmpty ?? false,
      items: items,
      totalItems: totalItems ?? 0,
      totalUniqueItems: totalUniqueItems ?? 0);

  factory BasketModel.fromJson(Map<String, dynamic>? json) {
    List<BasketItemModel> basketItemsModel;
    try {
      var jsonBasket = json?['items'];
      if (jsonBasket != null) {
        basketItemsModel = BasketItemModel.fromJsonList(jsonBasket);
      } else {
        basketItemsModel = [];
      }
    } catch (e) {
      basketItemsModel = [];
    }
    return BasketModel(
      id: asT<int>(json, 'id'),
      userId: asT<String>(json, 'userId'),
      items: basketItemsModel,
      isEmpty: asT<bool>(json, 'isEmpty'),
      totalItems: asT<int>(json, 'totalItems'),
      totalUniqueItems: asT<int>(json, 'totalUniqueItems'),
      cartTotal: asT<int>(json, 'cartTotal'),
    );
  }

  BasketModel.castFromEntity(final BasketEntity item)
      : super(
      id: item.id,
      userId: item.userId,
      items: item.items,
      isEmpty: item.isEmpty,
      totalItems: item.totalItems,
      totalUniqueItems: item.totalUniqueItems,
      cartTotal: item.cartTotal);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items,
    'isEmpty': isEmpty,
    'totalItems': totalItems,
    'totalUniqueItems': totalUniqueItems,
    'cartTotal': cartTotal,
  };
}
