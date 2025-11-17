import 'package:admin_zistino/src/data/models/base/vehicle_rqm.dart';

import '../../../data/models/base/base_response.dart';


abstract class VehicleRepository{
  Future<int> fetchVehicle(VehicleRqm rqm);
}