import 'package:admin_zistino/src/data/models/base/lazy_rpm.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/domain/entities/base/trip_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/common/services/get_storage_service.dart';
import 'package:admin_zistino/src/data/models/base/trip_rqm.dart';
import 'package:admin_zistino/src/domain/repositories/bas/trip_repository.dart';

import '../../models/base/base_response.dart';
import '../../models/base/trip_model.dart';
import '../../providers/remote/base/trip_api.dart';

class TripRepositoryImpl extends TripRepository {
  final LocalStorageService pref = Get.find();

  @override
  Future<int> createTrip(TripRqm rqm) async {
    try {
      BaseResponse response = await TripApi().createTripApi(rqm);
      pref.tripId = response.data;

      // if (a != null) {
      //   pref.tripId =null;
      //   pref.startLocId(null) ;
      //   pref.endLocId(null)  ;
      //  // locBox.clear();
      // }

      // debugPrint('${pref.tripId} TripIDddddd');
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> endTrip(TripRqm rqm) async {
    try {
      var response = await TripApi().endTrip(rqm);
      pref.tripId = 0;
      return response['data'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TripEntity>> searchTrip(LazyRQM rqm) async{
    try {
      BaseResponse response = await TripApi().searchTrip(rqm);
      List<TripEntity> result = TripModel.fromJsonList(response.data as List);
      return result;
    } catch (e) {
      rethrow;
    }

  }
}
