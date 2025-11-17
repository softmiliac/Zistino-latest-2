import 'package:admin_zistino/src/data/repositories/base/category_repository.dart';
import 'package:admin_zistino/src/domain/entities/pro/category_entity.dart';
import '../../../common/usecases/usecase.dart';
import '../../repositories/bas/category_repository.dart';

class FetchCategoryUseCase extends NoParamUseCase<List<CategoryEntity>>{
  final CategoryRepositoryImpl _categoryRepository = CategoryRepositoryImpl();

  @override
  Future<List<CategoryEntity>> execute() {
    return _categoryRepository.getCategory();
  }

}

