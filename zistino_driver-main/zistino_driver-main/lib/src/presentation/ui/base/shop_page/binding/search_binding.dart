import 'package:get/get.dart';

import '../../../../../data/repositories/pro/product_repository.dart';
import '../../../../../domain/repositories/pro/product_repository.dart';
import '../../../../../domain/usecases/bas/search_usecase.dart';
import '../controller/shop_controller.dart';

class ShopBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => FetchProductByCategoryUseCase(Get.find<ProductRepositoryImpl>()),
    //     );
    Get.lazyPut(() => ShopController(Get.find()));
    Get.lazyPut(() => SearchUseCase(Get.find<ProductRepositoryIml>()));
  }
}
