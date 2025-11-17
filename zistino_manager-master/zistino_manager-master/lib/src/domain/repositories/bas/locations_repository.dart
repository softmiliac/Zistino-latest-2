import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:http/http.dart';

import '../../../data/models/base/location_rqm.dart';
import '../../../data/models/base/trip_rqm.dart';
import '../../entities/base/locations_entity.dart';

abstract class LocationRepository{
  Future<int> fetchLocation(LocationsRqm rqm);
  Future<List<LocationsEntity>> searchLocations(LazyRQM rqm);
}