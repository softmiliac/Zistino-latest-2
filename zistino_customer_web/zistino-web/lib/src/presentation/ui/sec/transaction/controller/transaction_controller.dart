import 'package:get/get.dart';

import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../domain/entities/sec/wallet.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';

class TransactionController extends GetxController with StateMixin<List<Wallet>> {
  TransactionController(this.walletHistoryUseCase);
  LocalStorageService pref = Get.find<LocalStorageService>();
  RxInt selectedTab = RxInt(0);

  WalletHistoryUseCase walletHistoryUseCase;
  List<Wallet>? rpm;


  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<List<Wallet>?> fetchData() async {
    try {
        change(null, status: RxStatus.loading());
        rpm = await walletHistoryUseCase.execute();
        if ((rpm?.isEmpty ?? false || rpm == null)) {
          change([], status: RxStatus.empty());
          update();
        } else {
          change(rpm, status: RxStatus.success());
          update();
        }
        return rpm;
    } catch (e) {
      AppLogger.catchLog(e);
      change([], status: RxStatus.error('$e'));
    }
  }

}
