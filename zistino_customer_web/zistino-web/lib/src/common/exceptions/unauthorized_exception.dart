import 'package:admin_dashboard/src/common/exceptions/server_exception.dart';

import '../constants/exception_constants.dart';

class UnauthorisedException extends Failure {
  UnauthorisedException(String message)
      : super(
          message: message,
          code: ExceptionConstants.unauthorized,
        );
}
