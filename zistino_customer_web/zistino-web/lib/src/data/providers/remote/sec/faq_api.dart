import 'package:get/get.dart';

import '../../../models/base/base_response.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class FaqAPI implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.faqs;

  Future fetch(String keyword, {String version = "v1"}) async {
    try {
      Map<String, dynamic> inputs = {'keyword': keyword};

      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.faqClient);

      BaseResponse response =
      await _provider.postRequest(
          url, inputs);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }
}
