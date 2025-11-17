import 'package:flutter/cupertino.dart';
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
  Future<LoginSignupResult> loginRequest(LoginRQM rqm) async {
    try {
      BaseResponse response = await AuthAPI().login(rqm);

      LoginSignupResult result = LoginSignupResult.fromJson(response.data);

      _pref.token = result.token;
      _pref.refreshToken = result.refreshToken;
      _pref.refreshTokenExpiryTime = result.refreshTokenExpiryTime;

      debugPrint('///////// ${_pref.token}');
      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  /// Signup request ///

  @override
  Future<BaseResponse> signUpRequest(SignupRQM rqm) async {
    try {
      BaseResponse response = await AuthAPI().signup(rqm);

      var user = _pref.user;
      user.id = response.data;
      _pref.user = user;

      return response.data;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  /// Confirmation code request ///

  @override
  Future<BaseResponse> senCodeRequest(String phoneNumber) async {
    try {
      BaseResponse response = await AuthAPI().sendCode(phoneNumber);

      return response;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }
}
