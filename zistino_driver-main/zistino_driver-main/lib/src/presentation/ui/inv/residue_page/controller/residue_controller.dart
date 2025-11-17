import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recycling_machine/src/data/models/base/base_response.dart';
import 'package:recycling_machine/src/data/models/pro/order_rqm.dart';
import 'package:recycling_machine/src/presentation/ui/base/main_page/controller/main_controller.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/driver_delivery_model.dart';
import '../../../../../data/models/inv/order_rqm.dart';
import '../../../../../data/repositories/inv/basket_repository.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../../../../../domain/usecases/bas/driver_delivery_usecase.dart';
import '../../../../../domain/usecases/pro/residue_usecase.dart';
import '../../../base/main_page/view/main_page.dart';

class ResidueController extends GetxController
    with StateMixin<List<CategoryEntity>> {
  ResidueController(this._residueUseCase, this._fetchCategoryUseCase);

  /// Variable ///

  List<CategoryEntity>? categoryRPM;
  List<ProductEntity>? productRPM;
  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  RxBool isBusyCreateDelivery = false.obs;
  RxBool isBusyCreateOrder = false.obs;
  RxList<CategoryEntity> selectedCat = <CategoryEntity>[].obs;
  BaseResponse? result;

  /// Instances ///
  final EditDeliveryUseCase _editDeliveryUseCase = EditDeliveryUseCase();
  final BasketRepositoryImpl _repo = BasketRepositoryImpl();
  RxList<TextEditingController> orderQuantity = RxList();

  final ResidueUseCase _residueUseCase;
  final FetchCategoryUseCase _fetchCategoryUseCase;
  final LocalStorageService pref = Get.find();
  final MainPageController mainPageController = Get.find();
  RxInt total = 0.obs;

  /// Functions ///
  bool isValidTotal() {
    if (orderItems.isEmpty ||
        orderQuantity.any((element) => element.text.isEmpty) ||
        orderQuantity.any((element) => int.parse(element.text) == 0)) {
      return true;
    } else {
      return false;
    }
  }
  updateTextField(OrderItem orderItem, int index) {
    var filteredProducts = productRPM
        ?.where((element) =>
    element.categories[0].id.toString() == orderItem.description)
        .toList() ??
        [];
    for (var product in filteredProducts) {
      if (orderItem.itemCount + 1 <= product.inStock) {
        updateOrderItem(index, product, orderItem.itemCount);
        return;
      }
    }
  }


  increaseOrderItem(OrderItem orderItem, int index) {
    try {
      var filteredProducts = productRPM
          ?.where((element) =>
      element.categories[0].id.toString() == orderItem.description)
          .toList() ??
          [];

      filteredProducts.sort((a, b) => a.inStock.compareTo(b.inStock));
      for (var product in filteredProducts) {
        if (orderItem.itemCount + 1 <= product.inStock) {
          // todo ask from Mr.Aslami
          orderQuantity[index].text =
              (int.parse(orderQuantity[index].text) + 1).toString();
          var a = int.parse(orderQuantity[index].text);
          updateOrderItem(index, product, a + 1);
          return;
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  decreaseOrderItem(OrderItem orderItem, int index) {
    try {
      var filteredProducts = productRPM
          ?.where((element) =>
      element.categories[0].id.toString() == orderItem.description)
          .toList() ??
          [];

      filteredProducts.sort((a, b) => a.inStock.compareTo(b.inStock));
      if (orderQuantity[index].text != '1') {
        orderQuantity[index].text =
            (int.parse(orderQuantity[index].text) - 1).toString();
      }
      var a = int.parse(orderQuantity[index].text);
      orderItem.itemCount = a;
      for (var product in filteredProducts) {
        debugPrint('$a val');
        if (a > 1) {
          if (a - 1 <= product.inStock) {
            updateOrderItem(index, product, a - 1);
            return;
          } else {}
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
  addToOrderItem(CategoryEntity category) {
    try {
      int quantity = getOrderItemQuantity(category.id.toString());
      update();

      var filteredProducts = productRPM
          ?.where((element) => element.categories[0].id == category.id)
          .toList() ??
          [];

      filteredProducts.sort((a, b) => a.inStock.compareTo(b.inStock));

      for (var product in filteredProducts) {
        if (quantity <= product.inStock) {
          addToOrder(product, quantity + 1);
          orderQuantity.add(TextEditingController(text: '1'));
          update();
          return;
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  // decreaseOrderItem(CategoryEntity entity) {
  //   quantity.value--;
  //   if (quantity.value == 0) {
  //     selectedCat.remove(entity);
  //     update();
  //   }
  // }
  Future editDelivery(DriverDeliveryModel model, ) async {
    DriverDeliveryModel rqm = DriverDeliveryModel(
        userId: model.userId,
        id: model.id,
        deliveryUserId: pref.user.id,
        vatNumber: model.vatNumber,
        preOrderId: model.preOrderId,
        status: 4,
        orderId: model.orderId,
        // '2022-11-15T07:52:07.716Z',
        deliveryDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm:ss').format(DateTime.now())}.000Z',
        addressId: model.addressId,
        examId: 0,
        requestId: 0,
        phoneNumber: model.phoneNumber,
        address: model.address,
        creator: model.creator,
        latitude: model.latitude,
        longitude: model.longitude,
        zoneId: model.zoneId);
    try {
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        BaseResponse response = await _editDeliveryUseCase.execute(rqm);
        isBusyCreateDelivery.value = false;
        update();
        if (response.succeeded == true) {
          selectedCat.clear();

          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست شما با موفقیت ثبت شد');
          Get.offAll(MainPage(
            selectedIndex: mainPageController.selectedIndex.value = 0,
          ));
        }
        return response;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyCreateDelivery.value = false;
      update();
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message:ExceptionConstants.serverError);
    }
  }

  Future createOrder(DriverDeliveryModel modelRqm,
      // int addressId, int id,String userId
      ) async {
    OrderRqm orderRqm = OrderRqm(
        userId: modelRqm.userId,
        orderItems: orderItems,
        status: 2,
        address1: '',
        address2: '',
        createOrderDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('hh:mm:ss').format(DateTime.now())}.${DateTime.now().millisecond}Z',
        paymentTrackingCode: '',
        phone1: '',
        phone2: '',
        postStateNumber: '',
        sendToPostDate: '',
        submitPriceDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('hh:mm:ss').format(DateTime.now())}.${DateTime.now().millisecond}Z',
        totalPrice: total.value);

    try {
      if (isBusyCreateOrder.value == false) {
        isBusyCreateOrder.value = true;
        update();
        var result = await _repo.createOrder(orderRqm);
        modelRqm.orderId = result;
        update();
        await editDelivery(modelRqm);
        isBusyCreateOrder.value = false;
        update();

        return result;
      }
    } catch (e) {
      isBusyCreateOrder.value = false;
      update();
      AppLogger.e('$e');
    }
  }

  createOrderItems() {
    orderItems.clear();

    for (var category in selectedCat) {
      addToOrderItem(category);
    }
  }

  addToOrder(ProductEntity product, int quantity) {
    try {
      var catId = product.categories[0].id.toString();

      orderItems.removeWhere((element) => element.description == catId);

      OrderItem newItem = OrderItem(
          itemCount: quantity,
          productId: product.id,
          description: catId,
          status: 0,
          unitPrice: product.masterPrice ?? 0);

      orderItems.add(newItem);
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  updateOrderItem(int index, ProductEntity product, int quantity) {
    try {
      orderItems[index] = OrderItem(
          itemCount: quantity,
          productId: product.id,
          description: orderItems[index].description,
          status: 0,
          unitPrice: product.masterPrice ?? 0);

      // orderItems.add(newItem);
    } catch (e) {
      AppLogger.e('$e');
    }
  }


  RxInt totalOrderPrice() {
    try {
      int _total = 0;
      int a = 1;
      for (int index = 0; index < orderItems.length; index++) {
        if (orderQuantity[index].text.isEmpty) {
          orderQuantity[index].text = '1';
        } else {
          a = int.parse(orderQuantity[index].text);
        }
        orderItems[index].itemCount = 1;
        int price = a * orderItems[index].unitPrice;
        _total = _total + price;
      }
      // for (var element in orderItems) {
      //   element.itemCount = 1;
      //   int price = a * element.unitPrice;
      //   _total = _total + price;
      // }
      total.value = _total;
      return total;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  int totalItemPrice(OrderItem item, {required int index}) {
    try {
      int a = 1;
      if (orderQuantity[index].text.isEmpty) {
        orderQuantity[index].text = '1';
      } else {
        a = int.parse(orderQuantity[index].text);
      }

      item.itemCount = a;
      return (a * item.unitPrice);
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  int getOrderItemQuantity(String categoryId) {
    try {
      int a = orderItems
          .firstWhere((element) => element.description == categoryId)
          .itemCount;
      return a;
    } catch (e) {
      return 0;
    }
  }

  Future fetchResidue(int id) async {
    try {
      productRPM?.where((element) => element.id == id.toString());
    } catch (e) {
      AppLogger.e('$e');
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

/*  changeResidueState(int index) {
    try {
      var isStock = isItemSelected(index);
      if (!isStock) {
        _selectResidue(productRPM?[index]);
      } else {
        _deselectResidue(index);
      }
    } catch (e) {
      AppLogger.e("$e");
    }
  }
*/

  changeCatState(int index) {
    try {
      var isStock = isSelectedCategory(index);
      if (!isStock) {
        _selectCat(categoryRPM?[index]);
      } else {
        _deselectCat(categoryRPM?[index]);
      }
    } catch (e) {
      AppLogger.e("$e");
    }
  }

  addToLocalCatList(int index) {
    try {
      var inSelected = selectedCat
          .where((element) => element.id == categoryRPM?[index].id)
          .toList();
      return inSelected.isNotEmpty;
    } catch (e) {
      AppLogger.e('$e');
      return false;
    }
  }

  Future fetchCategories() async {
    try {
      change(null, status: RxStatus.loading());
      categoryRPM = await _fetchCategoryUseCase.execute();
      if (categoryRPM?.isEmpty ?? false) {
        change([], status: RxStatus.empty());
      } else {
        change(categoryRPM, status: RxStatus.success());
      }
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future fetchResidueRemote() async {
    try {
      productRPM = await _residueUseCase.execute();
    } catch (e) {
      AppLogger.e('$e');
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  bool isSelectedCategory(int index) {
    try {
      var inSelected = selectedCat
          .where((element) => element.id == categoryRPM?[index].id)
          .toList();
      return inSelected.isNotEmpty;
    } catch (e) {
      AppLogger.e(e.toString());
      return false;
    }
  }

/*
  bool isItemSelected(int index) {
    try {
      var inSelected = selectedResidue
          .where((element) => element.id == productRPM?[index].id)
          .toList();
      return inSelected.isNotEmpty;
    } catch (e) {
      AppLogger.e(e.toString());
      return false;
    }
  }
*/

  _selectCat(CategoryEntity? categoryEntity) {
    if (categoryEntity != null) {
      selectedCat.add(categoryEntity);
    }
  }

  void _deselectCat(CategoryEntity? categoryEntity) {
    selectedCat.remove(categoryEntity);
    update();
  }

  CategoryEntity getCategoryById(String id) =>
      selectedCat.firstWhere((element) => element.id.toString() == id);
}
