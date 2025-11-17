import '../../../data/models/pro/category_model.dart';
import '../../entities/base/home_entity.dart';
import '../../entities/pro/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategory();
}
