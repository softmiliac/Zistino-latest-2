

// part 'specification_entity.g.dart';

// @Collection()
class SpecificationEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;

  final String size;
  final String level;


  SpecificationEntity({this.size = "", this.level = ""});
}
