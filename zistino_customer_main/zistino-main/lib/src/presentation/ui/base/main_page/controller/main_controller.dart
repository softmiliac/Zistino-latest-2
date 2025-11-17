import 'package:zistino/src/common/services/get_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/repositories/pro/product_repository.dart';
import '../../../../../data/repositories/sec/address_repository.dart';
import '../../../../../data/repositories/sec/wallet_repository.dart';
import '../../../../../domain/entities/pro/category_entity.dart';

class MainPageController extends GetxController {
  /// Variable ///

  RxInt selectedIndex = RxInt(0);
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey tutorial = GlobalKey();
  GlobalKey request = GlobalKey();
  GlobalKey buy = GlobalKey();
  GlobalKey residue = GlobalKey();
  GlobalKey wallet = GlobalKey();
  GlobalKey shop = GlobalKey();
  GlobalKey walletRequest = GlobalKey();
  /// Instances ///

  TextEditingController searchTextController = TextEditingController();
  AddressRepositoryImpl addressRepository = AddressRepositoryImpl();
  WalletRepositoryImpl walletRepository = WalletRepositoryImpl();
  ProductRepositoryImpl productRepository = ProductRepositoryImpl();
  LocalStorageService pref = Get.find();

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

  Future<CategoryEntity?> getCategory() async {
    try {
      await productRepository.getCategories1();
      update();
    }
    catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  changeIndex(int newIndex) {
    selectedIndex.value = newIndex;
  }
}
