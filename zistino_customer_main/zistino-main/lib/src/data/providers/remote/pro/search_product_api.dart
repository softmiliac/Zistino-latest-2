import 'package:get/get.dart';
import '../../../models/base/base_response.dart';
import '../../../models/base/lazy_rqm.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class ProductsAPI implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.products;
  APIControllers get categoriesController => APIControllers.categories;

  Future fetchCategories() async {
    try {
      String url = APIEndpoint.urlCreator(
        categoriesController,
        APIEndpoint.byCategoryType1,
      );

      BaseResponse response = await _provider.getRequest(url, null);

      // List<Product> _asd =
      // List.from(response.map((x) => CategoryModel.fromJson(x)));

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
    // try {
    //   Map<String, dynamic> inputs = {};
    //   String endPoint = APIEndpoint.getAllProducts;
    //
    //   var response = _provider.postRequest(
    //       "$version/$controller/$endPoint", inputs);
    //
    //   return response;
    // } catch (e) {
    //   // AppLogger.catchLog(e);
    //   rethrow;
    // }
  }

  Future searchBySp(LazyRQM rqm) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.clientSearch);

      BaseResponse response = await _provider.postRequest(url, inputs, hasBaseResponse: true);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future getByID(String id, {String version = "/v1"}) async {
    try {
      String url =
      APIEndpoint.urlCreator(controller, APIEndpoint.client, id: id);

      var response = await _provider.getRequest(url, {}, hasBaseResponse: true);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }

  // Future getByCategoryID(int id) async {
  //   try {
  //     String url =
  //     APIEndpoint.urlCreator(controller, APIEndpoint.byCategoryID,
  //         id: '$id');
  //
  //     BaseResponse response = await _provider.postRequest(url, {}, hasBaseResponse: true);
  //     return response;
  //   } catch (e) {
  //     // AppLogger.catchLog(e);
  //     rethrow;
  //   }
  // }
}
