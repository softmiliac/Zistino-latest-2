

import '../base/safe_convert.dart';

class CheckCodeForgotPasswordRQM {
  final String email;
  final String code;

  CheckCodeForgotPasswordRQM({
    this.email = "",
    this.code = "",
  });

  factory CheckCodeForgotPasswordRQM.fromJson(Map<String, dynamic>? json) => CheckCodeForgotPasswordRQM(
    email: asT<String>(json, 'email'),
    code: asT<String>(json, 'code'),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'code': code,
  };
}

