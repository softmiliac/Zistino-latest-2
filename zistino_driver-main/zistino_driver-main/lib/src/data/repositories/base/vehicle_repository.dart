import 'package:recycling_machine/src/data/models/base/trip_rqm.dart';
import 'package:recycling_machine/src/domain/repositories/bas/trip_repository.dart';

import '../../../domain/repositories/bas/vehicle_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/vehicle_rqm.dart';
import '../../providers/remote/base/trip_api.dart';
import '../../providers/remote/base/vehicle_api.dart';

class VehicleRepositoryImpl extends VehicleRepository{
  @override
  Future<int> fetchVehicle(VehicleRqm rqm) async{
 try{
   BaseResponse response = await VehicleApi().fetchVehicle(rqm);
   return response.data;

 }catch(e){
   rethrow;
 }
  }

}