import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../common/services/get_storage_service.dart';
import '../../../../common/utils/app_logger.dart';
import '../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../common/utils/show_result_action.dart';
import '../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../data/models/base/base_response.dart';
import '../../../../data/models/inv/order_rqm.dart';
import '../../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../../../data/repositories/inv/basket_repository.dart';
import '../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../domain/entities/inv/basket.dart';
import '../../../../domain/entities/inv/basket_item.dart';
import '../success_payment_page/page/success_payment_page.dart';

class BasketController extends GetxController {
  /// Variables ///
  var itemTotal = 10.obs;
  var isBusyAddToCart = false.obs;
  RxInt selectedGateway = RxInt(-1);
  WalletRepositoryImpl walletRepository = WalletRepositoryImpl();
  RxBool isBusyRequest = false.obs;

  /// Instances ///
  final BasketRepositoryImpl _repo = BasketRepositoryImpl();
  Box<BasketItem> box = Boxes.getBasketBox();
  final LocalStorageService pref = Get.find();
  List<BasketItem> item = <BasketItem>[];
  List<OrderItem> orderItems = [];

  List<OrderItem> order() {
    for (var element in box.values) {
      orderItems.add(OrderItem(
          status: 0,
          description: '',
          itemCount: 10,
          productId: element.id,
          unitDiscountPrice: element.discountPercent,
          unitPrice: element.price));
    }

    return orderItems;
  }

  @override
  void onInit() async {
    box.values;
    // getItems();
    super.onInit();
  }

  /// Functions ///

  Future createOrder() async {
    isBusyRequest.value = true;

    OrderRqm orderRqm = OrderRqm(
        userId: pref.user.id,
        orderItems: order(),
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
      var result = await _repo.createOrder(orderRqm);
      if(selectedGateway.value == 1){
        await transactionWalletRequest();
      }
      isBusyRequest.value = false;
      return result;
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  Future transactionWalletRequest() async {
    try {
      // if (isBusyRequest.value == false) {
      isBusyRequest.value = true;
      update();
      TransactionWalletRQM rqm = TransactionWalletRQM(
          userId: pref.user.id,
          senderId: null,
          type: 0,
          price: -calculatedTotal(),
          coin: null,
          exchangeRate: 1,
          finished: false);
      BaseResponse result = await walletRepository.transactionWallet(rqm);
      // await createOrder();
      isBusyRequest.value = false;
      update();

      if (result.succeeded == true) {
        Get.off(SuccessPaymentPage());
        showTheResult(
            title: "موفقیت".tr,
            message: 'پرداخت با موفقیت انجام شد',
            resultType: SnackbarType.success,
            showTheResultType: ShowTheResultType.snackBar);
      }
      await walletRepository.getUserTotal();
      update();
      return result;
    } catch (e) {
      // List<String> messages = [];
      isBusyRequest.value = false;
      update();
      AppLogger.catchLog(e);
      showTheResult(
          title: "خطـا",
          message: '$e',
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }

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
}
