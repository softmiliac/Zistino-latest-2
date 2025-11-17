import '../../../domain/entities/sec/address_entity.dart';
import '../base/safe_convert.dart';

class AddressModel extends AddressEntity {
  AddressModel({
    int? id,
    String? userId,
    String? address,
    String? zipCode,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? description,
    String? plate,
    String? unit,
    String? city,
    String? country,
    String? province,
    String? companyName,
    String? companyNumber,
    String? vatNumber,
    double? latitude,
    double? longitude,
    List<String>? messages,
    bool? succeeded,
  }) : super(
          id: id ?? 0,
          userId: userId ?? '',
          address: address ?? '',
          zipCode: zipCode ?? '',
          fullName: fullName ?? '',
          phoneNumber: phoneNumber ?? '',
          plate: plate ?? '',
          city: city ?? '',
          unit: unit ?? '',
          country: country ?? '',
          email: email ?? '',
          description: description ?? '',
          province: province ?? '',
    latitude: latitude ?? 0,
    longitude: longitude ?? 0,
          companyName: companyName,
          companyNumber: companyNumber,
          vatNumber: vatNumber,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: asT<int>(json, 'id'),
        userId: asT<String>(json, 'userId'),
        address: asT<String>(json, 'address'),
        zipCode: asT<String>(json, 'zipCode'),
        email: asT<String>(json, 'email'),
        fullName: asT<String>(json, 'fullName'),
        phoneNumber: asT<String>(json, 'phoneNumber'),
        description: asT<String>(json, 'description'),
        unit: asT<String>(json, 'unit'),
        plate: asT<String>(json, 'plate'),
        province: asT<String>(json, 'province'),
        city: asT<String>(json, 'city'),
        country: asT<String>(json, 'country'),
        companyName: asT<String>(json, 'companyName'),
        companyNumber: asT<String>(json, 'companyNumber'),
        vatNumber: asT<String>(json, 'vatNumber'),
    latitude: asT<double>(json, 'latitude'),
    longitude: asT<double>(json, 'longitude'),
      );

  static List<AddressModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => AddressModel.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'address': address,
        'zipCode': zipCode,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'city': city,
        'email': email,
        'unit': unit,
        'plate': plate,
        'description': description,
        'country': country,
        'province': province,
        'companyName': companyName,
        'companyNumber': companyNumber,
        'vatNumber': vatNumber
      };

  AddressModel.castFromEntity(final AddressEntity item)
      : super(
            id: item.id,
            userId: item.userId,
            address: item.address,
            email: item.email,
            zipCode: item.zipCode,
            fullName: item.fullName,
            phoneNumber: item.phoneNumber,
            city: item.city,
            plate: item.plate,
            unit: item.unit,
            description: item.description,
            province: item.province,
            country: item.country,
            companyName: item.companyName,
            companyNumber: item.companyNumber,
            vatNumber: item.vatNumber);
}
