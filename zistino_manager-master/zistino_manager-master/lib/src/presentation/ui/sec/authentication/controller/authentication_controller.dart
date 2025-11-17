import 'dart:async';
import 'package:admin_zistino/src/domain/usecases/sec/user_usecase.dart';
import 'package:admin_zistino/src/presentation/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/sec/auth_model.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/usecases/sec/auth_usecase.dart';
import '../../../base/main_page/controller/main_controller.dart';

class AuthenticationController extends GetxController {
  /// Variable ///
  RxString emailTxt = ''.obs;
  RxString passwordTxt = ''.obs;
  RxBool isBusyVerification = false.obs;
  bool isOpenKeyboard = false;
  LoginResult? loginResult;
  User? user;

  /// Instances ///
  final LoginUseCase _loginUseCase = LoginUseCase();
  final UserUseCase _useCase = UserUseCase();
  MainPageController mainPageController = Get.put(MainPageController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final phoneNumberFormKey = GlobalKey<FormState>();
  final LocalStorageService _pref = Get.find<LocalStorageService>();

  /// Functions ///

  Future<bool> onBackClickedAuthenticationPage() {
    emailController.clear();
    return Future.value(true);
  }

  /// send code
  Future sendCode() async {
    try {
      if (isBusyVerification.value == false && Get.isSnackbarOpen == false) {
        isBusyVerification.value = true;
        update();

        LoginRQM rqm = LoginRQM(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        loginResult = await _loginUseCase.execute(rqm);
        await getUserInfo();
        if (loginResult?.token != '') {
          mainPageController.selectedIndex.value = 0;
          Get.offAllNamed(Routes.homePage);
          isBusyVerification.value = false;
          _pref.isFirstTimeLaunch = false;
          emailController.clear();
          passwordController.clear();
          emailTxt.value = '';
          passwordTxt.value = '';
        } else {
          isBusyVerification.value = false;
          update();
        }
        update();
      }
    } catch (e) {
      isBusyVerification.value = false;
      update();
      String title = "خطا";
      showTheResult(
          title: title,
          message: e == 400 ? 'خطای ارتبـاط با سـرور' : '$e',
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  Future<User?> getUserInfo() async {
    try {
      user = await _useCase.execute();

      return user;
    }
    catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  /// Dispose ///
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }
}
