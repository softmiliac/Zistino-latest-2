import 'package:admin_dashboard/src/common/utils/close_keyboard.dart';
import 'package:admin_dashboard/src/data/repositories/sec/wallet_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common/services/get_storage_service.dart';
import '../../../../common/utils/app_logger.dart';
import '../../../../common/utils/number_format.dart';
import '../../../../common/utils/show_result_action.dart';
import '../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../data/models/base/base_response.dart';
import '../../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../../../domain/usecases/sec/wallet_usecase.dart';
import '../../base/main_page/controller/main_controller.dart';

class WalletController extends GetxController{
  WalletController(this.transactionWalletUseCase);

  ///Variables ///
  RxInt counter = 500000.obs;
  late TextEditingController shebaController;
  late TextEditingController counterController;
  final LocalStorageService pref = Get.find<LocalStorageService>();
  final MainPageController mainPageController = Get.find<MainPageController>();
  final TransactionWalletUseCase transactionWalletUseCase;
  WalletRepositoryImpl walletRepository = WalletRepositoryImpl();
  RxBool isBusyRequest = false.obs;
  final counterFormKey = GlobalKey<FormState>();

  ///Functions ///
  void increaseCounter(){
    counter.value+=10000;
    counterController.text = formatNumber(counter.value);
    closeKeyboard(Get.context!);
  }
  void decreaseCounter(){
    counter.value-=10000;
    counterController.text = formatNumber(counter.value);
    closeKeyboard(Get.context!);
  }

  @override
  void onInit() {
    super.onInit();
    shebaController = TextEditingController(text: pref.user.sheba);
    counterController = TextEditingController(text: formatNumber(counter.value));
  }

  Future transactionWalletRequest() async {
    try {
      if (isBusyRequest.value == false) {
        isBusyRequest.value = true;
        update();
        TransactionWalletRQM rqm = TransactionWalletRQM(
          userId: pref.user.id,
          senderId: null,
          type: 0,
          price: -counter.value,
          coin: null,
          exchangeRate: 1,
          finished: false
        );

        BaseResponse result = await transactionWalletUseCase.execute(rqm);
        isBusyRequest.value = false;
        update();

        if (result.succeeded == true) {
          showTheResult(
              title: "موفقیت".tr,
              message: 'درخواست با موفقیت ثبت شد',
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar);
        }
        await walletRepository.getUserTotal();
        update();
        closeKeyboard(Get.context!);
        return result;
      } else {
        isBusyRequest.value = false;
        update();
      }
    } catch (e) {
      // List<String> messages = [];
      isBusyRequest.value = false;
      update();
      AppLogger.catchLog(e);
      showTheResult(
          title: "خطـا",
          message: '$e',
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }
}