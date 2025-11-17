import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/common/services/get_storage_service.dart';
import '../../../../../data/repositories/sec/address_repository.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';

class MainPageController extends GetxController {
  /// Variable ///

  RxInt selectedIndex = RxInt(0);

  /// Instances ///

  TextEditingController searchTextController = TextEditingController();

  WalletRepositoryImpl walletRepository = WalletRepositoryImpl();

  LocalStorageService pref = LocalStorageService();

  /// Functions ///

  Future<bool> onBackClicked() {
    if (selectedIndex.value != 0) {
      selectedIndex.value = 0;
      searchTextController.clear();
    } else {
      SystemNavigator.pop();
    }
    return Future.value(false);
  }

  changeIndex(int newIndex) {
    selectedIndex.value = newIndex;
  }
}
