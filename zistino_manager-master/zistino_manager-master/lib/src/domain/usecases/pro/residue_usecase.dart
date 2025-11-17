import 'package:admin_zistino/src/data/repositories/pro/product_repository.dart';

import '../../../common/usecases/usecase.dart';
import '../../entities/pro/product_entity.dart';
import '../../repositories/pro/product_repository.dart';

class ResidueUseCase extends NoParamUseCase<List<ProductEntity>> {
  final ProductRepositoryIml _repo = ProductRepositoryIml();

  @override
  Future<List<ProductEntity>> execute() {
    return _repo.getResidue();
  }
}