import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'datetime_extentions.dart';

extension ColorFromString on String {
  int toColor() {
    return int.parse(this.replaceAll('#', ''));
  }
}
