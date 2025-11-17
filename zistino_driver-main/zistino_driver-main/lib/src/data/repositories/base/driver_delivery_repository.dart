import 'package:recycling_machine/src/data/models/base/lazy_rpm.dart';
import 'package:recycling_machine/src/data/models/base/lazy_rqm.dart';
import 'package:recycling_machine/src/data/models/inv/delete_driver_delivery_rqm.dart';
import 'package:recycling_machine/src/domain/entities/base/driver_delivery.dart';
import 'package:recycling_machine/src/domain/entities/sec/order_entity.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/repositories/bas/driver_delivery_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/driver_delivery_model.dart';
import '../../models/sec/order_model.dart';
import '../../providers/remote/base/driver_delivery_api.dart';

class DriverDeliveryRepositoryImpl extends DriverDeliveryRepository {
  @override
  Future<LazyRPM<DriverDeliveryModel>> getDriverDelivery(LazyRQM rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().getMyRequests(rqm);

      LazyRPM<DriverDeliveryModel> result = LazyRPM.fromJson(response.data, DriverDeliveryModel.fromJson);
      return result;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  @override
  Future<BaseResponse> editDeliveryRequest(DriverDeliveryModel rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().editDelivery(rqm);
      return response;
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
  Future<OrderEntity> getOrderByID(int? orderID) async {
    try {
      BaseResponse response = await DriverDeliveryApi().getOrderByID(orderID);

      OrderEntity result = OrderModel.fromJson(response.data);

      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future createDeliveryRequest(DriverDeliveryModel rqm) async {
    try {
      BaseResponse response = await DriverDeliveryApi().createDelivery(rqm);
      return response.succeeded;
    } catch (e) {
      rethrow;
    }
  }

}
