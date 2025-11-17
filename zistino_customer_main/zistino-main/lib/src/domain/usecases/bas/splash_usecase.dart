
import 'package:zistino/src/data/repositories/base/splash_repository.dart';

import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/config_model.dart';

class SplashUseCase extends ParamUseCase<bool,ConfigRqm> {
  final SplashRepositoryImpl _repo = SplashRepositoryImpl();

  @override
  Future<bool> execute(ConfigRqm params) {
    return _repo.syncApp(params);
  }
}
