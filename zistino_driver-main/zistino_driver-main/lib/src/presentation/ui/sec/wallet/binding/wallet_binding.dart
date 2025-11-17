import 'package:get/get.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';
import '../controller/wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionWalletUseCase(Get.find<WalletRepositoryImpl>()));
    Get.lazyPut(() => WalletController(Get.find()));
  }
}