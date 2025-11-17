
import 'dart:convert' as convert;

import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/pro/color_entity.dart';
import '../base/safe_convert.dart';

class ColorsModel extends ColorEntity {
  ColorsModel({
    int id = 0,
    String name = "",
    String code = "",
    String locale = "",
  }) : super(name, id: id, code: code, locale: locale);

  factory ColorsModel.fromJson(Map<String, dynamic> json) {
    return ColorsModel(
      id: asT<int>(json, 'id'),
      code: asT<String>(json, 'code'),
      name: asT<String>(json, 'name'),
      locale: asT<String>(json, 'locale'),
    );
  }

  factory ColorsModel.fromJsonChild(Map<String, dynamic> json) {
    return ColorsModel(
      id: asT<int>(json, 'id'),
      code: asT<String>(json, 'code'),
      name: asT<String>(json, 'name'),
      locale: asT<String>(json, 'locale'),
    );
  }

  static List<ColorsModel> fromJsonList(String string) {
    try {
      List<dynamic> _json = convert.json.decode(string);

      return _json.map((json) {
        var a = ColorsModel.fromJson(json );

        return a;
      }).toList();
    } catch (e) {
      AppLogger.e('$e');
      return [];
    }
  }

  static ColorEntity toEntity(final ColorEntity item) {
    return ColorEntity(item.name, id: item.id, locale: item.locale, code: item.code);
  }

  static ColorEntity fromEntity(final ColorEntity item) {
    return ColorEntity(item.name, id: item.id, code: item.code, locale: item.locale);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'locale': locale,
      };
}
