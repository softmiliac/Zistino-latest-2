import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/domain/entities/base/locations_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/common/services/get_storage_service.dart';
import 'package:admin_zistino/src/data/models/base/location_rqm.dart';
import 'package:admin_zistino/src/domain/repositories/bas/locations_repository.dart';

import '../../models/base/base_response.dart';
import '../../models/base/locations_model.dart';
import '../../providers/remote/base/location_api.dart';

class LocationRepositoryImpl extends LocationRepository {
  final LocalStorageService pref = Get.find();

  @override
  Future<int> fetchLocation(LocationsRqm rqm) async {
    try {
      BaseResponse response = await LocationApi().fetchLocations(rqm);
      var a =response.data as int;
      if (pref.startLocationId == null) {
        pref.startLocId(a,"repo");
      }
      pref.endLocId(a,"repo");
      // debugPrint('${pref.startLocationId} startLocRepo');
      // debugPrint('${pref.endLocationId} endLocRepo');

      return a;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<LocationsEntity>> searchLocations(LazyRQM rqm)async {
  try{
    BaseResponse response = await LocationApi().searchLocations(rqm);
    List<LocationsModel> result = LocationsModel.fromJsonList(response.data as List);
    return result;
  }catch(e){
    rethrow;
  }
  }
}
