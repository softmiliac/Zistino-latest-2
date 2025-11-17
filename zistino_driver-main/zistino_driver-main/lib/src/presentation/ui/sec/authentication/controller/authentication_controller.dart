import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../domain/usecases/sec/auth_usecase.dart';
import '../binding/auth_binding.dart';
import '../view/verification_page.dart';

class AuthenticationController extends GetxController {

  /// Variable ///
  RxString phoneNumberTxt = ''.obs;
  RxBool isBusyVerification = false.obs;
  bool isOpenKeyboard = false;

  /// Functions ///
  final SendCodeUseCase _sendCodeUseCase = SendCodeUseCase();
  final  TextEditingController phoneTextController = TextEditingController();
  final phoneNumberFormKey = GlobalKey<FormState>();
  BaseResponse? phoneResult;

  /// Functions ///
  void sendPhoneNumber() {
    try {
      Get.to(
          VerificationPage(
              phoneNumber: phoneNumberTxt.value,
              message: phoneResult?.messages[0] ?? ''),
          binding: VerifyBinding());
    } catch (error) {
      AppLogger.e('$error');
    }  }


  Future<bool> onBackClickedAuthenticationPage() {
    phoneTextController.clear();
    return Future.value(true);
  }

  /// send code
  Future sendCode() async {
    try {
      if (isBusyVerification.value == false && Get.isSnackbarOpen == false) {
        isBusyVerification.value = true;

        update();

        phoneResult = await _sendCodeUseCase.execute(phoneTextController.text);

        isBusyVerification.value = false;

        sendPhoneNumber();
      } else {
        isBusyVerification.value = false;
        update();
      }
    }
    // on NoInternetException catch (e){
    //   noInternetWidget();
    //   isBusyLogin = false;
    //   update();
    // }
    catch (e) {
      isBusyVerification.value = false;
      update();
      String title = "خطا";
      showTheResult(
          title: title,
          message: e == 400 ? 'خطای ارتبـاط با سـرور' : '$e',
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      AppLogger.catchLog(e);

      // if (e is Failure) {
      //   messages.add(e.message);
      //   title = e.code;
      // } else if (e is List<String>) {
      //   messages.addAll(e);
      // }

      rethrow;
    }
  }

  /// Dispose ///
  @override
  void dispose() {
    super.dispose();
    phoneTextController.dispose();
  }
}
