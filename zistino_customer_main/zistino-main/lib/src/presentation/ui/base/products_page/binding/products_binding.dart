import 'package:get/get.dart';

import '../../../../../data/repositories/pro/product_repository.dart';
import '../../../../../domain/repositories/pro/product_repository.dart';
import '../../../../../domain/usecases/bas/search_usecase.dart';
import '../controller/products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchProductByCategoryUseCase(Get.find<ProductRepositoryImpl>()),
    //     );
    Get.lazyPut(() => ProductsController(Get.find()));
    // Get.lazyPut(() => GetProductsByCategoryUseCase(Get.find<ProductRepositoryImpl>()));
    Get.lazyPut(() => GetProductsBySearchUseCase(Get.find<ProductRepositoryImpl>()));
  }
}
