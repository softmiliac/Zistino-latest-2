// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../../domain/entities/sec/order_entity.dart';
import '../../../../../domain/usecases/sec/orders_usecase.dart';

class RequestDetailController extends GetxController
    with StateMixin<OrderEntity> {
  RequestDetailController(this._useCase);

  final LocalStorageService pref = Get.find<LocalStorageService>();

  /// Variables  ///
  OrderEntity? result;
  int? orderID;
  // late PickerMapController controller;
  // late MapController mapController;

  /// Instances ///
  final OrderDetailUseCase _useCase;

  /// Methods //

  String timeFormat(DriverDeliveryEntity entity) {
    DateTime timeOrder = DateTime.parse(entity.createdOn);
    String time = DateFormat('hh : mm').format(timeOrder);
    return time;
  }

  String dateFormat(DriverDeliveryEntity entity) {
    Jalali jalali =
    DateTime.parse(entity.createdOn.replaceAll('T', ' ')).toJalali();
    String date =
        '${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}';
    return date;
  }

  Future fetchOrder() async {
    try {
      change(null, status: RxStatus.loading());
      result = await _useCase.execute(orderID);
      change(result, status: RxStatus.success());
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      rethrow;
    }
  }

  @override
  void onInit() {

    super.onInit();
    fetchOrder();
  }
}
