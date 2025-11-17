import 'package:get/get.dart';
import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/repositories/bas/category_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/pro/category_model.dart';
import '../../providers/remote/base/category_api.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  @override
  Future<List<CategoryModel>> getCategory() async {
    try {
      BaseResponse response = await CategoryApi().fetchCategory();
      List<CategoryModel> data = CategoryModel.fromJsonList(response.data as List);
      return data;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }
}
