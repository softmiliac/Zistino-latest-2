import '../../../domain/entities/sec/user_zone.dart';
import '../base/safe_convert.dart';

class UserZoneModel extends UserZoneEntity {
  UserZoneModel(
      {final int id = 0,
      final String userId = '',
      final int zoneId = 0,
      final String zone = '',
      final String firstName = '',
      final String lastName = '',
      final String lastModifiedOn = ''})
      : super(
          id: id,
          userId: userId,
          zoneId: zoneId,
          zone: zone,
          firstName: firstName,
          lastName: lastName,
          lastModifiedOn: lastModifiedOn,
        );

  static List<UserZoneModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => UserZoneModel.fromJson(json)).toList();


  factory UserZoneModel.fromJson(Map<String, dynamic>? json) => UserZoneModel(
        id: asT<int>(json, 'id'),
        userId: asT<String>(json, 'userId'),
        zoneId: asT<int>(json, 'zoneId'),
        zone: asT<String>(json, 'zone'),
        firstName: asT<String>(json, 'firstName'),
        lastName: asT<String>(json, 'lastName'),
        lastModifiedOn: asT<String>(json, 'lastModifiedOn'),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'zoneId': zoneId,
        'zone': zone,
        'firstName': firstName,
        'lastName': lastName,
        'lastModifiedOn': lastModifiedOn,
      };
}
