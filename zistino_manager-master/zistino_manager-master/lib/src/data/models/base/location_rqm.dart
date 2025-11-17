

/*
class LocationsRqm {
  final String userId;
  final int tripId;
  final double latitude;
  final double longitude;
  final double speed;
  final String heading;
  final double altitude;
  final int satellites;
  final int hdop;
  final int gsmSignal;
  final int odometer;

  LocationsRqm({
    this.userId = "",
    this.tripId = 0,
    this.latitude = 0,
    this.longitude = 0,
    this.speed = 0,
    this.heading = "",
    this.altitude = 0,
    this.satellites = 0,
    this.hdop = 0,
    this.gsmSignal = 0,
    this.odometer = 0,
  });


  Map<String, dynamic> toJson() => {
    'userId': userId,
    'tripId': tripId,
    'latitude': latitude,
    'longitude': longitude,
    'speed': speed,
    'heading': heading,
    'altitude': altitude,
    'satellites': satellites,
    'hdop': hdop,
    'gsmSignal': gsmSignal,
    'odometer': odometer,
  };
}
*/

class LocationsRqm {
  final String userId;
  final int tripId;
  final double latitude;
  final double longitude;
  final int speed;
  final String heading;
  final double altitude;
  final int satellites;
  final int hdop;
  final int gsmSignal;
  final int odometer;

  LocationsRqm({
    this.userId = "",
    this.tripId = 0,
    this.latitude = 0,
    this.longitude = 0,
    this.speed = 0,
    this.heading = "",
    this.altitude = 0,
    this.satellites = 0,
    this.hdop = 0,
    this.gsmSignal = 0,
    this.odometer = 0,
  });


  Map<String, dynamic> toJson() => {
    'userId': userId,
    'tripId': tripId,
    'latitude': latitude,
    'longitude': longitude,
    'speed': speed,
    'heading': heading,
    'altitude': altitude,
    'satellites': satellites,
    'hdop': hdop,
    'gsmSignal': gsmSignal,
    'odometer': odometer,
  };
}
