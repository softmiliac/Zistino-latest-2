
import '../../../common/usecases/usecase.dart';
import '../../../data/repositories/base/splash_repository.dart';
import '../../repositories/bas/splash_repository.dart';

class SplashUseCase extends NoParamUseCase<bool> {
  final SplashRepositoryImpl _repo = SplashRepositoryImpl();


  @override
  Future<bool> execute() {
    return _repo.syncApp();
  }
}
