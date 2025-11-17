import 'dart:developer' as developer;
import 'package:logger/logger.dart';

class AppLogger {
  static PrettyPrinter printer = PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      // width of the output
      colors: true,
      // Colorful log messages
      printEmojis: true,
      // Print an emoji for each log message
      printTime: true // Should each log print contain a timestamp
  );

  static e(String error, {String name = ""}) {
    developer.log('e', error: error);
    Logger(printer: printer).e(error);
  }

  static d(String message, {String name = ""}) {
    developer.log(message, name: name);
    Logger(printer: printer).d(message);
  }

  static w(String message, {required String name}) {
    developer.log(message, name: name = "");
    Logger(printer: printer).w(message);
  }

  static i(String message, {String name = ""}) {
    developer.log(message, name: name);
    Logger(printer: printer).i(message);
  }

  static catchLog(dynamic e, {String name = ""}) {
    try {
      developer.log(e, name: name);
      Logger(printer: printer).e(e);
    } catch (e) {
      print("<><<><><><><> catchLog catch ${e.toString()})");
    }
  }

  static catchParse(String e, {String json = ""}) {
    developer.log(e);
    Logger(printer: printer).e(e, json);
  }
}