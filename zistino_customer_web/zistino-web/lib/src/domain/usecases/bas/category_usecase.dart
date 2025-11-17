

import '../../../common/usecases/usecase.dart';
import '../../../data/models/pro/category_model.dart';
import '../../../data/repositories/base/category_repository.dart';
import '../../entities/base/home_entity.dart';
import '../../repositories/bas/category_repository.dart';

class FetchCategoryUseCase extends NoParamUseCase<List<CategoryModel>>{
  final CategoryRepository _categoryRepository;
  FetchCategoryUseCase(this._categoryRepository);

  @override
  Future<List<CategoryModel>> execute() {
    return _categoryRepository.getCategory();
  }

}