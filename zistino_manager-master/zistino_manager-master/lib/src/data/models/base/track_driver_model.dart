import 'package:admin_zistino/src/data/models/base/safe_convert.dart';

class TrackingDriverModelItem {
  final String messageType;
  final DriverLocationModel message;
  final int label;

  TrackingDriverModelItem({
    this.messageType = "",
    required this.message,
    this.label = 0,
  });

  factory TrackingDriverModelItem.fromJson(Map<String, dynamic>? json) =>
      TrackingDriverModelItem(
        messageType: asT<String>(json, 'messageType'),
        message: DriverLocationModel.fromJson(asT<Map<String, dynamic>>(json, 'message')),
        label: asT<int>(json, 'label'),
      );

  Map<String, dynamic> toJson() => {
        'messageType': messageType,
        'message': message.toJson(),
        'label': label,
      };
}

class DriverLocationModel {
  final String userId;
  final int tripId;
  final double latitude;
  final double longitude;


  DriverLocationModel({
    this.userId = "",
    this.tripId = 0,
    this.latitude = 0,
    this.longitude = 0,

  });

  factory DriverLocationModel.fromJson(Map<String, dynamic>? json) => DriverLocationModel(
        userId: asT<String>(json, 'UserId'),
    tripId: asT<int>(json, 'TripId'),
    latitude: asT<double>(json, 'Latitude'),
    longitude: asT<double>(json, 'Longitude'),

      );
  // "UserId":"ca941649-a542-4b9e-9489-f8e7285151c6","TripId":1,"Latitude":0.0,"Longitude":0.0,}
  Map<String, dynamic> toJson() => {
        'UserId': userId,
        'TripId': tripId,
        'Latitude': latitude,
        'Longitude': longitude,

      };
}
