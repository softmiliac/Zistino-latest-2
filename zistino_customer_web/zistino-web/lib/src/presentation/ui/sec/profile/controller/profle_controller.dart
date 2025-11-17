import 'dart:io';

import 'package:admin_dashboard/src/domain/entities/sec/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/sec/wallet_model.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../../../domain/usecases/sec/wallet_usecase.dart';


class ProfileController extends GetxController with StateMixin<User> {
  ProfileController(this._useCase, this._walletUseCase);

  User? user;
  Wallet? walletRpm;
  final TotalWalletUseCase _walletUseCase;
  final UserUseCase _useCase;
  final LocalStorageService pref = Get.find<LocalStorageService>();
  // final UploadFileUseCase _uploadFileUseCase;
  var isUpload = false.obs;
  PageController pageController = PageController(
    initialPage: -1,
  );
  RxString? selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;
  RxBool isCopied = false.obs;


  void copyToClipboard(String representative) async{
    Clipboard.setData(
      ClipboardData(text: representative),
    );
    showTheResult(resultType: SnackbarType.message,
        showTheResultType: ShowTheResultType.snackBar,
        title: 'پیام',
        message: 'کـد معرف ذخیره شد');
    isCopied.value = true;
    await Future.delayed(const Duration(seconds: 6));
    isCopied.value = false;
  }
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
   getUserInfo();
   fetchWalletData();
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
