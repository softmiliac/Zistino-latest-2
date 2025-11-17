import '../../../data/models/base/config_model.dart';


abstract class SplashRepository {
  Future<bool> syncApp(ConfigRqm rqm);
}
