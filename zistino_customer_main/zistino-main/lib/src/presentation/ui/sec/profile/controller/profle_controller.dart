
import 'package:zistino/src/domain/entities/sec/wallet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/models/sec/wallet_model.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';


class ProfileController extends GetxController with StateMixin<User> {
  ProfileController();

  User? user;
  Wallet? walletRpm;
  final TotalWalletUseCase _walletUseCase = TotalWalletUseCase();
  final UserUseCase _userUseCase = UserUseCase();
  final LocalStorageService pref = Get.find<LocalStorageService>();
  // final UploadFileUseCase _uploadFileUseCase;
  var isUpload = false.obs;

  RxString? selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;

  Future<User?> getUserInfo() async {
    try {
      change(null, status: RxStatus.loading());
      user = await _userUseCase.execute();
      if (user == null) {
        change(null, status: RxStatus.empty());
      } else {
        change(user, status: RxStatus.success());
      }
      debugPrint(pref.token);
    }
    // on NoInternetException catch (e){
    //   noInternetWidget();
    //   change(null, status: RxStatus.error(e.message));
    //
    //   update();
    // }
    catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
    return user;
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
/*
  // Future<String> getImage(File path) async {
  //   try {
  //     if (isUpload.value == false) {
  //       isUpload.value = true;
  //       update();
  //       selectedImagePath?.value = await _uploadFileUseCase.execute(path);
  //       isUpload.value = false;
  //       update();
  //       // User user = pref.user;
  //       // user.imageUrl = selectedImagePath.value;
  //       // pref.user = user;
  //       if (selectedImagePath?.value != null) {
  //         Get.to(MainPage(selectedIndex: 3));
  //
  //         return selectedImagePath?.value ?? '';
  //       } else {
  //         return '';
  //       }
  //     } else {
  //       isUpload.value = false;
  //       update();
  //       return '';
  //     }
  //   } catch (error) {
  //     isUpload.value = false;
  //
  //     AppLogger.e(error.toString());
  //     throw ('$error');
  //   }
  // }

*/ //TODO for upload



}
