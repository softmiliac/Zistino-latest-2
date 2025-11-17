import 'package:admin_zistino/src/common/utils/app_logger.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/domain/entities/base/locations_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../domain/entities/base/trip_entity.dart';
import '../../../../../domain/usecases/bas/locations_usecase.dart';
import '../../../../../domain/usecases/bas/trip_usecase.dart';

class DriverDetailController extends GetxController {

  /// Variables ///
  LocationData? currentLocation;
  List<TripEntity>? rpm;
  List<LocationsEntity>? rpmLocations;
  String? userId;
  RxList<LatLng> fake = <LatLng>[].obs;
  RxBool isBusyLatLng = false.obs;

  /// Instances ///
  final Location locationService = Location();
  final SearchTripUseCase _searchTripUseCase = SearchTripUseCase();
  late MapController mapController;
  final SearchLocationsUseCase searchLocationsUseCase =
      SearchLocationsUseCase();

  /// Functions ///
  @override
  void onInit() {
    mapController = MapController();
    super.onInit();
  }

  Future move(double lat , double lon) async {
    try {
      mapController.move(
          LatLng(lat,
              lon),
          16);

    } catch (e) {
      AppLogger.e('$e');
    }
  }

  Future searchTrip(String userId) async {
    try {
      LazyRQM rqm = LazyRQM(
          advancedSearch: AdvancedSearch(fields: ['UserId'], keyword: ''),
          keyword: userId,
          pageNumber: 1,
          pageSize: 100);
      rpm = await _searchTripUseCase.execute(rqm);
      update();
      searchLocations(rpm?.first.id ?? 0);

      return rpm ;

    } catch (e) {
      AppLogger.e('$e');
    }
  }
  changePolyLine(){
    for(var a in rpmLocations!){
      debugPrint('${a.latitude} latValue');
      debugPrint('${a.id} idValue ');
      fake.add(LatLng(a.latitude,a.longitude));
      update();
    }
  }


  Future searchLocations(int tripId) async {
    try {
      LazyRQM rqm = LazyRQM(
          // advancedSearch: AdvancedSearch(fields: ['TripId'], keyword: ''),
          // keyword: tripId.toString(),
          // pageNumber: 1,
          // pageSize: 100,
        tripId:  tripId,
      );
      if (isBusyLatLng.value == false) {
        isBusyLatLng.value = true;
        rpmLocations = await searchLocationsUseCase.execute(rqm);
        if (rpmLocations !=null) {
          fake.clear();
          changePolyLine();
          rpmLocations?.map((e) {
            move(e.latitude, e.longitude);
          }).toList();
        }
        isBusyLatLng.value = false;
      }
      return rpmLocations;
    } catch (e) {
      isBusyLatLng.value = false;
      AppLogger.e('$e');
    }
  }

  Future getLocation() async {
    currentLocation = await locationService.getLocation();
  }

/*
  void initLocationService() async {
    await locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
    );

    LocationData? location;
    bool serviceEnabled;
    bool serviceRequestResult;

    try {
      serviceEnabled = await locationService.serviceEnabled();

      if (serviceEnabled) {
        final permission = await locationService.requestPermission();
        _permission = permission == PermissionStatus.granted;

        if (_permission) {
          location = await locationService.getLocation();
          currentLocation = location;
          locationService.onLocationChanged.listen((LocationData result) async {
            // if (mounted) {
            // setState(() {
            currentLocation = result;

            // If Live Update is enabled, move map center
            if (_liveUpdate) {
              controller.move(
                  LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  controller.zoom);
            }
            update();
            // });
            // }
          });
        }
      } else {
        serviceRequestResult = await locationService.requestService();
        if (serviceRequestResult) {
          initLocationService();
          return;
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      if (e.code == 'PERMISSION_DENIED') {
        _serviceError = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        _serviceError = e.message;
      }
      location = null;
    }
  }
*/
}
