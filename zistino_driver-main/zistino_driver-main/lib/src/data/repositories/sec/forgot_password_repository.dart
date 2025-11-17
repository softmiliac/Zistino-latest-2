
import '../../../domain/repositories/sec/forgot_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/check_code_forogot_password_model.dart';
import '../../models/sec/check_code_rpm.dart';
import '../../models/sec/forgot_password_model.dart';
import '../../models/sec/forgot_password_send_email.dart';
import '../../models/sec/send_code_rpm.dart';
import '../../providers/remote/sec/forgot_password_api.dart';

class ForgotPasswordRepositoryImp extends ForgotPasswordRepository {
  @override
  Future<BaseResponse> sendEmail(
      ForgotPasswordSendEmailRQM forgotRQM) async {
    try {
      BaseResponse result =
          await ForgotPasswordApi().fetchSendEmail(forgotRQM);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponse> setPassword(
      SetNewPasswordRQM setPasswordRQM) async {
    try {
      BaseResponse result =
          await ForgotPasswordApi().fetchSetPassword(setPasswordRQM);

      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CheckCodeRPM> checkCode(
      CheckCodeForgotPasswordRQM checkCodeForgotPasswordRQM) async {
    try {
      BaseResponse response = await ForgotPasswordApi()
          .checkCodeForgotPassword(checkCodeForgotPasswordRQM);
      CheckCodeRPM rpm = CheckCodeRPM.fromJson(response.data);
      return rpm;
    } catch (e) {
      rethrow;
    }
  }
}
