import 'package:zistino/src/common/utils/show_result_action.dart';
import 'package:zistino/src/data/enums/bas/theme/show_result_type.dart';
import 'package:zistino/src/data/models/inv/driver_delivery_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../data/models/base/lazy_rpm.dart';
import '../../../../../data/models/base/lazy_rqm.dart';
import '../../../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../../domain/entities/sec/order_entity.dart';
import '../../../../../domain/usecases/bas/home_usecase.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';
import '../../../../../domain/usecases/sec/orders_usecase.dart';

class HomeController extends GetxController
    with StateMixin<List<List<ProductSectionEntity>>> {

  /// Variables  ///

  List<List<ProductSectionEntity>> homeEntity = [];
  LazyRPM<DriverDeliveryModel>? deliveryData;
  LazyRPM<DriverDeliveryModel>? loadingRequestData;
  OrderEntityClient? orderResultClient;
  OrderEntityDriver? orderResultDriver;
  // int preOrderId = 0;
  int totalOrderPrice = 0;
  RxBool isBusyCredit = false.obs;
  RxBool isBusyEditAccess = false.obs;
  RxBool isBusyEditDeny = false.obs;
  RxBool isBusyDelete = false.obs;
  RxBool isBusyGetProductSec = false.obs;
  RxBool isBusyGetOrderClient = false.obs;
  RxBool isBusyGetOrderDriver = false.obs;
  RxBool isBusyGetWallet = false.obs;
  RxBool isBusyGetRequests = false.obs;
  RxBool isBusyGetLoadingRequests = false.obs;

  /// Instances ///
  final LocalStorageService pref = Get.find<LocalStorageService>();
  late PickerMapController controller;
  late MapController mapController;
  final FetchHomeUseCase _useCase = FetchHomeUseCase();
  final FetchDriverDeliveryUseCase _driverDeliveryUseCase = FetchDriverDeliveryUseCase();
  final DeleteDeliveryUseCase _deleteDeliveryUseCase = DeleteDeliveryUseCase();
  final EditDeliveryUseCase _editDeliveryUseCase = EditDeliveryUseCase();
  final DriverOrderDetailUseCase _driverOrderDetailUseCase = DriverOrderDetailUseCase();
  final ClientOrderDetailUseCase _clientOrderDetailUseCase = ClientOrderDetailUseCase();
  final WalletRepositoryImpl walletRepository = WalletRepositoryImpl();
  final TextEditingController descriptionController = TextEditingController();

  /// Functions Home//
  Future fetchHome() async {
    try {
      if (isBusyGetProductSec.isFalse) {
        isBusyGetProductSec.value = true;
        homeEntity = await _useCase.execute();
        if (homeEntity.isEmpty) {
          homeEntity = [];
          isBusyGetProductSec.value = false;
        } else {
          isBusyGetProductSec.value = false;
        }
      }
    } catch (e) {
      isBusyGetProductSec.value = false;
      AppLogger.e('$e');
      homeEntity = [];
      // change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  /// Delivery Fun ///
  Future fetchDataRequests() async {
    try {
      if (isBusyGetRequests.value == false) {
        isBusyGetRequests.value = true;
        LazyRQM rqm = LazyRQM(
            pageNumber: 1,
            pageSize: 50,
            status: 12,
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
  Future fetchLoadingRequests() async {
    try {
      if (isBusyGetLoadingRequests.value == false) {
        isBusyGetLoadingRequests.value = true;
        LazyRQM rqm = LazyRQM(
            pageNumber: 1,
            pageSize: 50,
            status: 4,
            brandId: null,
            keyword: '',
            orderBy: ['']);
        loadingRequestData = await _driverDeliveryUseCase.execute(rqm);
        isBusyGetLoadingRequests.value = false;
        update();
        return loadingRequestData;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyGetLoadingRequests.value = false;
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }
  Future deleteRequest(DriverDeliveryEntity entityRqm) async {
    try {
      if (Get.isSnackbarOpen == false) {
        isBusyDelete.value = true;
        DriverDeliveryRQM rqm = DriverDeliveryRQM(
            id: entityRqm.id,
            userId: entityRqm.userId,
            deliveryUserId: entityRqm.deliveryUserId!.isEmpty
                ? null
                : entityRqm.deliveryUserId,
            deliveryDate: entityRqm.deliveryDate,
            setUserId: null,
            vatNumber: entityRqm.vatNumber,
            addressId: entityRqm.addressId,
            orderId: null,
            examId: entityRqm.examId,
            requestId: entityRqm.requestId,
            zoneId: entityRqm.zoneId,
            status: 11,
            description: descriptionController.text);
        BaseResponse result = await _deleteDeliveryUseCase.execute(rqm);
        if (result.succeeded == true) {
          isBusyDelete.value = false;
          Get.back();
          Future.delayed(const Duration(milliseconds: 100));
          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست جمع آوری شما با موفقیت لغو شد');
          descriptionController.clear();
          update();
          fetchDataRequests();
          return result;
        }
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyDelete.value = false;
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message: ExceptionConstants.serverError);
    }
  }
  Future editRequest(DriverDeliveryEntity entityRqm, int requestStatus) async {
    try {
      if (isBusyEditDeny.value == false || isBusyEditDeny.value == false) {
        requestStatus == 9
            ? isBusyEditAccess.value = true
            : isBusyEditDeny.value = true;
        DriverDeliveryRQM rqm = DriverDeliveryRQM(
            id: entityRqm.id,
            userId: entityRqm.userId,
            deliveryUserId: entityRqm.deliveryUserId!.isEmpty
                ? null
                : entityRqm.deliveryUserId,
            vatNumber: entityRqm.vatNumber,
            deliveryDate: entityRqm.deliveryDate,
            setUserId: null,
            addressId: entityRqm.addressId,
            orderId: entityRqm.orderId,
            examId: entityRqm.examId,
            requestId: entityRqm.requestId,
            zoneId: null,
            preOrderId: entityRqm.orderId,
            status: requestStatus,
            description: entityRqm.description);
        BaseResponse result = await _editDeliveryUseCase.execute(rqm);
        requestStatus == 9
            ? isBusyEditAccess.value = false
            : isBusyEditDeny.value = false;
        if (result.succeeded == true) {
          Get.back();
          Future.delayed(const Duration(milliseconds: 5));
          update();
          if (requestStatus == 9) {
            transactionWalletRequest(totalOrderPrice);
          }
          fetchDataRequests();
          fetchLoadingRequests();
          return result;
        }
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyEditAccess.value = false;
      isBusyEditDeny.value = false;
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message: ExceptionConstants.serverError);
    }
  }

  /// Transaction Fun ///
  Future transactionWalletRequest(int totalPrice) async {
    try {
      // if (isBusyRequest.value == false) {
      isBusyCredit.value = true;
      update();
      TransactionWalletRQM rqm = TransactionWalletRQM(
          userId: pref.user.id,
          senderId: null,
          type: 1,
          status: 1,
          price: totalPrice,
          coin: null,
          exchangeRate: 1,
          finished: true);
      BaseResponse result = await walletRepository.transactionWallet(rqm);
      // await createOrder();
      isBusyCredit.value = false;
      update();
      await walletRepository.getUserTotal();
      update();
      return result;
    } catch (e) {
      isBusyCredit.value = false;
      update();
      AppLogger.catchLog(e);
      showTheResult(
          title: "خطـا",
          message: ExceptionConstants.serverError,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
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

  /// Order Fun ///
  Future fetchOrderClient(int preOrderId) async {
    try {
      if (isBusyGetOrderClient.value == false) {
        isBusyGetOrderClient.value = true;
        orderResultClient = await _clientOrderDetailUseCase.execute(preOrderId);

        isBusyGetOrderClient.value = false;
        return orderResultClient;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyGetOrderClient.value = false;
      rethrow;
    }
  }
  Future fetchOrderDriver(int orderId) async {
    try {
      if (isBusyGetOrderDriver.value == false) {
        isBusyGetOrderDriver.value = true;
        orderResultDriver = await _driverOrderDetailUseCase.execute(orderId);
        isBusyGetOrderDriver.value = false;
        return orderResultDriver;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyGetOrderDriver.value = false;
      rethrow;
    }
  }

  /// TimeFormatter Fun ///
  String timeFormat(DriverDeliveryEntity entity) {
    DateTime timeOrder = DateTime.parse(entity.deliveryDate ?? '');
    String time = DateFormat('HH : mm').format(timeOrder);
    return time;
  }
  String dateFormat(DriverDeliveryEntity entity) {
    Jalali jalali =
    DateTime.parse(entity.deliveryDate?.replaceAll('T', ' ') ?? '')
        .toJalali();
    String date =
        '${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}';
    return date;
  }

  /// Refresh Fun ///
  Future<void> refreshData() {
    try {
      fetchHome();
      fetchLoadingRequests();
      return fetchDataRequests();
    } catch (e) {
      AppLogger.catchLog(e);
      showTheResult(
          title: "خطـا",
          message: ExceptionConstants.serverError,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }
}
