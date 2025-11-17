import 'package:recycling_machine/src/domain/entities/pro/category_entity.dart';
import '../../../common/usecases/usecase.dart';
import '../../repositories/bas/category_repository.dart';

class FetchCategoryUseCase extends NoParamUseCase<List<CategoryEntity>>{
  final CategoryRepository _categoryRepository;
  FetchCategoryUseCase(this._categoryRepository);

  @override
  Future<List<CategoryEntity>> execute() {
    return _categoryRepository.getCategory();
  }

}

