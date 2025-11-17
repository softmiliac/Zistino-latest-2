
// part 'user.g.dart';

// @Collection()
class User {
  // @Id()
  // int localeID = Isar.autoIncrement;
  String id;
  String userName;
  String firstName;
  String lastName;
  String email;
  bool isActive;
  bool emailConfirmed;
  String phoneNumber;
  String imageUrl;
  String companyName;
  String vatNumber;
  String representative;
  String sheba;
  String bankname;
  String birthdate;
  String codeMeli;
  String representativeBy;
  String language;
  String country;
  String city;

  User({
    this.id = "",
    this.userName = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.isActive = false,
    this.emailConfirmed = false,
    this.phoneNumber = "",
    this.imageUrl = "",
    this.companyName = "",
    this.vatNumber = "",
    this.representative = "",
    this.sheba = "",
    this.bankname = "",
    this.birthdate = "",
    this.codeMeli = "",
    this.representativeBy = "",
    this.language = "",
    this.country = "",
    this.city = "",
  });

}
