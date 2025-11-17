import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/common/services/get_storage_service.dart';
import 'package:recycling_machine/src/data/models/base/location_rqm.dart';
import 'package:recycling_machine/src/domain/repositories/bas/locations_repository.dart';

import '../../models/base/base_response.dart';
import '../../providers/remote/base/location_api.dart';

class LocationRepositoryImpl extends LocationRepository {
  final LocalStorageService pref = Get.find();

  @override
  Future<int> fetchLocation(LocationsRqm rqm) async {
    try {
      BaseResponse response = await LocationApi().fetchLocations(rqm);
      var a =response.data as int;

      if (pref.setStartLocationId(a) == null) {
        pref.setStartLocationId(a);
      }
      pref.setEndLocationId(a)  ;
      debugPrint('${pref.startLocationId} startLocRepo');
      debugPrint('${pref.endLocationId} endLocRepo');
      return a;
    } catch (e) {
      rethrow;
    }
  }
}
