import 'package:http/http.dart';

import '../../../data/models/base/trip_rqm.dart';

abstract class TripRepository{
  Future<int> createTrip(TripRqm rqm);
  Future<int> endTrip(TripRqm rqm);
}