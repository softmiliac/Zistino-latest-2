import 'package:admin_zistino/src/common/services/get_storage_service.dart';
import 'package:admin_zistino/src/data/providers/remote/api_endpoint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:latlong2/latlong.dart';

import '../../../../style/dimens.dart';

class SignalRConnection1 {
  late HubConnection connection;
  final LocalStorageService pref = Get.find();


  void connect() {
    debugPrint('${pref.token} tokenSignalR');
    connection = HubConnectionBuilder()
        .withUrl(APIEndpoint.signalRUrl,
        options: HttpConnectionOptions(
          transport: HttpTransportType.WebSockets,
          skipNegotiation: true,

          accessTokenFactory: () => Future.value(pref.token),
        ))
        .build();

    connection.start();

    debugPrint("Hub SignalR was invoked");
  }

  void closeConnection() {
    connection.stop();
    print('Connection stopped');
  }

  Future<void> sendMessage(String message) async {
    await connection.invoke('BasicNotification', args: [message]);
    print('Message sent');
  }

  void registerOnMessageReceivedCallback(void Function(List<Object?>?) callback) {
    connection.on('position', callback);
    connection.on('startTrip', callback);
    connection.on('endTrip', callback);
  }}


void main() {

  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _textEditingController = TextEditingController();
  final SignalRConnection1 _connection = SignalRConnection1();
  LocationData? _currentLocation;
  final Location _locationService = Location();
  List<String> _messages = [];
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();

    _connection.connect();
    _connection.registerOnMessageReceivedCallback(_handleMessageReceived);
    _locationService.onLocationChanged.listen((LocationData cLoc) {
      setState(() {
        _currentLocation = cLoc;
      });
    });
    debugPrint('${_connection.connection.state} STATtttt');

  }

  @override
  void dispose() {
    // _connection.closeConnection();
    super.dispose();
  }

  void _handleMessageReceived(List<Object?>? data) {
    setState(() {
      _messages.add(data![0].toString());
      debugPrint('$_messages asdasda');
    });
  }

  void _handleSendMessage() {
    final message = _textEditingController.text.trim();
    if (message.isNotEmpty) {
      _connection.sendMessage(message);
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('${_connection.connection.state} STATtttt');
    debugPrint('${_messages.length} MessGLE');

    return MaterialApp(
      title: 'SignalR Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SignalR Example'),
        ),
        body:
        Stack(
          children: [

            Positioned.fill(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: (_currentLocation != null)
                      ? LatLng(_currentLocation?.latitude ?? 0,
                      _currentLocation?.longitude ?? 0)
                      : LatLng(0, 0),
                  zoom: 13.0,
                  controller: mapController,
                ),
                layers: [

                  // PolylineLayerOptions(
                  //   polylines: [
                  //     Polyline(
                  //       points: [
                  //         LatLng(36.3126607, 59.5906255),
                  //         LatLng(36.3126657, 59.5906254),
                  //         LatLng(36.3126617, 59.5906252),
                  //         LatLng(36.3126667, 59.5906251),
                  //       ],
                  //       strokeWidth: 5,
                  //       color: Colors.purple,
                  //     ),
                  //   ],
                  // ),
                  TileLayerOptions(
                    urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayerOptions(
                    markers: [
                      (_currentLocation != null)
                          ? Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(

                            _currentLocation?.latitude ?? 0,
                            _currentLocation?.longitude ?? 0),
                        builder: (ctx) => const Icon(
                          Icons.directions_car,
                          color: Colors.red,
                          size: 45.0,
                        ),
                      )
                          : Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(0, 0),
                        builder: (ctx) => Container(
                          child: const Icon(
                            Icons.directions_car,
                            color: Colors.grey,
                            size: 45.0,
                          ),
                        ),
                      ),
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
                        child: Text('${_connection.connection.state}')),
                    ListView.builder(
                      itemCount: _messages.length,
                      shrinkWrap:true,
                      itemBuilder: (context, index) => Container(
                          width: fullWidth,
                          color: Colors.red,
                          child: Text(_messages[index])),)
                  ],
                )),

          ],
        ),
      ),
    );
  }
}



