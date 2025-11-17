import 'dart:convert';

import 'package:zistino/src/data/models/base/safe_convert.dart';
import '../../../domain/entities/base/config_entity.dart';

class
ConfigModel extends ConfigEntity {
  ConfigModel({
    final int? id,
    final String? name,
    final int? type,
    final TimeModel? value,
  }) : super(
      id: id ?? 0,
      name: name ?? '',
      type: type ?? 0,
      value: value ?? TimeModel());

  ConfigModel.castFromEntity(final ConfigEntity item)
      : super(
      id: item.id,
      name: item.name,
      type: item.type,
      value: item.value,
  );

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    TimeModel value;
    try {
      var _json = json['value'];
      if (_json != null) {
        value = TimeModel.fromJson(jsonDecode(_json));
      } else {
        value = TimeModel();
      }
    } catch (e) {
      value = TimeModel();
    }
    return ConfigModel(
      id: asT<int>(json, 'id'),
      name: asT<String>(json, 'name'),
      type: asT<int>(json, 'type'),
      value: value,
    );
  }

  static List<ConfigModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((_json) {
        var a = ConfigModel.fromJson(_json);

        return a;
      }).toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'value': value?.toJson(),

  };
}

class TimeModel extends TimeEntity {
  TimeModel({
    String? start,
    String? end,
    String? split,
  }) : super(
    start: start ?? '',
    end: end ?? '',
    split: split ?? '',
  );

  factory TimeModel.fromJson(Map<String, dynamic> json) {
    return TimeModel(
      start: asT<String>(json, 'start'),
      end: asT<String>(json, 'end'),
      split: asT<String>(json, 'split'),
    );
  }

  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
    'split': split,
  };
}

class ConfigRqm {
  final String name;
  final int type;

  ConfigRqm({
    this.name = '',
    this.type = 0,
  });

  factory ConfigRqm.fromJson(Map<String, dynamic> json) {
    return ConfigRqm(
      name: asT<String>(json, 'name'),
      type: asT<int>(json, 'type'),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'type': type,
      };
}