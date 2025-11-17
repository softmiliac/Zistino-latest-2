
import 'package:get/get.dart';

import '../../../../../data/repositories/base/home_repository.dart';
import '../../../../../data/repositories/inv/driver_delivery_repository.dart';
import '../../../../../domain/usecases/bas/home_usecase.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => FetchHomeUseCase(Get.find<HomeRepositoryImpl>()));
    Get.lazyPut(() => FetchDriverDeliveryUseCase(Get.find<DriverDeliveryRepositoryImpl>()));
    Get.lazyPut(() => DeleteDeliveryUseCase(Get.find<DriverDeliveryRepositoryImpl>()));
    Get.lazyPut(() => HomeController(Get.find(),Get.find(),Get.find()));
  }

}