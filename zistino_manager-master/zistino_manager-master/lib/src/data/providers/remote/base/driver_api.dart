import 'package:get/get.dart';
import 'package:admin_zistino/src/data/models/base/base_response.dart';
import '../../../models/base/driver_delivery_model.dart';
import '../../../models/base/lazy_rqm.dart';
import '../../../models/inv/delete_driver_delivery_rqm.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class DriverApi implements APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.users;
  // APIControllers get _controller => APIControllers.orders;

  Future<BaseResponse> fetchDriver(LazyRQM rqm) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.userbyrole,version: '');
      BaseResponse response = await _provider.postRequest(url, inputs);
      return response;
    } catch (e) {
      rethrow;
    }
  }
  // Future deleteDelivery(DeleteDriverDeliveryRQM rqm)async{
  //   try{
  //     Map<String,dynamic> input = rqm.toJson();
  //     String url = APIEndpoint.urlCreator(controller, '',id: '${rqm.id}');
  //     BaseResponse response = await _provider.putRequest(url, input, hasBaseResponse: true);
  //     return response ;
  //   }catch(e){
  //     rethrow;
  //   }
  // }
  // Future getOrderByID(int? id) async {
  //   try {
  //     String url = APIEndpoint.urlCreator(
  //         _controller, APIEndpoint.client, id: '$id');
  //
  //     BaseResponse response =
  //     await _provider.getRequest(
  //         url, {}, hasBaseResponse: true);
  //
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  // Future createDelivery(DriverDeliveryModel rqm)async{
  //   try{
  //     Map<String,dynamic> input = rqm.toJson();
  //     String url = APIEndpoint.urlCreator(controller, '',id: '${rqm.id}');
  //
  //     var response = await _provider.putRequest(url, input,hasBaseResponse: true);
  //     return response ;
  //
  //   }catch(e){
  //     rethrow;
  //   }
  // }


}
