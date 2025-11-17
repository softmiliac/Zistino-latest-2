import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/auth_model.dart';

abstract class AuthRepository {
  Future<LoginSignupResult> loginRequest(LoginRQM rqm);
  Future<BaseResponse> signUpRequest(SignupRQM rqm);
  Future<BaseResponse> senCodeRequest(String phoneNumber);
}
