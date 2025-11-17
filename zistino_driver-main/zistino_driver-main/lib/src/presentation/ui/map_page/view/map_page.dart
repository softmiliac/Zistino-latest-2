// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:recycling_machine/src/presentation/ui/map_page/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/base/driver_delivery.dart';
import '../../../style/dimens.dart';
import '../../../widgets/back_widget.dart';
import '../../base/home_page/controller/home_controller.dart';
import '../../base/home_page/widgets/requests_widget.dart';
import '../../base/main_page/view/main_page.dart';

class MapPage extends StatelessWidget {
  MapPage({super.key});

  // @override
  // State<StatefulWidget> createState() => _LocationAppExampleState();
// }

// class _LocationAppExampleState extends State<MapPage> {
  /// Variables ///
  final theme = Get.theme;
  RxBool isTapped = false.obs;

  /// Instances ///
  MyMapController myMapController = Get.put(MyMapController());

  /// Futures ///
  Future<bool> onBackClicked() {
    myMapController.currentIndex.value = 0;
    Get.off(MainPage());
    // Get.off(LawyerLicenseInfoPage());
    return Future.value(false);
  }

  addFakeMarkers() async {}

  MarkerIcon markerIcon = MarkerIcon(
    iconWidget: SvgPicture.asset(
      'assets/ic_recycle.svg',
      color: Colors.blue,
      width: 120,
      height: 120,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackClicked,
      child: Scaffold(
        appBar: AppBar(
          leading: backIcon(
            onTap: () {
              myMapController.currentIndex.value = 0;
              Get.off(MainPage());
            },
          ),
          title: Text(
            'موقعیت یابی',
            style: theme.textTheme.subtitle1,
          ),
        ),
        body: Stack(
          children: [
            OSMFlutter(
              controller: myMapController.controller,
              isPicker: false,
              initZoom: 16,
              staticPoints: [
                StaticPositionGeoPoint(
                    "id", markerIcon, myMapController.setMarker()),
              ],
              minZoomLevel: 8,
              stepZoom: 2.0,
              userLocationMarker: UserLocationMaker(
                  personMarker: markerIcon,
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 120,
                    ),
                  )),
              markerOption: MarkerOption(
                  defaultMarker: MarkerIcon(
                iconWidget: SvgPicture.asset(
                  'assets/ic_recycle.svg',
                  color: Colors.blue,
                  width: 120,
                  height: 120,
                ),
                // color: Colors.blue,
                // size: 120,
              )),
            ),
            Align(
              alignment: const AlignmentDirectional(-0.91, 0.45),
              child: FloatingActionButton(
                backgroundColor: theme.backgroundColor,
                mini: false,
                child: SvgPicture.asset('assets/ic_location.svg',
                    color: Colors.black),
                onPressed: () async {
                  GeoPoint geoPoint = await myMapController
                      .controller.osmBaseController
                      .myLocation();
                  debugPrint(
                      '${myMapController.controller.osmBaseController.myLocation()} asda');
                  myMapController.controller.goToLocation(geoPoint);
                  await myMapController.controller.osmBaseController
                      .changeLocation(geoPoint);
                  await myMapController.controller.osmBaseController
                      .setZoom(stepZoom: 3);
                },
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.95),
              child: SizedBox(
                height: fullWidth / 2.2,
                child: myMapController
                            .requests().isEmpty
                    ? requestEmptyWidgetMap()
                    : PageView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: myMapController
                            .requests().length,
                        pageSnapping: true,
                        onPageChanged: (value) async {
                          myMapController.currentIndex.value = value;
                          GeoPoint geoPoint = GeoPoint(
                              latitude: myMapController.requests()[value].latitude ,
                              longitude: myMapController.requests()[value].longitude );
                          // myMapController.fetchMarker(geoPoint);
                          // await myMapController.controller.osmBaseController.myLocation();
                          myMapController.controller.goToLocation(geoPoint);
                          await myMapController.controller.osmBaseController
                              .setZoom(stepZoom: 3);
                        },
                        controller: PageController(
                            viewportFraction: 1,
                            initialPage: myMapController.currentIndex.value),
                        itemBuilder: (context, index) {
                          // myMapController.fetchMarker(
                          //     GeoPoint(latitude: , longitude: model.longitude));
                          // myMapController.update();
                          // myMapController.fetchMarker(GeoPoint(
                          //     latitude: homeController.homeEntity?.data[index].latitude?? 0,
                          //     longitude: homeController.homeEntity?.data[index].longitude?? 0));
                          return requestWidgetMap(myMapController
                                  .requests()[index]);
                        },
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}








