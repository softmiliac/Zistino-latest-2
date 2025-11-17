import 'package:admin_dashboard/src/data/models/base/lazy_rpm.dart';
import 'package:admin_dashboard/src/data/models/inv/driver_delivery_model.dart';
import 'package:admin_dashboard/src/data/providers/remote/inv/driver_delivery_api.dart';
import 'package:admin_dashboard/src/domain/entities/inv/driver_delivery.dart';
import 'package:admin_dashboard/src/domain/repositories/inv/driver_delivery_repository.dart';

import '../../../common/utils/app_logger.dart';
import '../../models/base/base_response.dart';
import '../../models/base/lazy_rqm.dart';
import '../../models/inv/delete_driver_delivery_rqm.dart';

class DriverDeliveryRepositoryImpl extends DriverDeliveryRepository {
  @override
  Future createDeliveryRequest(DriverDeliveryModel rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().createDelivery(rqm);
      return response.succeeded;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> deleteDeliveryRequest(DeleteDriverDeliveryRQM rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().deleteDelivery(rqm);
      return response;
    } catch (e) {
      rethrow;
    }
  }



  @override
  Future<bool> editDeliveryRequest(int deliveryId) async {
    try {
      bool response = await DriverDeliveryApi().editDelivery(deliveryId);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LazyRPM<DriverDeliveryModel>> getDriverDelivery(LazyRQM rqm)async {
    try {
      BaseResponse response = await DriverDeliveryApi().getMyRequests(rqm);

      LazyRPM<DriverDeliveryModel> result = LazyRPM.fromJson(response.data, DriverDeliveryModel.fromJson);
      return result;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }
}
