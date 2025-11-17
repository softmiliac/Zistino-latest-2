import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/models/sec/wallet_model.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/entities/sec/wallet.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';


class ProfileController extends GetxController with StateMixin<User> {
  ProfileController( this._walletUseCase);

  User? user;
  Wallet? walletRpm;
  final TotalWalletUseCase _walletUseCase;
  final UserUseCase _useCase  = UserUseCase();
  final LocalStorageService pref = Get.find<LocalStorageService>();
  var isUpload = false.obs;
  RxString? selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;
  Future<User?> getUserInfo() async {
    try {
      change(null, status: RxStatus.loading());
      user = await _useCase.execute();
      if (user == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(user, status: RxStatus.success());
      }
      debugPrint(pref.token);
    }
    catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  Future<Wallet?> fetchWalletData() async {
    try {
        walletRpm = await _walletUseCase.execute();
        update();
        return walletRpm;
    } catch (e) {
      pref.setTotalWallet([WalletModel.fromEntity(WalletModel(price: 0)).toJson()]);
      AppLogger.catchLog(e);
      rethrow;
    }
  }


  @override
  void onInit() {
    super.onInit();
    debugPrint(pref.token);
  }

}
