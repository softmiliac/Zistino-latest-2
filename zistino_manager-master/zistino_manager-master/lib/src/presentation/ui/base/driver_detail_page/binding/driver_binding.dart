import 'package:get/get.dart';

import '../controller/driver_detail_cotroller.dart';

class DriverBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DriverDetailController());
  }

}