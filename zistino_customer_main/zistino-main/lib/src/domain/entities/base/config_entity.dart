import '../../../data/models/base/config_model.dart';

class ConfigEntity {
  int id;
  String name;
  int type;
  TimeModel? value;

  ConfigEntity({this.id = 0, this.name = '', this.type = 0, this.value});
}

class TimeEntity {
  String start;
  String end;
  String split;

  TimeEntity({this.start = '', this.end = '', this.split = ''});
}
