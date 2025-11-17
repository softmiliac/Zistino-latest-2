import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/data/models/base/driver_delivery_model.dart';
import '../../../../data/models/base/lazy_rpm.dart';
import '../../../../domain/entities/base/driver_delivery.dart';
import '../../base/home_page/controller/home_controller.dart';

class MyMapController extends GetxController with GetTickerProviderStateMixin {
  /// Variables ///
  // late List<GeoPoint> markers = [];
  RxInt currentIndex = 0.obs;

  // GeoPoint? geoPoint;
  List<DriverDeliveryModel>? rpm;

  /// Instances ///
  late final HomeController homeController = Get.find();
  late MapController controller = MapController();

  /// Futures ///
  // Future<List<GeoPoint>> fetchMarker(GeoPoint g) async {
  //   GeoPoint a = GeoPoint(
  //       latitude: g.latitude,
  //       longitude: g.longitude);
  //   // markers = [
  //   //   GeoPoint a =GeoPoint(
  //   //       latitude:
  //   //           homeController.homeEntity?.data[currentIndex.value].latitude ?? 0,
  //   //       longitude:
  //   //           homeController.homeEntity?.data[currentIndex.value].longitude ?? 0)
  //   // ];
  //   markers.add(a);
  //   return markers;
  // }

  setMarker() {
    return requests()
        .map((e) => GeoPoint(latitude: e.latitude, longitude: e.longitude))
        .toList();
  }

  List<DriverDeliveryModel> requests() {
    try {
      rpm = homeController.homeEntity?.data;
      return rpm?.where((element) => element.status == 0)
              .toList() ??
          [];
    } catch (e) {
      debugPrint("$e");
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    requests();
  }
}
