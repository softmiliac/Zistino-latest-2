// part 'address.g.dart';

// @Collection()
class AddressEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;
  int id;
  String userId;
  String address;
  String zipCode;
  String fullName;
  String phoneNumber;
  String description;
  String email;
  String city;
  String country;
  String province;
  String? companyName;
  String? companyNumber;
  String? vatNumber;
  double? latitude;
  double? longitude;
  String? title;

  AddressEntity({
    this.id = 0,
    this.userId = "",
    this.address = "",
    this.zipCode = "",
    this.fullName = "",
    this.phoneNumber = "",
    this.country = "",
    this.province = "",
    this.description = "",
    this.city = "",
    this.email = "",
    this.companyName,
    this.companyNumber,
    this.vatNumber,
    this.latitude,
    this.longitude,
    this.title,
  });
}
