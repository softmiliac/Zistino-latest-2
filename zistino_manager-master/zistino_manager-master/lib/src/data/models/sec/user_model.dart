import '../../../domain/entities/sec/user.dart';
import '../base/safe_convert.dart';

class UserModel extends User {
  UserModel({
    String id = "",
    String userName = "",
    String firstName = "",
    String lastName = "",
    String email = "",
    bool isActive = false,
    bool emailConfirmed = false,
    String phoneNumber = "",
    String imageUrl = "",
    String companyName = "",
    String vatNumber = "",
    String representative = '',
    String sheba = '',
    String bankname = '',
    String birthdate = '',
    String codeMeli = '',
    String representativeBy = '',
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
    companyName: companyName,
    vatNumber: vatNumber,
    representative: representative,
    sheba: sheba,
    bankname: bankname,
    birthdate: birthdate,
    codeMeli: codeMeli,
    representativeBy: representativeBy,
  );

/*  UserModel.fromEntity(final User item)
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
          companyName: item.companyName,
          vatNumber: item.vatNumber,
        );*/

  static User toEntity(final User item) {
    return User(
      id: item.id,
      userName: item.userName,
      firstName: item.firstName,
      lastName: item.lastName,
      email: item.email,
      isActive: item.isActive,
      emailConfirmed: item.emailConfirmed,
      phoneNumber: item.phoneNumber,
      imageUrl: item.imageUrl,
      companyName: item.companyName,
      vatNumber: item.vatNumber,
      representative: item.representative,
      sheba: item.sheba,
      bankname: item.bankname,
      birthdate: item.birthdate,
      codeMeli: item.codeMeli,
      representativeBy: item.representativeBy,
    );
  }

  factory UserModel.fromEntity(final User item) {
    return UserModel(
      id: item.id,
      userName: item.userName,
      firstName: item.firstName,
      lastName: item.lastName,
      email: item.email,
      isActive: item.isActive,
      emailConfirmed: item.emailConfirmed,
      phoneNumber: item.phoneNumber,
      imageUrl: item.imageUrl,
      companyName: item.companyName,
      vatNumber: item.vatNumber,
      representative: item.representative,
      sheba: item.sheba,
      bankname: item.bankname,
      birthdate: item.birthdate,
      codeMeli: item.codeMeli,
      representativeBy: item.representativeBy,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
    id: asT<String>(json, 'id'),
    userName: asT<String>(json, 'userName'),
    firstName: asT<String>(json, 'firstName'),
    lastName: asT<String>(json, 'lastName'),
    email: asT<String>(json, 'email'),
    isActive: asT<bool>(json, 'isActive'),
    emailConfirmed: asT<bool>(json, 'emailConfirmed'),
    phoneNumber: asT<String>(json, 'phoneNumber'),
    imageUrl: asT<String>(json, 'imageUrl'),
    companyName: asT<String>(json, 'companyName'),
    vatNumber: asT<String>(json, 'vatNumber'),
    representative: asT<String>(json, 'representative'),
    sheba: asT<String>(json, 'sheba'),
    bankname: asT<String>(json, 'bankname'),
    birthdate: asT<String>(json, 'birthdate'),
    codeMeli: asT<String>(json, 'codeMeli'),
    representativeBy: asT<String>(json, 'representativeBy'),
  );

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
    'companyName': companyName,
    'vatNumber': vatNumber,
    'representative': representative,
    'sheba': sheba,
    'bankname': bankname,
    'birthdate': birthdate,
    'codeMeli': codeMeli,
    'representativeBy': representativeBy,
  };
}
