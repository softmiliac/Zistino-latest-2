import 'package:get/get.dart';

import '../../../../../data/repositories/base/category_repository.dart';

import '../../../../../data/repositories/inv/driver_delivery_repository.dart';
import '../../../../../data/repositories/pro/product_repository.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';

import '../../../../../domain/usecases/inv/delivery_usecase.dart';
import '../../../../../domain/usecases/pro/product_usecase.dart';
import '../controller/residue_controller.dart';

class ResidueDeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchCategoryUseCase(Get.find<CategoryRepositoryImpl>()));
    Get.lazyPut(() => ResidueUseCase(Get.find<ProductRepositoryImpl>()));
    Get.lazyPut(() => CreateDeliveryUseCase(Get.find<DriverDeliveryRepositoryImpl>()));

    Get.lazyPut(() => ResidueDeliveryController(Get.find(),Get.find(),Get.find()));
  }
}
