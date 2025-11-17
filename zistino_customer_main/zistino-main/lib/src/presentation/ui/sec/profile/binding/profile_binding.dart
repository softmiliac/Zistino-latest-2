import 'package:get/get.dart';

import '../../../../../data/repositories/sec/user_repository.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';
import '../controller/profle_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
    // Get.lazyPut(() => UploadFileUseCase(Get.find<UserRepositoryImpl>()));
  }
}