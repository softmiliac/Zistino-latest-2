import 'package:admin_dashboard/src/data/repositories/pro/product_repository.dart';
import 'package:admin_dashboard/src/domain/usecases/pro/product_usecase.dart';
import 'package:get/get.dart';
import '../../../../../data/repositories/base/category_repository.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../controller/residue_price_controller.dart';

class ResiduePriceBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FetchCategoryUseCase(Get.find<CategoryRepositoryImpl>()));
    Get.lazyPut(() => ResiduePriceController(Get.find(),Get.find()));
    Get.lazyPut(() => ResidueUseCase(Get.find<ProductRepositoryImpl>()));
  }

}