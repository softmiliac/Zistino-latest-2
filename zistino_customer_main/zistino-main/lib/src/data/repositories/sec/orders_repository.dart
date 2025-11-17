import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/order_entity.dart';
import '../../../domain/repositories/sec/orders_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/lazy_rqm.dart';
import '../../models/sec/order_model.dart';
import '../../providers/remote/sec/orders_api.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  @override
  Future<List<OrderEntityClient>> fetchAll(LazyRQM rqm,
      {bool fromLocal = true}) async {
    try {
      BaseResponse response = await OrdersAPI().fetch(rqm);

      List<OrderEntityClient> result =
          OrderModelClient.fromJsonList(response.data as List); //todo lazyRpm

      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }



  @override
  Future<OrderEntityDriver> getByDriverOrderID(int? orderID, {bool fromLocal = true}) async{
    try {
      BaseResponse response = await OrdersAPI().getByDriverOrderID(orderID);

      OrderEntityDriver result = OrderModelDriver.fromJson(response.data); //todo lazyRpm

      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<OrderEntityClient> getClientByPreOrderID(int? orderID, {bool fromLocal = true}) async{
    try {
      BaseResponse response = await OrdersAPI().getByClientPreOrderID(orderID);
      OrderEntityClient result = OrderModelClient.fromJson(response.data); //todo lazyRpm
      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }
}
