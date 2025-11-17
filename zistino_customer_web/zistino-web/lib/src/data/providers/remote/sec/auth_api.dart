
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

      String url = APIEndpoint.urlCreator(_controller, APIEndpoint.loginByPhoneNumber,
          version: "");

      BaseResponse response = await _provider.postRequest(url, inputs);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Signup request ///

  Future<BaseResponse> signup(
    SignupRQM rqm,
  ) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(
          _sendCodeController, APIEndpoint.register,
          version: "");

      BaseResponse response = await _provider.postRequest(url, inputs,hasBaseResponse: true);
      debugPrint('$response');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Send code request ///

  Future<BaseResponse> sendCode(
      String phoneNumber,
  ) async {
    try {

      // Map<String, dynamic> inputs = _rqm.toJson();

      String url = APIEndpoint.urlCreator(_sendCodeController, '${APIEndpoint.sendCode}$phoneNumber',
          version: "");

      BaseResponse response = await _provider.postRequest(url, {});

      return response;

    } catch (e) {
      rethrow;
    }
  }

}
