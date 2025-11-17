// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
//
// /*
// class MapPage extends StatefulWidget {
//   @override
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   LocationData? _currentLocation;
//   final Location _locationService = Location();
//
//   @override
//   void initState() {
//     super.initState();
//     _locationService.onLocationChanged.listen((LocationData cLoc) {
//       setState(() {
//         _currentLocation = cLoc;
//         print('${_currentLocation!.longitude} long');
//         print('${_currentLocation!.latitude} lat');
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//           center: (_currentLocation != null)
//               ? LatLng(_currentLocation?.latitude ?? 0,
//                   _currentLocation?.longitude ?? 0)
//               : LatLng(0, 0),
//           zoom: 13.0,
//         ),
//         layers: [
//           PolylineLayerOptions(
//             polylines: [
//               Polyline(
//                 points: [
//                   LatLng(36.3126607, 59.5906255),
//                   LatLng(36.3126657, 59.5906254),
//                   LatLng(36.3126617, 59.5906252),
//                   LatLng(36.3126667, 59.5906251),
//                 ],
//                 strokeWidth:5,
//                 color: Colors.purple,
//               ),
//             ],
//           ),
//           TileLayerOptions(
//             urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           MarkerLayerOptions(
//
//             markers: [
//               (_currentLocation != null)
//                   ? Marker(
//                       width: 80.0,
//                       height: 80.0,
//                       point: LatLng(_currentLocation?.latitude ?? 0,
//                           _currentLocation?.longitude ?? 0),
//                       builder: (ctx) => Container(
//                         child: Icon(
//                           Icons.directions_car,
//                           color: Colors.red,
//                           size: 45.0,
//                         ),
//                       ),
//                     )
//                   : Marker(
//                       width: 80.0,
//                       height: 80.0,
//                       point: LatLng(0, 0),
//                       builder: (ctx) => Container(
//                         child: Icon(
//                           Icons.directions_car,
//                           color: Colors.grey,
//                           size: 45.0,
//                         ),
//                       ),
//                     ),
//
//             ],
//
//           ),
//         ],
//       ),
//     );
//   }
// }*/
// class MapPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//           center: LatLng(37.7749, -122.4194),
//           zoom: 13.0,
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate:
//             "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//             subdomains: ['a', 'b', 'c'],
//           ),
//           PolylineLayerOptions(
//             polylines: [
//               Polyline(
//                 points: [
//                   LatLng(37.7749, -122.4194),
//                   LatLng(37.8044, -122.4147),
//                   LatLng(37.7880, -122.3997),
//                   LatLng(37.7945, -122.4058),
//                 ],
//                 strokeWidth: 4.0,
//                 color: Colors.blue,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }