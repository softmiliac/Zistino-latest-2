
import 'package:zistino/src/domain/usecases/sec/orders_usecase.dart';
import 'package:get/get.dart';

import '../../../../../data/repositories/base/home_repository.dart';
import '../../../../../data/repositories/inv/driver_delivery_repository.dart';
import '../../../../../data/repositories/sec/orders_repository.dart';
import '../../../../../domain/usecases/bas/home_usecase.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }

}