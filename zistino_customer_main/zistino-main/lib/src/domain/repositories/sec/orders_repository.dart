import '../../../data/models/base/lazy_rqm.dart';
import '../../entities/sec/order_entity.dart';

abstract class OrdersRepository {
  Future<List<OrderEntityClient>> fetchAll(LazyRQM rqm, {bool fromLocal = true});
  Future<OrderEntityClient> getClientByPreOrderID(int? orderID, {bool fromLocal = true});
  Future<OrderEntityDriver> getByDriverOrderID(int? orderID, {bool fromLocal = true});
}
