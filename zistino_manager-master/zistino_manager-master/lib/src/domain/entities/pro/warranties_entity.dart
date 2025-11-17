

// part 'warranties_entity.g.dart';

// @Collection()
class WarrantiesEntity {
  // @Id()
  // int localID = Isar.autoIncrement;

  final int id;
  final String name;
  final String imageUrl;
  final String description;
  final String locale;

  WarrantiesEntity({
    this.id = 0,
    this.name = "",
    this.imageUrl = "",
    this.description = '',
    this.locale = '',

  });
}