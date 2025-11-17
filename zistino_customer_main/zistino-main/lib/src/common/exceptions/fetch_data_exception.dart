

import 'package:zistino/src/common/exceptions/server_exception.dart';

class FetchDataException extends Failure {
  FetchDataException()
      : super(
    code: "fetch-data",
    message: "Error During Communication",
    // details: details,
  );
}
