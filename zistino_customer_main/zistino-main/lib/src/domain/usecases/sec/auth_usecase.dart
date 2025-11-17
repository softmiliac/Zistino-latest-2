
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/auth_model.dart';
import '../../../data/repositories/sec/auth_repository.dart';
import '../../repositories/sec/auth_repository.dart';

/// Login use case ///

class LoginUseCase extends ParamUseCase<LoginSignupResult, LoginRQM> {
  final AuthRepositoryImpl _repo = AuthRepositoryImpl();


  @override
  Future<LoginSignupResult> execute(LoginRQM params) {
    return _repo.loginRequest(params);
  }
}

/// Signup use case ///

class SignupUseCase extends ParamUseCase<BaseResponse, SignupRQM> {
  final AuthRepository _repo;

  SignupUseCase(this._repo);

  @override
  Future<BaseResponse> execute(SignupRQM params) {
    return _repo.signUpRequest(params);
  }
}

/// Confirmation code use case ///

class SendCodeUseCase extends ParamUseCase<BaseResponse, String> {
  final AuthRepositoryImpl _repo = AuthRepositoryImpl();
  @override
  Future<BaseResponse> execute(String params) {
    return _repo.senCodeRequest(params);
  }
}



