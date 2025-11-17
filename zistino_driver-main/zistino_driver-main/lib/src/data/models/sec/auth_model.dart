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
  final String email;
  final String userName;
  final String password;
  final String confirmPassword;

  SignupRQM({
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.userName = "",
    this.password = "",
    this.confirmPassword = "",
  });

  factory SignupRQM.fromJson(Map<String, dynamic>? json) => SignupRQM(
    firstName: asT<String>(json, 'firstName'),
    lastName: asT<String>(json, 'lastName'),
    email: asT<String>(json, 'email'),
    userName: asT<String>(json, 'userName'),
    password: asT<String>(json, 'password'),
    confirmPassword: asT<String>(json, 'confirmPassword'),
  );

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'userName': userName,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}

/// Confirmation code model ///

class ConfirmationCodeRQM {
  final String email;
  final String confirmationCode;

  ConfirmationCodeRQM({
    this.email = "",
    this.confirmationCode = "",
  });

  factory ConfirmationCodeRQM.fromJson(Map<String, dynamic>? json) => ConfirmationCodeRQM(
    email: asT<String>(json, 'email'),
    confirmationCode: asT<String>(json, 'confirmationCode'),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'confirmationCode': confirmationCode,
  };
}

/// Forgot password model ///

class ForgotPasswordRQM {
  final String email;

  ForgotPasswordRQM({
    this.email = "",
  });

  factory ForgotPasswordRQM.fromJson(Map<String, dynamic>? json) => ForgotPasswordRQM(
    email: asT<String>(json, 'email'),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}

/// Reset password model ///

class ResetPasswordRQM {
  final String email;
  final String password;
  final String code;

  ResetPasswordRQM({
    this.email = "",
    this.password = "",
    this.code = "",
  });

  factory ResetPasswordRQM.fromJson(Map<String, dynamic>? json) => ResetPasswordRQM(
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

/// Validate email model ///

class ValidateEmailRQM {
  final String email;

  ValidateEmailRQM({
    this.email = "",
  });

  factory ValidateEmailRQM.fromJson(Map<String, dynamic>? json) => ValidateEmailRQM(
    email: asT<String>(json, 'email'),
  );

  Map<String, dynamic> toJson() => {
    'email': email,
  };
}