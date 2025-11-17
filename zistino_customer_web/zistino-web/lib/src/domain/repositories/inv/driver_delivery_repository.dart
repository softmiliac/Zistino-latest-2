import 'package:admin_dashboard/src/data/models/base/base_response.dart';
import 'package:admin_dashboard/src/data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../data/models/inv/driver_delivery_model.dart';


abstract class DriverDeliveryRepository {
  Future<LazyRPM<DriverDeliveryModel>> getDriverDelivery(LazyRQM rqm);
  Future<dynamic> createDeliveryRequest(DriverDeliveryModel rqm, );
  Future<BaseResponse> deleteDeliveryRequest(DeleteDriverDeliveryRQM rqm);
  Future<bool> editDeliveryRequest(int deliveryId );

}