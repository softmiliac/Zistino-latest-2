import 'package:admin_zistino/src/common/usecases/usecase.dart';
import 'package:admin_zistino/src/data/models/base/base_response.dart';
import 'package:admin_zistino/src/data/models/base/trip_rqm.dart';
import 'package:admin_zistino/src/data/repositories/base/trip_repository.dart';

import '../../../data/models/base/vehicle_rqm.dart';
import '../../../data/repositories/base/vehicle_repository.dart';

class VehicleUseCase extends ParamUseCase<int,VehicleRqm>{
  final VehicleRepositoryImpl _repo =VehicleRepositoryImpl();

  @override
  Future<int> execute(VehicleRqm params){
    try{
      return _repo.fetchVehicle(params);
    }catch(e){
      rethrow;

    }
  }

}