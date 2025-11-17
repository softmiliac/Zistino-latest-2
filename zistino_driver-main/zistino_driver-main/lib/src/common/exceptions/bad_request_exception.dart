


import 'package:recycling_machine/src/common/exceptions/server_exception.dart';

import '../constants/exception_constants.dart';

class BadRequestException extends Failure {
  BadRequestException(String message)
      : super(
          message: message,
          code: ExceptionConstants.badRequest,
        );
}
