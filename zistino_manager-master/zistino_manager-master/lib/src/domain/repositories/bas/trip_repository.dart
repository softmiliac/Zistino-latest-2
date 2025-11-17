import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/trip_rqm.dart';
import '../../entities/base/trip_entity.dart';

abstract class TripRepository{
  Future<int> createTrip(TripRqm rqm);
  Future<int> endTrip(TripRqm rqm);
  Future<List<TripEntity>> searchTrip(LazyRQM rqm);
}