
import 'dart:convert' as convert;

import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/pro/specification_entity.dart';
import '../base/safe_convert.dart';

class SpecificationModel extends SpecificationEntity {
  SpecificationModel({
    String? size,
    String? level,
  }) : super(size: size ?? '', level: level ?? '');

  factory SpecificationModel.fromJson(Map<String, dynamic> json) {
    return SpecificationModel(
      size: asT<String>(json, 'size'),
      level: asT<String>(json, 'level'),
    );
  }

  static SpecificationModel fromJsonString(String string) {
    try {
      Map<String, dynamic>? json = convert.json.decode(string);
      return SpecificationModel.fromJson(json ?? {});
    } catch (e) {
      AppLogger.e('$e');
      throw ('$e');
    }
  }



    Map<String, dynamic> toJson() => {
        'size': size,
        'level': level,
      };
}
