import 'package:admin_dashboard/src/common/utils/show_result_action.dart';
import 'package:admin_dashboard/src/data/enums/bas/theme/show_result_type.dart';
import 'package:admin_dashboard/src/data/models/inv/driver_delivery_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../data/models/base/lazy_rpm.dart';
import '../../../../../data/models/base/lazy_rqm.dart';
import '../../../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../../domain/usecases/bas/home_usecase.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';

class HomeController extends GetxController
    with StateMixin<List<List<ProductSectionEntity>>> {
  HomeController(
      this._useCase, this._driverDeliveryUseCase, this._deleteDeliveryUseCase);

  final LocalStorageService pref = Get.find<LocalStorageService>();

  /// Variables  ///
  // late PickerMapController controller;
  // late MapController mapController;//todo map in web
  List<List<ProductSectionEntity>>? homeEntity;
  LazyRPM<DriverDeliveryModel>? deliveryData;
  RxBool isBusyDelete = false.obs;
  RxBool isBusyGetWallet = false.obs;
  RxBool isBusyGetRequests = false.obs;

  /// Instances ///

  final FetchHomeUseCase _useCase;
  final FetchDriverDeliveryUseCase _driverDeliveryUseCase;
  final DeleteDeliveryUseCase _deleteDeliveryUseCase;
  WalletRepositoryImpl walletRepository = WalletRepositoryImpl();
  TextEditingController descriptionController = TextEditingController();

  /// Methods //


  String timeFormat(DriverDeliveryEntity entity) {
    DateTime timeOrder = DateTime.parse(entity.createdOn);
    String time = '${timeOrder.hour} : ${timeOrder.minute}';
    return time;
  }

  String dateFormat(DriverDeliveryEntity entity) {
    Jalali jalali =
        DateTime.parse(entity.createdOn.replaceAll('T', ' ')).toJalali();
    String date =
        '${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}';
    return date;
  }

  Future fetchHome() async {
    try {
      change(null, status: RxStatus.loading());
      homeEntity = await _useCase.execute();
      if (homeEntity!.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(homeEntity, status: RxStatus.success());
      }
    } catch (e) {
      AppLogger.e('$e');
      // change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future getUserWallet() async {
    try {
      isBusyGetWallet.value = true;
      await walletRepository.getUserTotal();
      isBusyGetWallet.value = false;
    } catch (e) {
      AppLogger.e('$e');
      isBusyGetWallet.value = false;
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future fetchData() async {
    try {
      if (isBusyGetRequests.value == false) {
        isBusyGetRequests.value = true;
        LazyRQM rqm = LazyRQM(
            pageNumber: 1,
            pageSize: 50,
            status: 2,
            brandId: null,
            keyword: '',
            orderBy: ['']);
        deliveryData = await _driverDeliveryUseCase.execute(rqm);
        isBusyGetRequests.value = false;
        update();
        return deliveryData;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyGetRequests.value = false;
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future deleteRequest(DriverDeliveryEntity entityRqm) async {
    try {
      if(Get.isSnackbarOpen == false){
        DeleteDriverDeliveryRQM rqm = DeleteDriverDeliveryRQM(
            id: entityRqm.id,
            userId: entityRqm.userId,
            deliveryUserId: entityRqm.deliveryUserId!.isEmpty
                ? null
                : entityRqm.deliveryUserId,
            deliveryDate: entityRqm.createdOn,
            //todo set delivery date
            setUserId: null,
            addressId: entityRqm.addressId,
            orderId: null,
            examId: entityRqm.examId,
            requestId: entityRqm.requestId,
            zoneId: entityRqm.zoneId,
            status: 3,
            description: descriptionController.text);
        BaseResponse result = await _deleteDeliveryUseCase.execute(rqm);
        if (result.succeeded == true) {
          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست جمع آوری شما با موفقیت لغو شد');
          descriptionController.clear();
          update();
          fetchData();
          return result;
        }
      }
    } catch (e) {
      AppLogger.e('$e');
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message: '$e');
    }
  }


  @override
  void onInit() {
    super.onInit();
    // controller = PickerMapController(
      // // initPosition:GeoPoint(latitude: 34,longitude: 36),
      // initMapWithUserPosition: true,
    // );//todo map in web
    fetchHome();
    fetchData();
  }


// RxInt selected = RxInt(0);
// RxInt count = 0.obs;
//
// void decrease() {
//   if (count.value == 0) {
//     count.value = 0;
//   } else {
//     count.value--;
//   }
//   update();
// }
//
// void increase() {
//   count.value++;
//   update();
// }

}
