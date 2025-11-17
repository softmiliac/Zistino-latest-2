import 'package:zistino/src/common/exceptions/server_exception.dart';
import 'package:get/get.dart';

import '../constants/exception_constants.dart';


class NoInternetException extends Failure {
  NoInternetException()
      : super(
          message: "problem_connecting".tr,
          code: ExceptionConstants.noInternet,
        );
}
