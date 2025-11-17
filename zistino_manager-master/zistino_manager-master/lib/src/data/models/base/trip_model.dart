import 'package:admin_zistino/src/data/models/base/safe_convert.dart';

import '../../../domain/entities/base/trip_entity.dart';

class TripModel extends TripEntity {
  TripModel({
    int? id,
    String? userId,
    int? startLocationId,
    int? endLocationId,
    int? distance,
    int? duration,
    int? maxSpeed,
    int? averageSpeed,
    int? averageAltitude,
    String? createdOn,
  }) : super(
            id: id ?? 0,
            userId: userId ?? '',
            startLocationId: startLocationId ?? 0,
            endLocationId: endLocationId ?? 0,
            distance: distance ?? 0,
            duration: duration ?? 0,
            maxSpeed: maxSpeed ?? 0,
            averageSpeed: averageSpeed ?? 0,
            averageAltitude: averageAltitude ?? 0,
            createdOn: createdOn ?? '');

  static List<TripModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => TripModel.fromJson(json)).toList();

  factory TripModel.fromJson(Map<String, dynamic>? json) => TripModel(
        id: asT<int>(json, 'id'),
        userId: asT<String>(json, 'userId'),
        startLocationId: asT<int>(json, 'startLocationId'),
        endLocationId: asT<int>(json, 'endLocationId'),
        distance: asT<int>(json, 'distance'),
        duration: asT<int>(json, 'duration'),
        maxSpeed: asT<int>(json, 'maxSpeed'),
        averageSpeed: asT<int>(json, 'averageSpeed'),
        averageAltitude: asT<int>(json, 'averageAltitude'),
        createdOn: asT<String>(json, 'createdOn'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'startLocationId': startLocationId,
        'endLocationId': endLocationId,
        'distance': distance,
        'duration': duration,
        'maxSpeed': maxSpeed,
        'averageSpeed': averageSpeed,
        'averageAltitude': averageAltitude,
        'createdOn': createdOn,
      };
}
