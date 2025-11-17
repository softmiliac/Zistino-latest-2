import '../../../data/models/pro/category_model.dart';
import '../../entities/base/home_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryModel>> getCategory({bool isFromLocal = true});
}
