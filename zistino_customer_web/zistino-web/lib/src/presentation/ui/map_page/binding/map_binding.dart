import 'package:get/get.dart';

import '../../../../data/repositories/inv/driver_delivery_repository.dart';
import '../../../../data/repositories/sec/address_repository.dart';
import '../../../../domain/usecases/inv/delivery_usecase.dart';
import '../../../../domain/usecases/sec/address_usecase.dart';
import '../controller/map_controller.dart';

class MapBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MyMapController(Get.find(),Get.find()));
    Get.lazyPut(() => CreateDeliveryUseCase(Get.find<DriverDeliveryRepositoryImpl>()));
    Get.lazyPut(() => AddAddressUseCase(Get.find<AddressRepositoryImpl>()));
    Get.lazyPut(() => UpdateAddressUseCase(Get.find<AddressRepositoryImpl>()));

  }

}