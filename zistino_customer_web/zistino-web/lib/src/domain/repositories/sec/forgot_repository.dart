
import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/check_code_forogot_password_model.dart';
import '../../../data/models/sec/check_code_rpm.dart';
import '../../../data/models/sec/forgot_password_model.dart';
import '../../../data/models/sec/forgot_password_send_email.dart';
import '../../../data/models/sec/send_code_rpm.dart';

abstract class ForgotPasswordRepository{
  Future<BaseResponse> sendEmail(ForgotPasswordSendEmailRQM forgotRQM );
  Future<BaseResponse> setPassword(SetNewPasswordRQM forgotRQM );
  Future<CheckCodeRPM> checkCode(CheckCodeForgotPasswordRQM checkCodeForgotPasswordRQM );
}