import 'package:admin_zistino/src/data/models/base/safe_convert.dart';
import '../../../domain/entities/base/driver_entity.dart';

class DriverModel extends DriverEntity {
  DriverModel({
    final String? id,
    final String? userName,
    final String? firstName,
    final String? lastName,
    final String? email,
    final bool? isActive,
    final bool? emailConfirmed,
    final String? phoneNumber,
    final String? imageUrl,
    final String? thumbnail,
    final String? companyName,
    final String? companyNumber,
    final String? vatNumber,
    final String? representative,
    final String? sheba,
    final String? bankname,
    final String? birthdate,
    final String? codeMeli,
  }) : super(
          id: id,
          userName: userName,
          firstName: firstName,
          lastName: lastName,
          email: email,
          isActive: isActive,
          emailConfirmed: emailConfirmed,
          phoneNumber: phoneNumber,
          imageUrl: imageUrl,
          thumbnail: thumbnail,
          companyName: companyName,
          companyNumber: companyNumber,
          vatNumber: vatNumber,
          representative: representative,
          sheba: sheba,
          bankname: bankname,
          birthdate: birthdate,
        );

  factory DriverModel.fromJson(Map<String, dynamic>? json) => DriverModel(
        id: asT<String>(json, 'id'),
        userName: asT<String>(json, 'userName'),
        firstName: asT<String>(json, 'firstName'),
        lastName: asT<String>(json, 'lastName'),
        email: asT<String>(json, 'email'),
        isActive: asT<bool>(json, 'isActive'),
        emailConfirmed: asT<bool>(json, 'emailConfirmed'),
        phoneNumber: asT<String>(json, 'phoneNumber'),
        imageUrl: asT<String>(json, 'imageUrl'),
        thumbnail: asT<String>(json, 'thumbnail'),
        companyName: asT<String>(json, 'companyName'),
        companyNumber: asT<String>(json, 'companyNumber'),
        vatNumber: asT<String>(json, 'vatNumber'),
        representative: asT<String>(json, 'representative'),
        sheba: asT<String>(json, 'sheba'),
        bankname: asT<String>(json, 'bankname'),
        birthdate: asT<String>(json, 'birthdate'),
      );

  static List<DriverModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) {
        var a = DriverModel.fromJson(json);

        return a;
      }).toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isActive': isActive,
        'emailConfirmed': emailConfirmed,
        'phoneNumber': phoneNumber,
        'imageUrl': imageUrl,
        'thumbnail': thumbnail,
        'companyName': companyName,
        'companyNumber': companyNumber,
        'vatNumber': vatNumber,
        'representative': representative,
        'sheba': sheba,
        'bankname': bankname,
        'birthdate': birthdate,
      };

  DriverModel.castFromEntity(final DriverEntity item)
      : super(
          id: item.id,
          userName: item.userName,
          firstName: item.firstName,
          lastName: item.lastName,
          email: item.email,
          isActive: item.isActive,
          emailConfirmed: item.emailConfirmed,
          phoneNumber: item.phoneNumber,
          imageUrl: item.imageUrl,
          thumbnail: item.thumbnail,
          companyName: item.companyName,
          companyNumber: item.companyNumber,
          vatNumber: item.vatNumber,
          representative: item.representative,
          sheba: item.sheba,
          bankname: item.bankname,
          birthdate: item.birthdate,
          codeMeli: item.codeMeli,
        );
}
