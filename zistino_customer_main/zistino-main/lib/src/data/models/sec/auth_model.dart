import '../base/safe_convert.dart';

/// Login and signup model ///

class LoginSignupResult {
  final String token;
  final String refreshToken;
  final String refreshTokenExpiryTime;

  LoginSignupResult({
    this.token = "",
    this.refreshToken = "",
    this.refreshTokenExpiryTime = "",
  }) : super();

  factory LoginSignupResult.fromJson(Map<String, dynamic>? json) =>
      LoginSignupResult(
        token: asT<String>(json, 'token'),
        refreshToken: asT<String>(json, 'refreshToken'),
        refreshTokenExpiryTime: asT<String>(json, 'refreshTokenExpiryTime'),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        'refreshTokenExpiryTime': refreshTokenExpiryTime,
      };
}

/// Login model ///

class LoginRQM {
  final String phoneNumber;
  final String code;
  final String token;

  LoginRQM({
    this.phoneNumber = "",
    this.code = "",
    this.token = "",
  });

  factory LoginRQM.fromJson(Map<String, dynamic>? json) => LoginRQM(
    phoneNumber: asT<String>(json, 'phonenumber'),
    code: asT<String>(json, 'code'),
    token: asT<String>(json, 'token'),
      );

  Map<String, dynamic> toJson() => {
        'phonenumber': phoneNumber,
        'code': code,
        'token': token,
      };
}

/// Signup model ///

class SignupRQM {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;

  SignupRQM({
    this.firstName = "",
    this.lastName = "",
    this.userName = "",
    this.email = "",
    this.phoneNumber = "",
    this.password = "",
    this.confirmPassword = "",
  });

  factory SignupRQM.fromJson(Map<String, dynamic>? json) => SignupRQM(
    firstName: asT<String>(json, 'firstName'),
    lastName: asT<String>(json, 'lastName'),
    userName: asT<String>(json, 'userName'),
    email: asT<String>(json, 'email'),
    phoneNumber: asT<String>(json, 'phoneNumber'),
    password: asT<String>(json, 'password'),
    confirmPassword: asT<String>(json, 'confirmPassword'),
  );

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'userName': userName,
    'email': email,
    'phoneNumber': phoneNumber,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}