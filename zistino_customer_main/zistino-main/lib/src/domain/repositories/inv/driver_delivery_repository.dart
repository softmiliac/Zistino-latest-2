import 'package:zistino/src/data/models/base/base_response.dart';
import 'package:zistino/src/data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../data/models/inv/driver_delivery_model.dart';


abstract class DriverDeliveryRepository {
  Future<LazyRPM<DriverDeliveryModel>> getDriverDelivery(LazyRQM rqm);
  Future<BaseResponse> createDeliveryRequest(DriverDeliveryModel rqm);
  Future<BaseResponse> deleteDeliveryRequest(DriverDeliveryRQM rqm);
  Future<BaseResponse> editDeliveryRequest(DriverDeliveryRQM rqm);

}