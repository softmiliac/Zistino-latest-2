import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../models/base/base_response.dart';
import '../../../models/sec/auth_model.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';

class AuthAPI {
  /// Variable ///

  final APIProvider _provider = Get.find();

  APIControllers get _controller => APIControllers.tokens;

  APIControllers get _sendCodeController => APIControllers.identity;

  /// Login request ///

  Future<BaseResponse> login(
    LoginRQM rqm,
  ) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(_controller, '', version: "");

      BaseResponse response = await _provider.postRequest(url, inputs);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Forgot password request ///

  Future<BaseResponse> forgotPassword(
    ForgotPasswordRQM rqm,
  ) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(
          _sendCodeController, APIEndpoint.forgotPassword,
          version: "");

      BaseResponse response = await _provider.postRequest(url, inputs);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Validate request ///

  Future<BaseResponse> validateEmail(
    ValidateEmailRQM rqm,
  ) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(
          _sendCodeController, APIEndpoint.validateEmail,
          version: "");

      BaseResponse response =
          await _provider.getRequest(url + "/${rqm.email}", inputs);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
