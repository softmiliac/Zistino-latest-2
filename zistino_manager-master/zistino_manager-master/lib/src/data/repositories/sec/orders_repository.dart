import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/order_entity.dart';
import '../../../domain/repositories/sec/orders_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/lazy_rqm.dart';
import '../../models/sec/order_model.dart';
import '../../providers/remote/sec/orders_api.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  @override
  Future<List<OrderEntity>> fetchAll(LazyRQM rqm,
      {bool fromLocal = true}) async {
    try {
      BaseResponse response = await OrdersAPI().fetch(rqm);

      List<OrderEntity> result =
          OrderModel.fromJsonList(response.data as List); //todo lazyRpm

      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<OrderEntity> getByID(int orderID, {bool fromLocal = true}) async {
    try {
      BaseResponse response = await OrdersAPI().getByID(orderID);

      OrderEntity result = OrderModel.fromJson(response.data); //todo lazyRpm

      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }
}
