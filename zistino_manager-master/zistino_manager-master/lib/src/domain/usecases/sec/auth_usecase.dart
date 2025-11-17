
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/auth_model.dart';
import '../../../data/repositories/sec/auth_repository.dart';
import '../../repositories/sec/auth_repository.dart';

/// Login use case ///

class LoginUseCase extends ParamUseCase<LoginResult, LoginRQM> {
  final AuthRepositoryImpl _repo =AuthRepositoryImpl();

  @override
  Future<LoginResult> execute(LoginRQM params) {
    return _repo.loginRequest(params);
  }
}

// /// Signup use case ///
//
// class SignupUseCase extends ParamUseCase<String, SignupRQM> {
//   final AuthRepository _repo;
//
//   SignupUseCase(this._repo);
//
//   @override
//   Future<String> execute(SignupRQM params) {
//     return _repo.signUpRequest(params);
//   }
// }
//
// /// Confirmation code use case ///
//
// class SendCodeUseCase extends ParamUseCase<BaseResponse, String> {
//   final AuthRepositoryImpl _repo = AuthRepositoryImpl();
//
//
//   @override
//   Future<BaseResponse> execute(String params) {
//     return _repo.senCodeRequest(params);
//   }
// }

/// Forgot password use case ///



/// Reset password use case ///


/// Validate email use case ///

class ValidateEmailUseCase extends ParamUseCase<bool, ValidateEmailRQM> {
  final AuthRepository _repo;

  ValidateEmailUseCase(this._repo);

  @override
  Future<bool> execute(ValidateEmailRQM params) {
    return _repo.validateEmailRequest(params);
  }
}



