
import 'package:admin_dashboard/src/data/models/base/base_response.dart';
import 'package:admin_dashboard/src/data/models/base/lazy_rqm.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/inv/driver_delivery.dart';
import '../../../models/inv/delete_driver_delivery_rqm.dart';
import '../../../models/inv/driver_delivery_model.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class DriverDeliveryApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.driverdelivery;

  Future getMyRequests(LazyRQM rqm) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(controller, APIEndpoint.deliveryMyRequests);
      BaseResponse response = await _provider.postRequest(url, inputs);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future fetchAll(LazyRQM rqm) async {
    try {
      Map<String, dynamic> inputs = rqm.toJson();

      String url = APIEndpoint.urlCreator(
        controller,
        APIEndpoint.search,
      );

      BaseResponse response = await _provider.postRequest(url, inputs);

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
  Future editDelivery(int id)async{
    try{
      Map<String,dynamic> input ={};
      String url = APIEndpoint.urlCreator(controller, '',id: '$id');
      var response = await _provider.putRequest(url,input);
      return response ;

    }catch(e){
      rethrow;
    }
  }
  Future deleteDelivery(DeleteDriverDeliveryRQM rqm)async{
    try{
      Map<String,dynamic> input = rqm.toJson();
      String url = APIEndpoint.urlCreator(controller, '',id: '${rqm.id}');
      BaseResponse response = await _provider.putRequest(url, input, hasBaseResponse: true);
      return response ;
    }catch(e){
      rethrow;
    }
  }
  Future createDelivery(DriverDeliveryModel rqm)async{
    try{
      Map<String,dynamic> input = rqm.toJson();
      String url = APIEndpoint.urlCreator(controller, '');

      var response = await _provider.postRequest(url, input);
      return response ;

    }catch(e){
      rethrow;
    }
  }




}
