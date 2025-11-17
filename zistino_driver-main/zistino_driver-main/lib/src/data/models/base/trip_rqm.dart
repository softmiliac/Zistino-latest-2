

class TripRqm {
  final String userId;
  final int startLocationId;
  final int endLocationId;
  final int distance;
  final int duration;
  final int maxSpeed;
  final int averageSpeed;
  final int averageAltitude;

  TripRqm({
    this.userId = "",
    this.startLocationId = 0,
    this.endLocationId = 0,
    this.distance = 0,
    this.duration = 0,
    this.maxSpeed = 0,
    this.averageSpeed = 0,
    this.averageAltitude = 0,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'startLocationId': startLocationId,
    'endLocationId': endLocationId,
    'distance': distance,
    'duration': duration,
    'maxSpeed': maxSpeed,
    'averageSpeed': averageSpeed,
    'averageAltitude': averageAltitude,
  };
}

