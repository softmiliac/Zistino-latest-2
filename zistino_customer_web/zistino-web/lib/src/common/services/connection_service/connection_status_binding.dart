import 'package:get/get.dart';
import 'connection_status.dart';

class ConnectionStatusBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ConnectionStatusController>(() => ConnectionStatusController());
  }
}