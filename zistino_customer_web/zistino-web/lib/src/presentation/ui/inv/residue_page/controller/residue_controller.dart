import 'package:admin_dashboard/src/data/models/base/base_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/inv/driver_delivery_model.dart';
import '../../../../../data/models/inv/order_rqm.dart';
import '../../../../../data/repositories/inv/basket_repository.dart';
import '../../../../../domain/entities/inv/time_box.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';

import '../../../../../domain/usecases/inv/delivery_usecase.dart';
import '../../../../../domain/usecases/pro/product_usecase.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';

class ResidueDeliveryController extends GetxController
    with StateMixin<List<CategoryEntity>> {
  ResidueDeliveryController(this._residueUseCase, this._fetchCategoryUseCase,this._useCaseCreateDelivery);

  /// Variable ///

  Rx<HourBox?> selectedHour = Rx<HourBox?>(null);
  List<CategoryEntity>? categoryRPM;
  List<ProductEntity>? productRPM;
  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  RxBool isBusyCreateDelivery = false.obs;
  RxBool isBusyCreateOrder = false.obs;
  RxList<CategoryEntity> selectedCat = <CategoryEntity>[].obs;
  BaseResponse? result ;
  RxList<HourBox> hours = RxList<HourBox>([]);
  Rx<List<DayBox>> days = Rx<List<DayBox>>([DayBox(date: DateTime.now(), text: 'امروز')]);
  RxString addressTxt = ''.obs;
  RxString addressInfoTxt = ''.obs;
  TextEditingController descriptionController = TextEditingController();
  Rx<DayBox?> selectedDay =
  Rx<DayBox?>(null);

  /// Instances ///
  final CreateDeliveryUseCase _useCaseCreateDelivery;
  final BasketRepositoryImpl _repo = BasketRepositoryImpl();

  final ResidueUseCase _residueUseCase;
  final FetchCategoryUseCase _fetchCategoryUseCase;
  final LocalStorageService pref = Get.find();
  final MainPageController mainPageController = Get.find();
  RxInt total = 0.obs;

  @override
  void onInit() {
    fetchCategories();
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
          _updateOrderItem(index, product, orderItem.itemCount + 1);
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

      for (var product in filteredProducts) {
        if (orderItem.itemCount != 1) {
          if (orderItem.itemCount - 1 <= product.inStock) {
            _updateOrderItem(index, product, orderItem.itemCount - 1);
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
  Future createOrder(int addressId)async{

    OrderRqm orderRqm = OrderRqm(
        userId: pref.user.id,
        orderItems: orderItems ,
        status:0 ,
        address1:'' ,
        address2: '',
        createOrderDate:'2022-11-23T13:18:01.329Z' ,
        paymentTrackingCode:'' ,
        phone1: '',
        phone2:'' ,
        postStateNumber:'' ,
        sendToPostDate: '',
        submitPriceDate:'2022-11-23T13:18:01.329Z' ,
        totalPrice: total.value
    );
    try{
      if (isBusyCreateOrder.value == false) {
        isBusyCreateOrder.value = true;
        update();
         result = await _repo.createOrder(orderRqm);
        if (result != null) {
          isBusyCreateOrder.value = false;
          update();
        }
        return result?.data;
      }
    }catch(e){
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

  _updateOrderItem(int index, ProductEntity product, int quantity) {
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
    int _total = 0;
    for (var element in orderItems) {
      int price = element.itemCount * element.unitPrice;
      _total = _total + price;
    }
    total.value = _total;
    return total;
  }

  int totalItemPrice(OrderItem item) {
    return item.itemCount * item.unitPrice;
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
  Future createDelivery(int orderId,int addressId) async {
    DriverDeliveryModel rqm = DriverDeliveryModel(
        userId: pref.user.id,
        addressId: result?.data ?? addressId,
        address: addressTxt.value + addressInfoTxt.value,
        description: descriptionController.text,
        status: 2,
        preOrderId: orderId,
        deliveryDate:
        '${DateFormat('yyyy-MM-dd').format(selectedDay.value?.date ?? DateTime.now())}T${selectedHour.value?.start ?? 0}:00:00.000Z',
        // deliveryUserId:nu
        // 3ll ,
        // examId: null,
        // requestId:null ,
        // setUserId: null,
        zoneId: null);
    try {
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        bool response = await _useCaseCreateDelivery.execute(rqm);
        isBusyCreateDelivery.value = false;
        update();
        if (response == true) {
          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست شما با موفقیت ثبت شد');
          Get.offAll(MainPage(
            selectedIndex: mainPageController.selectedIndex.value = 0,
          ));
          selectedDay.value = days.value[0];
          selectedHour.value = null;
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

  createTimeSelection(bool isToday) {
    int from = 10;
    int until = 20;
    int step = 3;

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
