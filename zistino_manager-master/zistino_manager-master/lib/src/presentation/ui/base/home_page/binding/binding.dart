import 'package:get/get.dart';

import '../../../../../data/repositories/base/driver_delivery_repository.dart';
import '../../../../../domain/repositories/sec/orders_repository.dart';
import '../../../../../domain/usecases/bas/driver_delivery_usecase.dart';
import '../../../../../domain/usecases/sec/orders_usecase.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => HomeController());


  }
}
