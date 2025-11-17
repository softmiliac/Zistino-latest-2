import 'package:admin_zistino/src/common/utils/close_keyboard.dart';
import 'package:admin_zistino/src/domain/usecases/bas/driver_delivery_usecase.dart';
import 'package:admin_zistino/src/domain/usecases/pro/residue_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../data/models/base/driver_delivery_model.dart';
import '../../../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../../../data/models/inv/order_rqm.dart';
import '../../../../../data/repositories/inv/basket_repository.dart';
import '../../../../../domain/entities/base/driver_delivery.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../../../../routes/app_pages.dart';

class ResidueDeliveryController extends GetxController
    with StateMixin<List<CategoryEntity>> {
  /// Variable ///

  List<CategoryEntity>? categoryRPM;
  List<ProductEntity>? productRPM;
  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  RxBool isBusyCreateDelivery = false.obs;
  RxBool isBusyCreateOrder = false.obs;
  RxList<CategoryEntity> selectedCat = <CategoryEntity>[].obs;
  BaseResponse? result;
  RxList<TextEditingController> orderQuantity = RxList();

  // RxList<HourBox> hours = RxList<HourBox>([]);
  // Rx<List<DayBox>> days =
  //     Rx<List<DayBox>>([DayBox(date: DateTime.now(), text: 'امروز')]);
  // Rx<HourBox?> selectedHour = Rx<HourBox?>(null);
  String addressTxt = '';
  String addressInfoTxt = '';

  /// Instances ///
  TextEditingController descriptionController = TextEditingController();
  final CreateDeliveryUseCase _useCaseCreateDelivery = CreateDeliveryUseCase();
  final BasketRepositoryImpl _repo = BasketRepositoryImpl();
  final ResidueUseCase _residueUseCase = ResidueUseCase();
  final EditDeliveryUseCase _editDeliveryUseCase = EditDeliveryUseCase();
  final FetchCategoryUseCase _fetchCategoryUseCase = FetchCategoryUseCase();
  final LocalStorageService pref = Get.find();
  RxInt total = 0.obs;

  @override
  void onInit() {
    // selectedDay.value = days.value[0];
    // createDays();
    // createTimeSelection(selectedDay.value?.date.day == DateTime.now().day);
    // selectedDay.listen((dayBox) {
    //   createTimeSelection(selectedDay.value?.date.day == DateTime.now().day);
    //   // debugPrint('${hours[index].active} asasq');
    // });
    super.onInit();
  }

  int shooz = 0;

/*
  bool isShooz() {
    int inStock = 0;
    String desc = '';
    for(var b in orderItems){
      desc = b.description;
    }
    var filteredProducts = productRPM
        ?.where((element) =>
    element.categories[0].id.toString() == desc)
        .toList() ??
        [];
    for(var a in filteredProducts){
      inStock = a.inStock;
    }
    if (shooz <= inStock) {
      return true;
    } else {
      return false;
    }
  }
*/

  bool isValidTotal() {
    if (orderItems.isEmpty ||
        orderQuantity.any((element) => element.text.isEmpty) ||
        orderQuantity.any((element) => int.parse(element.text) == 0)) {
      return true;
    } else {
      return false;
    }
  }

  /// Functions ///

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
/*
  decreaseOrderItem(OrderItem orderItem, int index) {
    try {
      var filteredProducts = productRPM
          ?.where((element) =>
      element.categories[0].id.toString() == orderItem.description)
          .toList() ??
          [];

      filteredProducts.sort((a, b) => a.inStock.compareTo(b.inStock));
      int a = int.parse(orderQuantity.text);
      orderItem.itemCount = a;
      for (var product in filteredProducts) {
        if (orderItem.itemCount != 1) {
          if (orderItem.itemCount -1  <= product.inStock) {
            // orderQuantity.text = (int.parse(orderQuantity.text) - 1).toString();
            // var a = int.parse(orderQuantity.text);
            // orderItem.itemCount=a ;
            debugPrint('${orderItem.itemCount} aValueBefore');
            updateOrderItem(index, product, orderItem.itemCount + 1);
            debugPrint('${orderItem.itemCount} aValueAfter');

            return;
          } else {}
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }
*/

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
          update();
          return;
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future createOrder(int addressId, String deliveryUserId) async {
    //todo هربار نباید این فانکشن صدا زده بشه....وقتی از سرور خطا میاد مجدد درخواست ساهت اوردر ارسال میکنیم که اشتباهه
    OrderRqm orderRqm = OrderRqm(
        userId: deliveryUserId,
        orderItems: orderItems,
        status: 0,
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
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        result = await _repo.createOrder(orderRqm);
        if (result != null) {
          isBusyCreateDelivery.value = false;
          update();
          createDelivery(result?.data, addressId, deliveryUserId);
        }
        return result?.data;
      }
    } catch (e) {
      isBusyCreateDelivery.value = false;
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

  Future fetchResidueRemote() async {
    try {
      productRPM = await _residueUseCase.execute();
    } catch (e) {
      AppLogger.e('$e');
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

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

  /// Create Delivery Functions ///
  Future createDelivery(
      int orderId, int addressId, String deliveryUserId) async {
    String hour = DateTime.now().hour > 9
        ? "${DateTime.now().hour}"
        : "0${DateTime.now().hour}";

    String minutes = DateTime.now().minute > 9
        ? "${DateTime.now().minute}"
        : "0${DateTime.now().minute}";

    DriverDeliveryModel rqm = DriverDeliveryModel(
        userId: deliveryUserId,
        addressId: addressId,
        deliveryUserId: pref.user.id,
        address: 'مرکز جمع آوری پسماند زیستینو',
        description: descriptionController.text.trim(),
        status: 16,
        //todo set correct status value -> for confirm driver
        orderId: orderId,
        deliveryDate:
            '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T$hour:$minutes:00.000Z',
        zoneId: null);
    try {
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        BaseResponse response = await _useCaseCreateDelivery.execute(rqm);
        Future.delayed(Duration(seconds: 1));
        await editRequest(response.data, rqm);
        if (response.succeeded == true) {
          isBusyCreateDelivery.value = false;
          update();
          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست شما با موفقیت ثبت شد');
          Get.offAllNamed(Routes.homePage);
          descriptionController.clear();

          selectedCat.clear();
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
          message: '$e');
    }
  }

  Future editRequest(int requestId, DriverDeliveryEntity entityRqm) async {
    try {
      DriverDeliveryRQM rqm = DriverDeliveryRQM(
          id: requestId,
          userId: entityRqm.userId,
          deliveryUserId: null,
          deliveryDate: entityRqm.deliveryDate,
          setUserId: null,
          addressId: entityRqm.addressId,
          orderId: null,
          examId: entityRqm.examId,
          requestId: entityRqm.requestId,
          zoneId: null,
          status: 16,
          description: entityRqm.description);
      BaseResponse result = await _editDeliveryUseCase.execute(rqm);
      if (result.succeeded == true) {
        return result;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyCreateDelivery.value = false;
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message: '$e');
    }
  }

  clearVariablesDelivery() {
    addressInfoTxt = '';
    addressTxt = '';
    descriptionController.clear();
  }

  clearDataInCreateDelivery() {
    if (Get.isSnackbarOpen == false) {
      Get.back();
      clearVariablesDelivery();
    }
  }
}
