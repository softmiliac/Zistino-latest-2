import 'package:admin_dashboard/src/data/providers/remote/api_endpoint.dart';
import 'package:admin_dashboard/src/data/providers/remote/api_provider.dart';
import 'package:admin_dashboard/src/data/providers/remote/api_request_representable.dart';
import 'package:get/get.dart';

import '../../../../models/inv/driver_delivery_model.dart';

class DeliveryApi extends APIClass{

  final APIProvider _provider = Get.find();
  @override
  // TODO: implement controller
  APIControllers get controller =>APIControllers.driverdelivery;


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
  Future deleteDelivery(int id)async{
    try{
      Map<String,dynamic> input ={};
      String url = APIEndpoint.urlCreator(controller, '',id: '$id');
      var response = await _provider.deleteRequest(url, input);
      return response ;
    }catch(e){
      rethrow;
    }
  }

}