import 'package:admin_zistino/src/data/models/base/base_response.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/common/services/get_storage_service.dart';
import 'package:admin_zistino/src/data/providers/remote/api_endpoint.dart';
import 'package:admin_zistino/src/data/providers/remote/api_provider.dart';
import 'package:admin_zistino/src/data/providers/remote/api_request_representable.dart';

import '../../../models/base/trip_rqm.dart';
import '../../../models/base/vehicle_rqm.dart';

class TripApi extends APIClass{
 final APIProvider _provider = Get.put(APIProvider());
  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.trip;

  Future createTripApi(TripRqm rqm)async{
    Map<String ,dynamic> input = rqm.toJson();
    try{
      String url =APIEndpoint.urlCreator(controller,'' );
      var response = await _provider.postRequest(url, input);

      return response;
    }catch(e){
      rethrow;
    }
  }

 Future endTrip(TripRqm rqm)async{
    final LocalStorageService pref = Get.find();
   Map<String ,dynamic> input = rqm.toJson();
   try{
     String url =APIEndpoint.urlCreator(controller,'${pref.tripId}' );
     var response = await _provider.putRequest(url, input);

     return response;
   }catch(e){
     rethrow;
   }
 }
 Future searchTrip(LazyRQM rqm) async{
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