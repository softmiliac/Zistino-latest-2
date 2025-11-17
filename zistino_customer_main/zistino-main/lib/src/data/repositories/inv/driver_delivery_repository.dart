import 'package:zistino/src/data/models/base/lazy_rpm.dart';
import 'package:zistino/src/data/models/inv/driver_delivery_model.dart';
import 'package:zistino/src/data/providers/remote/inv/driver_delivery_api.dart';
import 'package:zistino/src/domain/entities/inv/driver_delivery.dart';
import 'package:zistino/src/domain/repositories/inv/driver_delivery_repository.dart';

import '../../../common/utils/app_logger.dart';
import '../../models/base/base_response.dart';
import '../../models/base/lazy_rqm.dart';
import '../../models/inv/delete_driver_delivery_rqm.dart';

class DriverDeliveryRepositoryImpl extends DriverDeliveryRepository {
  @override
  Future<BaseResponse> createDeliveryRequest(DriverDeliveryModel rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().createDelivery(rqm);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> deleteDeliveryRequest(DriverDeliveryRQM rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().deleteDelivery(rqm);
      return response;
    } catch (e) {
      rethrow;
    }
  }



  @override
  Future<BaseResponse> editDeliveryRequest(DriverDeliveryRQM rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().editDelivery(rqm);
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
