// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
//
// class CryptoCurrencyPage extends StatefulWidget {
//   @override
//   _CryptoCurrencyPageState createState() => _CryptoCurrencyPageState();
// }
//
// class _CryptoCurrencyPageState extends State<CryptoCurrencyPage> {
//   WebSocketChannel? _channel;
//   Map<String, dynamic>? _data;
//
//   @override
//   void initState() {
//     super.initState();
//     _channel = IOWebSocketChannel.connect("wss://ws.coincap.io/prices?assets=bitcoin");
//     _channel?.stream.listen((data) {
//       setState(() {
//         _data = json.decode(data);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cryptocurrency'),
//       ),
//       body: _data == null
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _data?.keys.length,
//         itemBuilder: (context, index) {
//           final currency = _data?.keys.elementAt(index);
//           return ListTile(
//             title: Text(currency ?? ''),
//             subtitle: Text(_data?[currency].toString() ?? ''),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Location _location = Location();
  LocationData? _locationData;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  Future<void> _initLocationService() async {
    // Check if location services are enabled
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request user to enable them
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        // User declined to enable location services, display error message and return
        print('Error: Location services are disabled');
        return;
      }
    }

    // Check if app has permission to access location
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // App does not have permission to access location, request user to grant permission
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        // User declined to grant permission, display error message and return
        print('Error: Location permission not granted');
        return;
      }
    }

    // Location services and permissions are enabled, start listening for location updates
    _locationData = await _location.getLocation();
    setState(() {
      _isListening = true;
    });
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _locationData = locationData;
      });
      // Send location data to server
      _sendLocationData(locationData);
    });
  }

  void _sendLocationData(LocationData locationData) {
    // Send location data to server every 15 seconds
    const Duration interval = Duration(seconds: 15);
    Timer.periodic(interval, (Timer timer) async {
      // Send location data to server
      print('Sending location data: ${locationData.latitude}, ${locationData.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foreground Service Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Foreground Service Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isListening && _locationData != null) Text('Latitude: ${_locationData!.latitude}, Longitude: ${_locationData!.longitude}'),
              if (!_isListening) Text('Location services are disabled or permission not granted'),
            ],
          ),
        ),
      ),
    );
  }
}
