import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/pro/order_rqm.dart';
import '../../entities/pro/product_entity.dart';

abstract class ProductRepository {
  Future<ProductEntity> getByID(String id, {bool fromLocal = true});
  Future<List<ProductEntity>> getByCategoryID(int id, {bool fromLocal = true});
  Future<List<ProductEntity>> getResidue();
  Future<LazyRPM<ProductEntity>> searchBySp(LazyRQM rqm);
  Future<LazyRPM<ProductEntity>> createOrder(OrderRQM rqm);

}
