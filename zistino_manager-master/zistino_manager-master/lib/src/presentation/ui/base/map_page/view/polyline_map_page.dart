import 'package:admin_zistino/src/presentation/ui/base/driver_detail_page/controller/driver_detail_cotroller.dart';
import 'package:admin_zistino/src/presentation/widgets/back_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../../../../common/extensions/datetime_extentions.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../domain/entities/base/driver_delivery.dart';
import '../../../../../domain/entities/base/driver_entity.dart';
import '../../../../style/dimens.dart';
import '../widgets/requests_widget.dart';

class PolyLinePage extends StatefulWidget {
  PolyLinePage({super.key, required this.entity});

  DriverEntity entity;

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<PolyLinePage> {
  final DriverDetailController controller = Get.find();
  LocationData? _currentLocation;
  final Location _locationService = Location();

  @override
  void initState() {
    controller.mapController = MapController();


    // _locationService.onLocationChanged.listen((LocationData cLoc) {
    //   _currentLocation = cLoc;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: backIcon(),
        elevation: 0.5,
        title: const Text('مسیر های طی شده'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child:
              Obx(() {
                return FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    center:
                    // LatLng(),
                    // center:
                    //     controller.fake.map((e) =>  LatLng(controller.rpmLocations!.first.latitude ?? 0 ,
                    //         controller.rpmLocations?.first.longitude ?? 0
                    //     )).toList(),
                    // LatLng(controller.fake.first.latitude  ,
                    //     controller.fake.first.longitude
                    // ),
                    (controller.rpmLocations != null &&
                        controller.rpmLocations!.length > 0)
                        ? LatLng(
                        controller.rpmLocations?.first.latitude ??
                            _currentLocation?.latitude ??
                            0.0,
                        controller.rpmLocations?.first.longitude ??
                            _currentLocation?.longitude ??
                            0.0)
                        : LatLng(0, 0),
                    zoom: 16.0,
                    controller: controller.mapController,
                  ),
                  // options: MapOptions(
                  //   controller: controller.mapController,
                  //   center: LatLng(controller.rpmLocations?.first.latitude ?? 0,
                  //       controller.rpmLocations?.first.longitude ?? 0),
                  //   zoom: 20,
                  // ),

                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    PolylineLayerOptions(
                      polylineCulling: true,
                      polylines: [
                        Polyline(
                          points:
                          controller.fake?.isEmpty ??
                              false || controller.fake == null
                              ? []
                              :
                          controller.fake,
                          // controller.rpmLocations,
                          // controller.rpmLocations?.map((e) {
                          //   return LatLng(e.latitude, e.longitude);
                          // }).toList() ??
                          //     [],
                          color: Colors.blue,

                          strokeWidth: 4.0,
                        ),
                      ],
                    ),
                  ],
                );
              })

          ),
          Align(
            alignment: const AlignmentDirectional(0, 0.95),
            child: SizedBox(
              height: fullWidth / 2.7,
              child:
              // homeController.homeEntity?.data.isEmpty ?? false
              //     ? requestEmptyWidgetMap()
              //     :
              PageView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.rpm?.length,
                pageSnapping: true,
                onPageChanged: (value) {
                  setState(() {
                    if (controller.rpm?[value].id != null) {
                      controller.searchLocations(controller.rpm?[value].id ??
                          0);
                    }
                  });
                },
                controller: PageController(viewportFraction: 1, initialPage: 0),
                itemBuilder: (context, index) {
                  return (controller.rpm != null && controller.rpm!.isNotEmpty)
                      ? Obx(() {
                    return requestWidgetMap(
                        DriverDeliveryEntity(
                          creator: '${widget.entity.firstName!} '
                              '${widget.entity.lastName ?? ''}',
                          phoneNumber: widget.entity.phoneNumber ?? '',
                          address: getDate(
                              controller.rpm?[index].createdOn ?? ''),
                        ),
                            () {},
                        controller.isBusyLatLng.value);
                  })
                      : const SizedBox();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

/*
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SignalR Flutter Client',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SignalR Flutter Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key,required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  HubConnection? _connection;

  @override
  void initState() {
    super.initState();

    _connection = HubConnectionBuilder()
        .withUrl("http://localhost:5000/chat")
        .build();

    _connection!.on("ReceiveMessage", (List user) {
      print("Received message: $user - ${user.length}");
    });

    _connection!.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have not sent any messages yet.',
            ),
          ],
        ),
      ),
    );
  }
}

*/

