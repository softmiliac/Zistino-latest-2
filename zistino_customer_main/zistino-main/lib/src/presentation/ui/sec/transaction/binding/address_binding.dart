import 'package:get/get.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';
import '../controller/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletHistoryUseCase(Get.find<WalletRepositoryImpl>()));
    Get.lazyPut(() => TransactionController(Get.find()));
  }
}