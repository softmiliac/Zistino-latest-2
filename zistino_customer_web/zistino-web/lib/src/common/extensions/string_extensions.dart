import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'datetime_extentions.dart';

extension IntParse on String {
  int intParse() {
    return int.parse(this);
  }
}

extension ToJson on String {
  Map<String, dynamic> toJson() {
    var item = json.decode(this);
    return item;
  }

  DateTime fromJsonDateTime() {
    final DateFormat _dateFormatter = DateFormat(serverDateFormat);

    return _dateFormatter.parse(this);
  }

  List<String> toJsonList() {
    var item = json.decode(this);
    return item;
  }

  List<String> toStringList() {
    try {
      List<String> items = [];
      List<dynamic> jsonItems = json.decode(this);

      // jsonItems.map((e) => items.add("$e"));
      for (var element in jsonItems) {
        items.add("$element");
      }
      return items;
    } catch (e) {
      debugPrintThrottled("$e");
      return [];
    }
  }
}
