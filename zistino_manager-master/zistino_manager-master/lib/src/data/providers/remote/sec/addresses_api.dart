
import 'package:get/get.dart';
import '../../../../common/utils/app_logger.dart';
import '../../../../domain/entities/sec/address_entity.dart';
import '../../../models/base/base_response.dart';
import '../../../models/sec/address_model.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';


class AddressesAPI implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.addresses;

  Future fetchAll({String version = "v1"}) async {
    try {
      Map<String, dynamic> inputs = {};
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.clientByUserId);

      var response = await _provider.getRequest(url,inputs);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }

  Future<BaseResponse> insert(AddressEntity model, {String version = "v1"}) async {
    try {
      Map<String, dynamic> inputs = AddressModel.castFromEntity(model).toJson();

      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.client);

      BaseResponse response =
          await _provider.postRequest(
              url, inputs);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }

  Future<BaseResponse> update(AddressEntity model, int id, {String version = "v1"}) async {
    try {
      Map<String, dynamic> inputs = AddressModel.castFromEntity(model).toJson();

      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.client,id: "$id");

      BaseResponse response =
          await _provider.putRequest(
              url, inputs,hasBaseResponse: true);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
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

  Future getByID(int id) async {
    try {

      String url = APIEndpoint.urlCreator(controller, APIEndpoint.insert,id: '$id');

      var response = await _provider.getRequest(url,{});

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }

}
