class TripEntity{
  int id;
  String userId;
  int startLocationId;
  int endLocationId;
  int distance;
  int duration;
  int maxSpeed;
  int averageSpeed;
  int averageAltitude;
  String createdOn;
  TripEntity({
    required this.id,
    required this.userId,
    required this.startLocationId,
    required this.endLocationId,
    required this.distance,
    required this.duration,
    required this.maxSpeed,
    required this.averageSpeed,
    required this.averageAltitude,
    required this.createdOn,

});
}