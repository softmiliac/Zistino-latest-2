import 'package:zistino/src/data/models/base/base_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:zistino/src/domain/usecases/sec/user_usecase.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../../../data/models/inv/driver_delivery_model.dart';
import '../../../../../data/models/inv/order_rqm.dart';
import '../../../../../data/repositories/inv/basket_repository.dart';
import '../../../../../domain/entities/inv/time_box.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/entities/sec/user_zone.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';
import '../../../../../domain/usecases/pro/product_usecase.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';
import '../../../map_page/controller/map_controller.dart';

class ResidueDeliveryController extends GetxController
    with StateMixin<List<CategoryEntity>> {
  ResidueDeliveryController(this._residueUseCase, this._fetchCategoryUseCase,
      this._useCaseCreateDelivery);

  /// Variable ///
  Rx<HourBox?> selectedHour = Rx<HourBox?>(null);
  List<CategoryEntity>? categoryRPM;
  List<ProductEntity>? productRPM;
  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  RxBool isBusyCreateDelivery = false.obs;
  RxBool isBusyCreateOrder = false.obs;
  RxList<CategoryEntity> selectedCat = <CategoryEntity>[].obs;
  BaseResponse? result;
  RxList<HourBox> hours = RxList<HourBox>([]);
  Rx<List<DayBox>> days =
      Rx<List<DayBox>>([DayBox(date: DateTime.now(), text: 'امروز')]);
  RxString addressTxt = ''.obs;
  RxString addressInfoTxt = ''.obs;
  TextEditingController descriptionController = TextEditingController();
  Rx<DayBox?> selectedDay = Rx<DayBox?>(null);

  /// Instances ///
  final CreateDeliveryUseCase _useCaseCreateDelivery;
  final BasketRepositoryImpl _repo = BasketRepositoryImpl();
  final MyMapController myMapController = Get.find();
  final ResidueUseCase _residueUseCase;
  final FetchCategoryUseCase _fetchCategoryUseCase;
  final SearchUserInZoneUseCase _userInZoneUseCase = SearchUserInZoneUseCase();
  final EditDeliveryUseCase _editDeliveryUseCase = EditDeliveryUseCase();
  final LocalStorageService pref = Get.find();
  final MainPageController mainPageController = Get.find();
  RxInt total = 0.obs;
  RxList<TextEditingController> orderQuantity = RxList();

  @override
  void onInit() {
    selectedDay.value = days.value[0];
    createDays();
    createTimeSelection(selectedDay.value?.date.day == DateTime.now().day);
    selectedDay.listen((dayBox) {
      createTimeSelection(selectedDay.value?.date.day == DateTime.now().day);
      // debugPrint('${hours[index].active} asasq');
    });
    super.onInit();
  }

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

  Future createOrder(int addressId) async {
    OrderRqm orderRqm = OrderRqm(
        userId: pref.user.id,
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
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        result = await _repo.createOrder(orderRqm);
        if (result != null) {
          isBusyCreateDelivery.value = false;
          update();
          createDelivery(
              result?.data, myMapController.result?.data ?? addressId);
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
        await fetchResidueRemote();
        change(categoryRPM, status: RxStatus.success());
      }
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future fetchUserInZon(
      DriverDeliveryModel rqm, int deliveryId, int zoneId) async {
    try {
      List<UserZoneEntity> rpm = await _userInZoneUseCase.execute(zoneId);
      if (rpm.length <= 1) {
        // todo
        await connectToDriver(rqm, deliveryId, rpm[0].userId);
      }
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future connectToDriver(DriverDeliveryModel entityRqm, int deliveryId,
      String driverUserId) async {
    try {
      DriverDeliveryRQM rqm = DriverDeliveryRQM(
          id: deliveryId,
          userId: entityRqm.userId,
          deliveryUserId: driverUserId,
          deliveryDate: entityRqm.deliveryDate,
          setUserId: null,
          addressId: entityRqm.addressId,
          orderId: entityRqm.orderId,
          examId: entityRqm.examId,
          requestId: entityRqm.requestId,
          zoneId: null,
          preOrderId: entityRqm.preOrderId,
          status: 2,
          description: entityRqm.description);
      BaseResponse result = await _editDeliveryUseCase.execute(rqm);
      return result;
    } catch (e) {
      AppLogger.e('$e');
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message: ExceptionConstants.serverError);
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

  /// Create Delivery Functions ///
  Future createDelivery(int orderId, int addressId) async {
    String hour = DateFormat('HH').format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedHour.value?.start ?? 8));
    DriverDeliveryModel rqm = DriverDeliveryModel(
        userId: pref.user.id,
        addressId: myMapController.result?.data ?? addressId,
        address:
            '${myMapController.addressTxt.value}، ${myMapController.addressInfoTxt.value}',
        description: descriptionController.text.trim(),
        status: 0,
        preOrderId: orderId,
        deliveryDate:
            '${DateFormat('yyyy-MM-dd').format(selectedDay.value?.date ?? DateTime.now())}T$hour:00:00.000Z',
        zoneId: myMapController.idZone);
    try {
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        BaseResponse response = await _useCaseCreateDelivery.execute(rqm);
        await fetchUserInZon(rqm, response.data, rqm.zoneId ?? 0);
        isBusyCreateDelivery.value = false;
        update();
        showTheResult(
            resultType: SnackbarType.success,
            showTheResultType: ShowTheResultType.snackBar,
            title: 'موفقیت',
            message: 'درخواست شما با موفقیت ثبت شد');
        mainPageController.selectedIndex.value = 0;
        Get.offAll(const MainPage());
        descriptionController.clear();
        selectedDay.value = days.value[0];
        selectedHour.value = null;
        selectedCat.clear();
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
          message: ExceptionConstants.serverError);
      rethrow;
    }
  }

  /// Add & Update Addresses Requests ///

  /// Time Format ///

  createDays() {
    try {
      Jalali nowJalali = Jalali.now();
      for (int i = 1; i < 10; i++) {
        Jalali dateTime = nowJalali.addDays(i);

        int day = dateTime.day;
        String month = dateTime.formatter.mN;
        String dayOfWeek = dateTime.formatter.wN;

        days.value.add(DayBox(
            date: dateTime.toDateTime(), text: "$dayOfWeek $day $month"));
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  clearVariablesDelivery() {
    addressInfoTxt.value = '';
    addressTxt.value = '';
    descriptionController.clear();
    selectedDay.value = days.value[0];
    selectedHour.value = null;
  }

  clearDataInCreateDelivery() {
    if (Get.isSnackbarOpen == false) {
      Get.back();
      clearVariablesDelivery();
    }
  }

  createTimeSelection(bool isToday) {
    try {
      int from = int.parse(pref.getConfig.value?.start ?? '8');
      int until = int.parse(pref.getConfig.value?.end ?? '20');
      int step = int.parse(pref.getConfig.value?.split ?? '3');

      List<HourBox> _hours = [];

      for (int i = from; i < until; i = i + step) {
        int end = i + step;
        if (i + step >= until) {
          end = until;
        }

        HourBox hour =
            HourBox(start: i, end: end, text: "$i تا $end", active: isToday);
        hour = _activeChecker(hour, isToday);

        _hours.add(hour);
      }
      // debugPrint("$hours");

      hours.value = _hours;
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  HourBox _activeChecker(HourBox item, bool isToday) {
    // int now = DateTime.now().hour;
    int now = DateTime.now().hour;

    if (isToday) {
      if (item.start <= now && now < item.end) {
        item.text = "اکنون";

        debugPrint(
            "b out:  start:${item.start} , end:${item.end} ,text:${item.text}  ,${item.active}");
        return item;
      }
      if (item.start < now) {
        item.active = false;

        debugPrint(
            "a out:   start:${item.start} , end:${item.end} ,text:${item.text}  ,${item.active}");
        return item;
      }
    } else {
      item.active = true;

      debugPrint(
          "c out:  start:${item.start} , end:${item.end} ,text:${item.text}  ,${item.active}");
      return item;
    }
    // }
    debugPrint(
        "d out:   start:${item.start} , end:${item.end} ,text:${item.text}  ,${item.active}");
    return item;
  }
}
