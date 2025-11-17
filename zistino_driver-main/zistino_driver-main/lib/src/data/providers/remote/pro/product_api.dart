
import 'package:get/get.dart';

import '../../../models/base/base_response.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class ProductApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.products;

  Future getById(String id) async {
    try {
      String url =
          APIEndpoint.urlCreator(controller, APIEndpoint.client, id: id);
      var response =
          await _provider.getRequest(url, {}, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  Future fetchResidue() async {
    try {
      String url =
      APIEndpoint.urlCreator(controller, APIEndpoint.categoryType, );
      BaseResponse response = await _provider.postRequest(url, {});
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
