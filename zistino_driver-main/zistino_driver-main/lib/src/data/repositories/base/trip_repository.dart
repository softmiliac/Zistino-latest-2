import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/common/services/get_storage_service.dart';
import 'package:recycling_machine/src/data/models/base/trip_rqm.dart';
import 'package:recycling_machine/src/domain/repositories/bas/trip_repository.dart';

import '../../models/base/base_response.dart';
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
      // pref.tripId = 0;


      return response['data'];
    } catch (e) {
      rethrow;
    }
  }
}
