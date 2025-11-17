import 'package:recycling_machine/src/common/exceptions/server_exception.dart';

import '../constants/exception_constants.dart';


class ForbiddenException extends Failure {
  ForbiddenException(String message)
      : super(
          message: message,
          code: ExceptionConstants.forbidden,
        );
}
