import 'package:recycling_machine/src/domain/entities/base/driver_delivery.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/driver_delivery_model.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../entities/sec/order_entity.dart';

abstract class DriverDeliveryRepository {
  Future<LazyRPM<DriverDeliveryEntity>> getDriverDelivery(LazyRQM rqm);
  Future<BaseResponse> deleteDeliveryRequest(DeleteDriverDeliveryRQM rqm);
  Future<OrderEntity> getOrderByID(int? orderID);
  Future<dynamic> createDeliveryRequest(DriverDeliveryModel rqm, );
  Future<BaseResponse> editDeliveryRequest(DriverDeliveryModel rqm);
}