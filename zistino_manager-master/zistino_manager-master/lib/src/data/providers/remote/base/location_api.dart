import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/data/models/base/location_rqm.dart';
import 'package:admin_zistino/src/data/providers/remote/api_endpoint.dart';
import 'package:admin_zistino/src/data/providers/remote/api_provider.dart';
import 'package:admin_zistino/src/data/providers/remote/api_request_representable.dart';

import '../../../models/base/base_response.dart';


class LocationApi extends APIClass{
 final APIProvider _provider = Get.put(APIProvider());
  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.locations;

  Future fetchLocations(LocationsRqm rqm)async{
    Map<String ,dynamic> input = rqm.toJson();
    try{
      String url =APIEndpoint.urlCreator(controller,'' );
      var response = await _provider.postRequest(url, input);
      return response;
    }catch(e){
      rethrow;
    }
  }
 Future searchLocations(LazyRQM rqm) async{
   Map<String,dynamic> input = rqm.toJson();
   try{
     String url = APIEndpoint.urlCreator(controller, APIEndpoint.search);
     BaseResponse response = await _provider.postRequest(url, input);
     return response;
   }catch(e){
     rethrow;
   }
 }
}