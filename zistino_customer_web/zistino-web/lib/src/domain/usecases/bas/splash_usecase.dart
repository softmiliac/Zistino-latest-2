
import '../../../common/usecases/usecase.dart';
import '../../repositories/bas/splash_repository.dart';

class SplashUseCase extends NoParamUseCase<bool> {
  final SplashRepository _repo;

  SplashUseCase(this._repo);

  @override
  Future<bool> execute() {
    return _repo.syncApp();
  }
}
