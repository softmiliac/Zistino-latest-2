import '../../../data/models/base/lazy_rqm.dart';
import '../../entities/sec/order_entity.dart';

abstract class OrdersRepository {
  Future<List<OrderEntity>> fetchAll(LazyRQM rqm, {bool fromLocal = true});
  Future<OrderEntity> getByID(int orderID, {bool fromLocal = true});
}
