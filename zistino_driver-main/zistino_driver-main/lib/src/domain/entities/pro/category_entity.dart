

import '../../../data/enums/pro/category_type.dart';

// part 'category_entity.g.dart';

// @Collection()
class CategoryEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;

  final int id;
  final int? parentId;
  final String name;
  final String description;
  final String imagePath;
  CategoryType type;

  // @Ignore()
  List<CategoryEntity?>? children;

  CategoryEntity(
      {this.name = '',this.id = 0,
        this.parentId,
        this.description = "",
        this.imagePath = "",
        this.type = CategoryType.product,
        this.children = const []});
}
