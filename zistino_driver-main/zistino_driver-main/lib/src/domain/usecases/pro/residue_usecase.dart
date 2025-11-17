import '../../../common/usecases/usecase.dart';
import '../../entities/pro/product_entity.dart';
import '../../repositories/pro/product_repository.dart';

class ResidueUseCase extends NoParamUseCase<List<ProductEntity>> {
  final ProductRepository _repo;

  ResidueUseCase(this._repo);

  @override
  Future<List<ProductEntity>> execute() {
    return _repo.getResidue();
  }
}