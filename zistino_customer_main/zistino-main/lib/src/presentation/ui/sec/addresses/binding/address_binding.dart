import 'package:get/get.dart';

import '../../../../../data/repositories/sec/address_repository.dart';
import '../../../../../domain/usecases/sec/address_usecase.dart';
import '../controller/address_controller.dart';

class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddAddressUseCase(Get.find<AddressRepositoryImpl>()));
    Get.lazyPut(() => UpdateAddressUseCase(Get.find<AddressRepositoryImpl>()));
    Get.lazyPut(() => FetchAllAddressUseCase(Get.find<AddressRepositoryImpl>()));
    Get.lazyPut(() => DeleteAddressUseCase(Get.find<AddressRepositoryImpl>()));
    Get.lazyPut(() => AddressesController(Get.find(),Get.find(),Get.find(),Get.find()));
  }
}