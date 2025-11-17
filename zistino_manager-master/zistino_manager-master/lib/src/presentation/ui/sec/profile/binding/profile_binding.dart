import 'package:get/get.dart';

import '../../../../../data/repositories/sec/user_repository.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';
import '../controller/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TotalWalletUseCase(Get.find<WalletRepositoryImpl>()));
    Get.lazyPut(() => ProfileController(Get.find()));
    // Get.lazyPut(() => UploadFileUseCase(Get.find<UserRepositoryImpl>()));
  }
}