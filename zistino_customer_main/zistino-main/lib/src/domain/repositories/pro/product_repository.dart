import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/pro/category_model.dart';
import '../../entities/pro/product_entity.dart';

abstract class ProductRepository {
  Future<ProductEntity> getByID(String id, {bool fromLocal = true});
  // Future<List<ProductEntity>> getByCategoryID(int id, {bool fromLocal = true});
  Future<List<CategoryModel>> getCategories1();
  Future<LazyRPM<ProductEntity>> getProductsBySearch(LazyRQM rqm);
  Future<List<ProductEntity>> getResidue();

}
