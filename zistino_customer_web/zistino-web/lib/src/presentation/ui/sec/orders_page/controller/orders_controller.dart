import 'package:get/get.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/models/base/lazy_rpm.dart';
import '../../../../../data/models/base/lazy_rqm.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';

class OrdersController extends GetxController with StateMixin<LazyRPM<DriverDeliveryEntity>> {
  OrdersController(this._driverDeliveryUseCase);

  /// Variables ///
  RxInt orderingCount = 1.obs;
  final currentIndex = 0.obs;

  /// Instances ///
  final FetchDriverDeliveryUseCase _driverDeliveryUseCase;
  LazyRPM<DriverDeliveryEntity>? deliveryData;

  @override
  void onInit() {
    fetchData();
  }

  Future fetchData() async {
    try {

      var _status;

      if (currentIndex.value == 0) {
        _status = 2;
      } else if(currentIndex.value == 1) {
        _status = 5;
      }else if(currentIndex.value == 2){
        _status = 3;
      }else{
        _status = null;
      }

      LazyRQM rqm =
      LazyRQM(pageNumber: 1, pageSize: 50, keyword: '', orderBy: [''],status: _status);
      change(null, status: RxStatus.loading());
      deliveryData = await _driverDeliveryUseCase.execute(rqm);
      // homeEntity = rpm.data;
      if (deliveryData?.data.isEmpty ?? false) {
        change(LazyRPM(), status: RxStatus.empty());
      } else {
        change(deliveryData, status: RxStatus.success());
      }
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

/*
  Future fetchData(int status) async {
    try {
      LazyRQM rqm = LazyRQM(
          pageNumber: 1,
          pageSize: 50,
          brandId: null,
          status: status,
          keyword: '',
          orderBy: ['']);

      deliveryData = await _driverDeliveryUseCase.execute(rqm);
      return deliveryData;
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }
*/
}
