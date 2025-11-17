import 'package:admin_zistino/src/data/models/base/safe_convert.dart';

import '../../../domain/entities/base/locations_entity.dart';

class LocationsModel extends LocationsEntity {
  LocationsModel({
    final int? id,
    final String? userId,
    final int? tripId,
    final double? latitude,
    final double? longitude,
    final int? speed,
    final String? heading,
    final double? altitude,
    final int? satellites,
    final int? hdop,
    final int? gsmSignal,
    final int? odometer,
    final String? createdOn,
  }) : super(
          id: id ?? 0,
          userId: userId ?? '0',
          tripId: tripId ?? 0,
          latitude: latitude ?? 0,
          longitude: longitude ?? 0,
          speed: speed ?? 0,
          heading: heading ?? '',
          altitude: altitude ?? 0,
          satellites: satellites ?? 0,
          hdop: hdop ?? 0,
          gsmSignal: gsmSignal ?? 0,
          odometer: odometer ?? 0,
          createdOn: createdOn ?? '',
        );
  static List<LocationsModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => LocationsModel.fromJson(json)).toList();
  factory LocationsModel.fromJson(Map<String, dynamic>? json) => LocationsModel(
        id: asT<int>(json, 'id'),
        userId: asT<String>(json, 'userId'),
        tripId: asT<int>(json, 'tripId'),
        latitude: asT<double>(json, 'latitude'),
        longitude: asT<double>(json, 'longitude'),
        speed: asT<int>(json, 'speed'),
        heading: asT<String>(json, 'heading'),
        altitude: asT<double>(json, 'altitude'),
        satellites: asT<int>(json, 'satellites'),
        hdop: asT<int>(json, 'hdop'),
        gsmSignal: asT<int>(json, 'gsmSignal'),
        odometer: asT<int>(json, 'odometer'),
        createdOn: asT<String>(json, 'createdOn'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
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
        'createdOn': createdOn,
      };
}
