import 'package:admin_zistino/src/data/models/inv/delete_driver_delivery_rqm.dart';

import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/driver_delivery_model.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';

abstract class DriverDeliveryRepository {
  Future<LazyRPM<DriverDeliveryModel>> getDriverDelivery(LazyRQM rqm);
  Future<dynamic> createDeliveryRequest(DriverDeliveryModel rqm);
  Future<BaseResponse> deleteDeliveryRequest(DriverDeliveryRQM rqm);
  Future<BaseResponse> editDeliveryRequest(DriverDeliveryRQM rqm);
}