import 'dart:io';

import 'package:get/get.dart';

import '../../../../common/utils/app_logger.dart';
import '../../../models/base/base_response.dart';
import '../../../models/sec/user_model.dart';
import '../../../models/sec/user_zone_model.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class UserApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.personal;
  APIControllers get zonController => APIControllers.mapzone;

  Future<Map<String, dynamic>> fetchUser() async {
    try {
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.profile);
      Map<String, dynamic> response =
          await _provider.getRequest(url, null, hasBaseResponse: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future searchUserInZone(int zoneId) async {
    try {
      String url = APIEndpoint.urlCreator(zonController, '${APIEndpoint.userByZoneId}$zoneId');
      List<dynamic> response =
      await _provider.postRequest(url, {}, hasBaseResponse: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}



class EditUserApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.personal;

  Future editUser(UserModel _rqm) async {
    try {
      Map<String, dynamic> input = _rqm.toJson();
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.profile);
      bool response =
          await _provider.putRequest(url, input, hasBaseResponse: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future setRepresentative(String representativeCode) async {
    try {
      String url = APIEndpoint.urlCreator(controller, '${APIEndpoint.setRepresentative}$representativeCode');
      bool response =
          await _provider.postRequest(url, {}, hasBaseResponse: false);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class UploadFileProfileApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.fileUploader;

  Future<BaseResponse> uploadImage(File file) async {
    try {
      // Map<String , dynamic> input = file.toJson();
      // String url = APIEndpoint.urlCreator(controller, APIEndpoint.file);
      String url = "v1/fileuploader?folder=app";
      BaseResponse response = await _provider.uploadRequest(
        url,
        file,
        (sent, total) {
          AppLogger.i("sent:$sent ,total:$total");
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
