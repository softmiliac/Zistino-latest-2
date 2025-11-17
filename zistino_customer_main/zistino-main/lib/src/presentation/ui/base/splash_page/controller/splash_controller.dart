import 'package:flutter/material.dart';
import 'package:zistino/src/data/models/base/config_model.dart';
import 'package:zistino/src/data/repositories/sec/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/repositories/pro/product_repository.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/usecases/bas/splash_usecase.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../../routes/app_pages.dart';
import '../../../sec/edit_profile/view/edit_profile_page.dart';

class SplashController extends GetxController {
  final LocalStorageService pref = Get.find<LocalStorageService>();

  final SplashUseCase _useCase = SplashUseCase();
  RxBool showError = false.obs;
  RxBool isBusy = false.obs;
  User? user;
  UserRepositoryImpl userRepository = UserRepositoryImpl();
  ProductRepositoryImpl productRepository = ProductRepositoryImpl();

  @override
  Future<void> onReady() async {
    if (pref.token != LocalStorageService.defaultTokenValue) {
      getUserInfo();
    }
    await Future.delayed(const Duration(milliseconds: 4000));
    // var data = getBasicData();
    // await Future.wait([data, delay]);
    controlNavigation();
    //todo navigate by user condition from behsod app
    // Get.off(IntroductionScreen(),
    //     transition: Transition.rightToLeftWithFade,
    //     duration: const Duration(milliseconds: 500));
    super.onReady();
  }

  /// Functions ///

  Future<User?> getUserInfo() async {
    try {
      await userRepository.getUserFromApi();
      update();
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  // Future tryAgain() async {
  //   var data = getBasicData();
  //
  //   await Future.wait([data]);
  //   controlNavigation();
  // }
  
  Future fetchData() async {
    try {
      ConfigRqm rqm = ConfigRqm(name: "config",type: 1);
      return await _useCase.execute(rqm);
    } catch (e) {
      debugPrint('Error : $e ${showError.value}');
    }
  }

  void controlNavigation() {
    if (pref.isFirstTimeLaunch) {
      Get.offAllNamed(Routes.introductionPage);
    } else if (pref.user.firstName.isEmpty ||
        pref.token == LocalStorageService.defaultTokenValue) {
      Get.offAllNamed(Routes.authenticationPage);
    } else if (pref.token != LocalStorageService.defaultTokenValue) {
      Get.offAllNamed(Routes.mainPage);
    }
  }

  // void initUser(User _user) async {
  //   try {
  //     pref.user = _user;
  //   } catch (e) {
  //     AppLogger.e("$e");
  //   }
  // }

  Future<bool> back() async {
    printInfo(info: 'back');
    SystemNavigator.pop();
    return true;
  }


  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  goToSite() async {
    // var url = "https://behsod.com/app";
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  // void onData(SyncApp data) {
  // super.onData(data);

  // if (data.AppVersionState == AppVersionType.lastUpdate) {
  //   controlNavigation();
  // } else if (data.AppVersionState == AppVersionType.minorUpdate) {
  // GetX.showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12)),
  //         title: Center(child: subtitle1(text: 'بروز رسانی برنامه')),
  //         actions: [
  //           TextButton(
  //               onPressed: () async {
  //                 Navigator.of(context).pop();
  //                 controlNavigation();
  //               },
  //               child: subtitle1(
  //                 text: 'بعدا',
  //                 color: Colors.black,
  //               )),
  //           TextButton(
  //               onPressed: () async {
  //                 await goToSite();
  //               },
  //               child: subtitle1(
  //                 color: Colors.green,
  //                 text: 'دانلود نسخه جدید',
  //               )),
  //         ],
  //         content: Container(
  //           child: bodyText1(
  //             text:
  //                 "نسخه جدیدی از برنامه به سود موجود هست. با نصب این نسخه از جدیدترین امکانات نرم افزار استفاده کنید",
  //           ),
  //         ),
  //       );
  //     });
  // } else {
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: back,
  //           child: AlertDialog(
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(12)),
  //             title: Center(child: subtitle1(text: 'بروز رسانی برنامه')),
  //             content: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Container(
  //                   child: bodyText1(
  //                     text:
  //                         "نسخه جدیدی از برنامه به سود موجود هست. با نصب این نسخه از جدیدترین امکانات نرم افزار استفاده کنید",
  //                   ),
  //                 ),
  //                 Container(
  //                   width: fullWidth(context),
  //                   child: progressButton(
  //                     text: "دانلود نسخه جدید",
  //                     onClickAction: () async {
  //                       await goToSite();
  //                     },
  //                     isProgress: false,
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

//****************************************************
//   @override
//   void onFutureError(error, Object key) {
//     super.onFutureError(error, key);
//   }

  void onError(error) {
    try {
      // if (error == NetworkResponseType.noInternet) {
      //   _snackBerService.showCustomSnackBar(
      //       message: "مشکل در اتصال ، لطفا مجددا تلاش کنید",
      //       variant: SnackbarType.black,
      //       duration: Duration(seconds: 1000),
      //       mainButtonTitle: "تلاش مجدد",
      //       onTap: (_) {
      //         debugPrint('snackbar tapped');
      //       },
      //       onMainButtonTapped: () {
      //         initialise();
      //       });
      // } else {}
      //
      // _snackBerService.showCustomSnackBar(
      //     message: "خطایی رخ داده، لطفا دوباره تلاش کنید",
      //     variant: SnackbarType.black,
      //     duration: Duration(seconds: 1000),
      //     mainButtonTitle: "تلاش مجدد",
      //     onTap: (_) {
      //       debugPrint('snackbar tapped');
      //     },
      //     onMainButtonTapped: () {
      //       initialise();
      //     });
      showError.value = true;
    } catch (e) {
      // AppLogger.i(e.toString());
    }
    // super.onError(error);
  }
}
