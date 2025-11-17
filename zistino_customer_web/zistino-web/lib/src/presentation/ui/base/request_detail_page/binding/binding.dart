
import 'package:get/get.dart';
import '../../../../../data/repositories/sec/orders_repository.dart';
import '../../../../../domain/usecases/sec/orders_usecase.dart';
import '../controller/request_detail_controller.dart';

class RequestDetailBinding extends Bindings{
  @override
  void dependencies() {

    Get.lazyPut(() => OrderDetailUseCase(Get.find<OrdersRepositoryImpl>()));
    Get.lazyPut(() => RequestDetailController(Get.find()));
  }

}