import 'package:get/get.dart';
import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/repositories/sec/auth_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/auth_model.dart';
import '../../providers/remote/sec/auth_api.dart';

class AuthRepositoryImpl extends AuthRepository {
  final LocalStorageService _pref = Get.find();

  /// Login request ///

  @override
  Future<LoginResult> loginRequest(LoginRQM rqm) async {
    try {
      BaseResponse response = await AuthAPI().login(rqm);

      LoginResult result = LoginResult.fromJson(response.data);

      _pref.token = result.token;
      _pref.refreshToken = result.refreshToken;
      _pref.refreshTokenExpiryTime = result.refreshTokenExpiryTime;

      print('///////// ${_pref.token}');
      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  /// Validate email request ///

  @override
  Future<bool> validateEmailRequest(ValidateEmailRQM rqm) async {
    try {
      BaseResponse response = await AuthAPI().validateEmail(rqm);

      return response.data;
    } catch (e) {
      AppLogger.catchLog(e);

      rethrow;
    }
  }
}
