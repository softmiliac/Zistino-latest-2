import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../common/services/get_storage_service.dart';
import '../../../../common/utils/app_logger.dart';
import '../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../data/models/inv/order_rqm.dart';
import '../../../../data/repositories/inv/basket_repository.dart';
import '../../../../domain/entities/inv/basket.dart';
import '../../../../domain/entities/inv/basket_item.dart';
import '../../../../domain/entities/sec/location_item.dart';

class BasketController extends GetxController {
  /// Variables ///
  var itemTotal = 10.obs;
  var isBusyAddToCart = false.obs;
  List<BasketItem> item = <BasketItem>[];
  BasketItem? locItemFirst ;
  BasketItem? locItemSecond ;
  List<OrderItemsItem> orderItems = [];

  /// Instances ///
  final BasketRepositoryImpl _repo = BasketRepositoryImpl();
  Box<BasketItem> box = Boxes.getBasketBox();
  final LocalStorageService pref = Get.find();

  /// Functions ///


  @override
  void onInit() async {
    // getItems();
    super.onInit();
  }

  List<OrderItemsItem> order() {
    for (var element in box.values) {
      try {
        orderItems.add(OrderItemsItem(
            status: 0,
            description: element.description,
            itemCount: element.itemTotal,
            productId: element.id,
            unitDiscountPrice: element.discountPercent,
            unitPrice: element.price));
      } catch (e) {
        AppLogger.e('$e');
      }
    }
    return orderItems;
  }

/*
  Future createOrder() async {
    OrderRqm orderRqm = OrderRqm(
        userId: pref.user.id,
        orderItems: orderItems,
        status: 0,
        address1: '',
        address2: '',
        createOrderDate: '2022-11-23T13:18:01.329Z',
        paymentTrackingCode: '',
        phone1: '',
        phone2: '',
        postStateNumber: '',
        sendToPostDate: '',
        submitPriceDate: '2022-11-23T13:18:01.329Z',
        totalPrice: calculatedTotal());

    try {
      var result = _repo.createOrder(orderRqm);
      return result;
    } catch (e) {
      AppLogger.e('$e');
    }
  }
*/

  Future getBasket() async {
    try {
      BasketEntity rpm = await _repo.getBasket();

      return rpm;
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  Future addToCart(BasketItem item) async {
    try {
      // items.add(item);
      // if (isBusyAddToCart.value == false) {
      // isBusyAddToCart.value = true;
      await box.put(item.id, item);
      // await box.add(item);
      // isBusyAddToCart.value = false;
      // }
      // await box.add(item);
      // update();
    } catch (e) {
      AppLogger.catchLog(e);
    }
  }

  Future removeItem(BasketItem item) async {
    try {
      box.delete(item.id);
    } catch (e) {
      AppLogger.catchLog("$e");
    }
  }

  clearCart() {
    try {
      Hive.deleteBoxFromDisk(Boxes.basketBox);
    } catch (error) {
      debugPrint('$error');
    }
  }

  increase(String? productID) {
    if (productID == null) {
      return;
    }
    try {
      item = box.values.where((element) => element.id == productID).toList();

      if (item.isNotEmpty) {
        BasketItem items = item.first;
        removeItem(items);
        items.quantity++;
        update();
        addToCart(items);
      }
    } catch (e) {
      printError(info: "$e");
    }
  }

  decrease(String? productID) {
    if (productID == null) {
      return;
    }
    BasketItem item =
        box.values.singleWhere((element) => element.id == productID);
    removeItem(item);
    item.quantity--;
    if (item.quantity > 0) {
      addToCart(item);
    }
    update();
  }

  int checkItemCount(String? productID) {
    try {
      if (productID == null) {
        return 0;
      }

      item = box.values.where((element) => element.id == productID).toList();
      return item.isEmpty ? 0 : item[0].quantity;
    } catch (e) {
      return 0;
    }
  }

  int calculatedTotal() {
    int _total = 0;
    for (var element in box.values) {
      int price = element.price;
      var total = element.quantity;
      _total = _total + (price * total);
    }
    return _total;
  }

  int totalItem(String? productID) {
    try {
      int _total = 0;
      if (productID == null) {
        return 0;
      }
      BasketItem item =
          box.values.singleWhere((element) => element.id == productID);
      int price = item.price;
      var total = item.quantity;
      _total = _total + (price * total);
      return item == null ? 0 : _total;
    } catch (e) {
      return 0;
    }
  }
}
