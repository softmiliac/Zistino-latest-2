
import '../../../common/constants/exception_constants.dart';
import '../../../common/utils/app_logger.dart';
import 'safe_convert.dart';

class BaseResponse<T> {
  final T data;
  final List<String> messages;
  final List<String> errors;
  final bool succeeded;
  final String? exception;

  BaseResponse({
    required this.data,
    this.messages = const [],
    this.errors = const [],
    this.succeeded = false,
    this.exception,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic>? json, Function? fromJsonT) {
    try {
      if (json?['data'] is Map<String, dynamic>) {
        if (fromJsonT != null) {
          return BaseResponse(
            data: fromJsonT(json?['data'].cast<Map<String, dynamic>>()),
            messages:
            asT<List>(json, 'messages').map((e) => e.toString()).toList(),
            errors:
            asT<List>(json, 'errors').map((e) => e.toString()).toList(),
            succeeded: asT<bool>(json, 'succeeded'),
            exception: asT<String?>(json, 'exception'),
          );
        }

        return BaseResponse(
          data: json?['data'] ?? {},
          exception: json?['exception'],
          messages:
          asT<List>(json, 'messages').map((e) => e.toString()).toList(),
          succeeded: asT<bool>(json, 'succeeded'),
        );
      } else {
        return BaseResponse(
          data: asT<T>(json, 'data'),
          messages:
          asT<List>(json, 'messages').map((e) => e.toString()).toList(),
          succeeded: asT<bool>(json, 'succeeded'),
          exception: asT<String>(json, 'exception'),
        );
      }
    } catch (e) {
      AppLogger.catchParse("$e");
      throw (ExceptionConstants.somethingWentWrong);
    }
  }
}
