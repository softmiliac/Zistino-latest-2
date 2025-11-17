import 'package:get/get.dart';

import '../../../models/base/base_response.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class CategoryApi implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.categories;

  Future fetchCategory() async {
    try {
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.byCategoryType2);
      BaseResponse response = await _provider.getRequest(url, null);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  //
  // Future fetchCategory() async {
  //   try {
  //     String url = APIEndpoint.urlCreator(controller, APIEndpoint.byCategoryType2);
  //     BaseResponse response = await _provider.getRequest(url, null);
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
