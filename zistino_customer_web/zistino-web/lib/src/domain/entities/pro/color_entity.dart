

// part 'color_entity.g.dart';

// @Collection()
class ColorEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;

  final int id;
  final String name;
  final String code;
  final String locale;

  ColorEntity(
    this.name, {
    this.id = 0,
    this.code = "",
    this.locale = "",
  });
}
