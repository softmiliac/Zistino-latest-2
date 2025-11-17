import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/app_logger.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

const String dateFormat = "yyyy-MM-dd HH:mm:ss";
const String serverDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
String getDate(String date) {
  switch (Get.locale?.languageCode) {
    case 'en':
      return _dateFormatEn(date);
    case 'fa':
      return _dateFormatPersian(date);
  }
  return _dateFormatEn(date);
}

String _dateFormatEn(String date) {
  try {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    DateTime time = DateTime.parse(date);
    String format = formatter.format(time);
    return format;
  } catch (e) {
    AppLogger.e('$e');
    return '';
  }
}

String _dateFormatPersian(String time) {
  try {
    Jalali jalali = DateTime.parse(time.replaceAll('T', ' ') ?? '').toJalali();
    String date =
        '${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}';
    return date;
  } catch (e) {
    AppLogger.e('$e');
    return '';
  }
}

// String getDate(DateTime time) {
//   final DateFormat formatter = DateFormat('d MMMM yyyy');
//   return formatter.format(time);
// }

String getTime(DateTime time) {
  final DateFormat formatter = DateFormat('hh:mm');
  return formatter.format(time);
}

 getTimeFromDate(DateTime time) {
  return DateFormat.MEd().format(time);
}

extension ToJson on DateTime {


  String toJson() {
    final DateFormat _dateFormatter = DateFormat(serverDateFormat);

    return _dateFormatter.format(this);
  }
}
