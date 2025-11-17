import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/auth_model.dart';

abstract class AuthRepository {
  Future<LoginResult> loginRequest(LoginRQM rqm);
  Future<bool> validateEmailRequest(ValidateEmailRQM rqm);
}
