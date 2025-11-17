import 'package:get/get.dart';

import '../../../../../data/repositories/base/category_repository.dart';
import '../../../../../data/repositories/base/driver_delivery_repository.dart';
import '../../../../../data/repositories/pro/product_repository.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../../../../../domain/usecases/bas/driver_delivery_usecase.dart';
import '../../../../../domain/usecases/pro/residue_usecase.dart';
import '../controller/residue_controller.dart';

class ResiduePriceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchCategoryUseCase(Get.find<CategoryRepositoryImpl>()));
    Get.lazyPut(() => ResidueUseCase(Get.find<ProductRepositoryIml>()));

    Get.lazyPut(() => ResidueController(Get.find(),Get.find()));
  }
}
