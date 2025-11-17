import 'dart:convert' as convert;

import 'package:admin_zistino/src/domain/entities/base/driver_entity.dart';
import 'package:admin_zistino/src/presentation/style/colors.dart';
import 'package:admin_zistino/src/presentation/style/dimens.dart';
import 'package:admin_zistino/src/presentation/ui/base/map_page/view/signalr_service.dart';
import 'package:admin_zistino/src/presentation/widgets/back_widget.dart';
import 'package:admin_zistino/src/presentation/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../data/models/base/track_driver_model.dart';

class TrackingVehiclePage extends StatefulWidget {
   const TrackingVehiclePage({super.key,required this.driverUserId});
  final DriverEntity driverUserId;

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<TrackingVehiclePage> {

  // final TrackingController controller = Get.put(TrackingController());
  late MapController mapController;
  SignalRConnection1 signalR = SignalRConnection1();
  final LocalStorageService pref = Get.find();
  List<String> messages = [];

  DriverLocationModel? model;
  void _handleMessageReceived(List<Object?>? data) {
    setState(() {
      Map x = data![0] as Map;
      String y =  x!=null ? x["message"] : "";
      var z =convert.json.decode(y);
      model= DriverLocationModel.fromJson(z);
      mapController.move(LatLng(model?.latitude ?? 0, model?.longitude ?? 0), 15) ;

      // messages.add(data![0].toString());

    });
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    signalR.connect();
    signalR.registerOnMessageReceivedCallback(_handleMessageReceived);
    debugPrint('${signalR.connection.state} START');

  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$model model');
    debugPrint('${messages.length} messageLength');
    debugPrint('${widget.driverUserId} pref');
    model?.userId == widget.driverUserId.id ?
    mapController.move(LatLng(model?.latitude ?? 0, model?.longitude ?? 0), 15) : null;


    return
      // model?.latitude == null || model?.latitude == 0 ?
      //   _nullLocationWidget()
      //   :
    Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: backIcon(),
        title: Text('${widget.driverUserId.firstName!} ${widget.driverUserId.lastName!}'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_on_rounded),
        onPressed: () {
          debugPrint('${signalR.connection.state} state');
          model?.userId == widget.driverUserId.id ?
          mapController.move(LatLng(model?.latitude ?? 0, model?.longitude ?? 0), 15) : null;
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center:model?.userId == widget.driverUserId.id ?
                (model?.latitude != null)
                    ? LatLng(model?.latitude ?? 0,
                    model?.longitude ?? 0)
                    : LatLng(0, 0) : null,
                zoom: 13.0,
                controller: mapController,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    model?.userId == widget.driverUserId.id ?
                    (model?.latitude != null)
                        ? Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(model?.latitude ?? 0,
                                model?.longitude ?? 0),
                            builder: (ctx) => const Icon(
                              Icons.location_history_sharp,
                              color: AppColors.primaryColor,
                              size: 45.0,
                            ),
                          )
                        : Marker(
                            width: 0,
                            height: 0,
                            point: LatLng(0, 0),
                            builder: (ctx) => const SizedBox(),
                          ) : Marker(
                      width: 0,
                      height: 0,
                      point: LatLng(0, 0),
                      builder: (ctx) => const SizedBox(),
                    ) ,
                  ],
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      width: fullWidth,
                      color: Colors.red,
                      child: Text('${signalR.connection.state}')),

                ],
              )),
        ],
      ),
    );
  }

  Widget _nullLocationWidget(){
    final ThemeData theme = Get.theme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: backIcon(),
        title: Text('${widget.driverUserId.firstName!} ${widget.driverUserId.lastName!}'),
      ),
      body: SizedBox(
        height:fullHeight/1.5,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('لوکیشن راننده مورد نظر خاموش میباشد',style: theme.textTheme.subtitle1,),
            progressButton(text: 'تلاش مجدد',isProgress:false, onTap: () {
              signalR.connect();

            },)
            ],
          ),
        ),
      ),

    );
  }
}

