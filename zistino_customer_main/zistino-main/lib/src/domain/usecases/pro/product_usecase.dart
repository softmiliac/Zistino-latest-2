import '../../../common/usecases/usecase.dart';
import '../../entities/pro/product_entity.dart';
import '../../repositories/pro/product_repository.dart';

class ProductUseCase extends ParamUseCase<ProductEntity, String> {
  final ProductRepository _repo;

  ProductUseCase(this._repo);

  @override
  Future<ProductEntity> execute(String params) {
    return _repo.getByID(params);
  }
}

class ResidueUseCase extends NoParamUseCase<List<ProductEntity>> {
  final ProductRepository _repo;

  ResidueUseCase(this._repo);

  @override
  Future<List<ProductEntity>> execute() {
    return _repo.getResidue();
  }
}
