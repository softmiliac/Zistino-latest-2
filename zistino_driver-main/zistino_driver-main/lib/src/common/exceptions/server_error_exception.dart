import 'package:recycling_machine/src/common/exceptions/server_exception.dart';

import '../constants/exception_constants.dart';


class ServerErrorException extends Failure {
  ServerErrorException(String message)
      : super(
          message: message,
          code: ExceptionConstants.internalServerError,
        );
}
