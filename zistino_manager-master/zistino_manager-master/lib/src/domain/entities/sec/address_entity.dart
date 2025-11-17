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
  double latitude;
  double longitude;
  String email;
  String plate;
  String unit;
  String city;
  String country;
  String province;
  String? companyName;
  String? companyNumber;
  String? vatNumber;

  AddressEntity({
    this.id = 0,
    this.userId = "",
    this.address = "",
    this.zipCode = "",
    this.fullName = "",
    this.phoneNumber = "",
    this.plate = "",
    this.unit = "",
    this.latitude = 0,
    this.longitude = 0,
    this.country = "",
    this.province = "",
    this.description = "",
    this.city = "",
    this.email = "",
    this.companyName,
    this.companyNumber,
    this.vatNumber,
  });
}
