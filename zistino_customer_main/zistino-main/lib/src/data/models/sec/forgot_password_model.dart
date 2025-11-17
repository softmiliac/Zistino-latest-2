

import '../base/safe_convert.dart';

class SetNewPasswordRQM {
  final String email;
  final String password;
  final String code;

  SetNewPasswordRQM({
    this.email = "",
    this.password = "",
    this.code = "",
  });

  factory SetNewPasswordRQM.fromJson(Map<String, dynamic>? json) => SetNewPasswordRQM(
    email: asT<String>(json, 'email'),
    password: asT<String>(json, 'password'),
    code: asT<String>(json, 'code'),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'code': code,
  };
}

