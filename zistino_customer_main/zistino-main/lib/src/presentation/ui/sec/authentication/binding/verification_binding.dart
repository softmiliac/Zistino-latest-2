import 'package:get/get.dart';
import '../../../../../data/repositories/sec/auth_repository.dart';
import '../../../../../data/repositories/sec/user_repository.dart';
import '../../../../../domain/usecases/sec/auth_usecase.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../controller/verification_controller.dart';

class VerifyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VerificationController());
  }
}
