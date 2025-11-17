import 'package:get/get.dart';
import '../../../models/base/base_response.dart';
import '../../../models/base/lazy_rqm.dart';
import '../../../models/sec/comment_model.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class CommentAPI implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.comments;

  APIControllers get getController => APIControllers.products; //todo

  Future<BaseResponse> insert(CommentModel model) async {
    try {
      Map<String, dynamic> inputs = model.toJson();

      String url = APIEndpoint.urlCreator(controller, APIEndpoint.client);

      BaseResponse response = await _provider.postRequest(url, inputs);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse> update(CommentModel model) async {
    try {
      Map<String, dynamic> inputs = model.toJson();

      String url = APIEndpoint.urlCreator(controller, APIEndpoint.client);

      BaseResponse response = await _provider.putRequest(url, inputs,hasBaseResponse: true);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchByProductId(LazyRQM model) async {
    try {
      Map<String, dynamic> inputs = model.toJson();

      String url =
          APIEndpoint.urlCreator(controller, APIEndpoint.search);

      var response = await _provider.postRequest(url, inputs,hasBaseResponse: true);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchAll(LazyRQM model) async {
    try {
      Map<String, dynamic> inputs = model.toJson();

      String url =
          APIEndpoint.urlCreator(controller, APIEndpoint.clientByUserId);

      var response = await _provider.postRequest(url, inputs,hasBaseResponse: true);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse> delete(int id, {String version = "v1"}) async {
    try {

      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.client,id: '$id');

      BaseResponse response =
      await _provider.deleteRequest(
          url, {},hasBaseResponse: true);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }
}
