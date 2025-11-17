
import 'package:get/get.dart';

import '../../../models/base/base_response.dart';
import '../../../models/sec/check_code_forogot_password_model.dart';
import '../../../models/sec/forgot_password_model.dart';
import '../../../models/sec/forgot_password_send_email.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class ForgotPasswordApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.identity;

  Future<BaseResponse> fetchSendEmail(ForgotPasswordSendEmailRQM rqm) async {
    try {
      Map<String, dynamic> input = rqm.toJson();
      String url =
          APIEndpoint.urlCreator(controller, APIEndpoint.forgotPassword,version: '');
      BaseResponse response =
          await _provider.postRequest(url, input, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchSetPassword(SetNewPasswordRQM rqm) async {
    try {
      Map<String, dynamic> input = rqm.toJson();
      String url =
          APIEndpoint.urlCreator(controller, APIEndpoint.resetPassword,version: '');
      BaseResponse response =
          await _provider.postRequest(url, input, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future checkCodeForgotPassword(CheckCodeForgotPasswordRQM rqm) async {
    try {
      Map<String, dynamic> input = rqm.toJson();
      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.checkCodeForgotPassword,version: '');
      BaseResponse response = await _provider.postRequest(url, input,hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
