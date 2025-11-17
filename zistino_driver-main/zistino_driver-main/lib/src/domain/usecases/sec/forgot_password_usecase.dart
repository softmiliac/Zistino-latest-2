
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/check_code_forogot_password_model.dart';
import '../../../data/models/sec/check_code_rpm.dart';
import '../../../data/models/sec/forgot_password_model.dart';
import '../../../data/models/sec/forgot_password_send_email.dart';
import '../../repositories/sec/forgot_repository.dart';

class ForgotSendEmailUseCase
    extends ParamUseCase<BaseResponse, ForgotPasswordSendEmailRQM> {
  final ForgotPasswordRepository _repository;

  ForgotSendEmailUseCase(this._repository);

  @override
  Future<BaseResponse> execute(ForgotPasswordSendEmailRQM params) {
    return _repository.sendEmail(params);
  }
}

class ForgotSetNewPasswordUseCase
    extends ParamUseCase<BaseResponse, SetNewPasswordRQM> {
  final ForgotPasswordRepository _repository;

  ForgotSetNewPasswordUseCase(this._repository);

  @override
  Future<BaseResponse> execute(SetNewPasswordRQM params) {
    return _repository.setPassword(params);
  }
}

class ForgotPasswordCheckCodeUseCase
    extends ParamUseCase<CheckCodeRPM, CheckCodeForgotPasswordRQM> {
  final ForgotPasswordRepository _repository;

  ForgotPasswordCheckCodeUseCase(this._repository);

  @override
  Future<CheckCodeRPM> execute(CheckCodeForgotPasswordRQM params) {
   return _repository.checkCode(params);
  }
}
