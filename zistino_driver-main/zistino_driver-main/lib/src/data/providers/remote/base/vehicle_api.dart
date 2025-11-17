import 'package:get/get.dart';
import 'package:recycling_machine/src/data/providers/remote/api_endpoint.dart';
import 'package:recycling_machine/src/data/providers/remote/api_provider.dart';
import 'package:recycling_machine/src/data/providers/remote/api_request_representable.dart';

import '../../../models/base/vehicle_rqm.dart';

class VehicleApi extends APIClass{
 final APIProvider _provider = Get.find();
  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.vehicle;

  Future fetchVehicle(VehicleRqm rqm)async{
    Map<String ,dynamic> input = rqm.toJson();
    try{
      String url =APIEndpoint.urlCreator(controller,'' );
      var response = await _provider.postRequest(url, input);
      return response;
    }catch(e){
      rethrow;
    }
  }
}