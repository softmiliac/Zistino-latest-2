import 'package:get/get.dart';
import '../../../models/base/lazy_rqm.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';


class OrdersAPI implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.orders;


  Future fetch(LazyRQM model) async {
    try {
      Map<String, dynamic> inputs = model.toJson();

      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.orders);

      var response =
          await _provider.postRequest(
              url, inputs, hasBaseResponse: true);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }

  Future getByID(int id) async {
    try {
      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.orders, id: '$id');

      var response =
      await _provider.getRequest(
          url, {}, hasBaseResponse: true);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }
}
