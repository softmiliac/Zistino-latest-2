import 'package:get/get.dart';

import '../../../models/base/base_response.dart';
import '../../../models/base/config_model.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class ConfigApi implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.configurations;

  Future fetchConfig(ConfigRqm rqm) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.clientSearch);
      BaseResponse response = await _provider.postRequest(url, inputs,hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
