import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/pro/category_model.dart';
import '../../entities/pro/product_entity.dart';
import '../../repositories/pro/product_repository.dart';

class GetCategoriesUseCase extends NoParamUseCase<List<CategoryModel>> {
  final ProductRepository _repo;

  GetCategoriesUseCase(this._repo);

  @override
  Future<List<CategoryModel>> execute() {
    return _repo.getCategories1();
  }
}

// class GetProductsByCategoryUseCase
//     extends ParamUseCase<List<ProductEntity>, int> {
//   final ProductRepository _repo;
//
//   GetProductsByCategoryUseCase(this._repo);
//
//   @override
//   Future<List<ProductEntity>> execute(int params) {
//     return _repo.getByCategoryID(params);
//   }
// }

class GetProductsBySearchUseCase
    extends ParamUseCase<LazyRPM<ProductEntity>, LazyRQM> {
  final ProductRepository _repo;

  GetProductsBySearchUseCase(this._repo);

  @override
  Future<LazyRPM<ProductEntity>> execute(LazyRQM params) {
    return _repo.getProductsBySearch(params);
  }
}
