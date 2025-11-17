
import '../../../common/usecases/usecase.dart';
import '../../../data/repositories/base/home_repository.dart';
import '../../entities/base/home_entity.dart';

class FetchHomeUseCase extends NoParamUseCase<List<List<ProductSectionEntity>>>{
  final HomeRepositoryImpl _homeRepositoryImpl;
  FetchHomeUseCase(this._homeRepositoryImpl);

  @override
  Future<List<List<ProductSectionEntity>>> execute() {
    return _homeRepositoryImpl.getHome();
  }

}