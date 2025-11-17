import '../../../domain/entities/sec/address_entity.dart';
import '../../../domain/entities/sec/zone_entity.dart';
import '../base/safe_convert.dart';

class ZoneModel extends ZoneEntity {
  ZoneModel({
    int? id,
    String? zone,
    String? zonepath,
    String? description,
    String? address
  }) : super(
            id: id ?? 0,
            zone: zone ?? '',
            zonepath: zonepath ?? '',
            description: description ?? '',
            address: address ?? ''
  );

  factory ZoneModel.fromJson(Map<String, dynamic> json) => ZoneModel(
        id: asT<int>(json, 'id'),
        zone: asT<String>(json, 'zone'),
        zonepath: asT<String>(json, 'zonepath'),
        description: asT<String>(json, 'description'),
        address: asT<String>(json, 'address'),
      );

  static List<ZoneModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => ZoneModel.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'zone': zone,
        'zonepath': zonepath,
        'description': description,
        'address': address
      };

  ZoneModel.castFromEntity(final ZoneEntity item)
      : super(
            id: item.id,
            zone: item.zone,
            zonepath: item.zonepath,
            description: item.description,
            address: item.address);
}
