class LocationsEntity {
  int id;
  String userId;
  int tripId;
  double latitude;
  double longitude;
  int speed;
  String heading;
  double altitude;
  int satellites;
  int hdop;
  int gsmSignal;
  int odometer;
  String createdOn;

  LocationsEntity({
    required this.id,
    required this.userId,
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.heading,
    required this.altitude,
    required this.satellites,
    required this.hdop,
    required this.gsmSignal,
    required this.odometer,
    required this.createdOn,
  });
}
