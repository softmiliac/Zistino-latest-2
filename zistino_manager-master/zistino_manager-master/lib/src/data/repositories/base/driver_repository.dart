import 'package:admin_zistino/src/data/models/base/lazy_rpm.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/data/models/inv/delete_driver_delivery_rqm.dart';
import 'package:admin_zistino/src/domain/entities/base/driver_delivery.dart';
import 'package:admin_zistino/src/domain/entities/sec/order_entity.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/base/driver_entity.dart';
import '../../../domain/repositories/bas/driver_delivery_repository.dart';
import '../../../domain/repositories/bas/driver_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/driver_delivery_model.dart';
import '../../models/base/driver_model.dart';
import '../../models/sec/order_model.dart';
import '../../providers/remote/base/driver_api.dart';
import '../../providers/remote/base/driver_delivery_api.dart';

class DriverRepositoryImpl extends DriverRepository {
  @override
  Future<List<DriverEntity>> fetchDriver(LazyRQM rqm) async {
    try {
      BaseResponse response = await DriverApi().fetchDriver(rqm);
      List<DriverEntity> result = DriverModel.fromJsonList(response.data as List);
      return result;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  // @override
  // Future<BaseResponse> deleteDeliveryRequest(DeleteDriverDeliveryRQM rqm) async {
  //   try {
  //     BaseResponse response = await DriverDeliveryApi().deleteDelivery(rqm);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // @override
  // Future<OrderEntity> getOrderByID(int? orderID) async {
  //   try {
  //     BaseResponse response = await DriverDeliveryApi().getOrderByID(orderID);
  //
  //     OrderEntity result = OrderModel.fromJson(response.data);
  //
  //     return result;
  //   } catch (e) {
  //     AppLogger.catchLog(e);
  //     rethrow;
  //   }
  // }
  //
  // @override
  // Future createDeliveryRequest(DriverDeliveryModel rqm) async {
  //   try {
  //     BaseResponse response = await DriverDeliveryApi().createDelivery(rqm);
  //     return response.succeeded;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

}
