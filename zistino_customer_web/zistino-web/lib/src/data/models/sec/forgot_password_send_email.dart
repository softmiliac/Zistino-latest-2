import '../base/safe_convert.dart';

class ForgotPasswordSendEmailRQM {
  final String email;

  ForgotPasswordSendEmailRQM({
    this.email = "",
  });

  factory ForgotPasswordSendEmailRQM.fromJson(Map<String, dynamic>? json) =>
      ForgotPasswordSendEmailRQM(
        email: asT<String>(json, 'email'),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
