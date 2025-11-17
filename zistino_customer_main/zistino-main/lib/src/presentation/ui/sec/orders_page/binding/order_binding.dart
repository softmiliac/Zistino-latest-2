import 'package:zistino/src/presentation/ui/sec/orders_page/controller/orders_controller.dart';
import 'package:get/get.dart';

import '../../../../../data/repositories/inv/driver_delivery_repository.dart';
import '../../../../../domain/usecases/inv/delivery_usecase.dart';

class OrderBinding extends Bindings{

  @override
  void dependencies() {
  Get.lazyPut(() => OrdersController());
  }

}