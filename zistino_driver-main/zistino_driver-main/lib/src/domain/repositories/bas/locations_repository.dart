import 'package:http/http.dart';

import '../../../data/models/base/location_rqm.dart';
import '../../../data/models/base/trip_rqm.dart';

abstract class LocationRepository{
  Future<int> fetchLocation(LocationsRqm rqm);
}