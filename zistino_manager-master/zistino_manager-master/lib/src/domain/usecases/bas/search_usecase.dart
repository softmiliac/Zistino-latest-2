
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../entities/pro/product_entity.dart';
import '../../repositories/pro/product_repository.dart';

class SearchUseCase extends ParamUseCase<LazyRPM<ProductEntity>,LazyRQM>{
  final ProductRepository _repo;
  SearchUseCase(this._repo);

  @override
  Future<LazyRPM<ProductEntity>> execute(LazyRQM params) {
    return _repo.searchBySp(params);

  }

}