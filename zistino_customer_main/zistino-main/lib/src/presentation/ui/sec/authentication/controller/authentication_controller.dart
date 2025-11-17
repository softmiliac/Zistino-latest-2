import 'dart:async';
import 'package:countdown/countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../domain/usecases/sec/auth_usecase.dart';
import '../../../../routes/app_pages.dart';

class AuthenticationController extends GetxController {

  /// Variable ///

  final SendCodeUseCase _sendCodeUseCase = SendCodeUseCase();

  RxBool isCheckedCondition = false.obs;

  final phoneNumberFormKey = GlobalKey<FormState>();

  TextEditingController phoneTextController = TextEditingController();
  RxString phoneNumberTxt = ''.obs;

  RxBool isBusyVerification = false.obs;

  bool isOpenKeyboard = false;

  BaseResponse? phoneResult;

  late CountDown countDownTime;

  late StreamSubscription<Duration> subTime;

  RxString time = "".obs;


  /// Functions ///

  String showTime(Duration event) {
    var min = "";

    var sec = "";

    var secs = event.inSeconds % 60;

    if (event.inMinutes < 10) {
      min = "0${event.inMinutes}";
    } else {
      min = "${event.inMinutes}";
    }

    if (secs < 10) {
      sec = "0${event.inSeconds % 60}";
    } else {
      sec = (event.inSeconds % 60).toString();
    }

    return "$min:$sec";
  }

  void countListener() {
    countDownTime = CountDown(const Duration(minutes: 2));

    subTime = countDownTime.stream.listen((event) {
      time.value = showTime(event);
      update();
    });

    subTime.onDone(() {
      isBusyVerification.value = false;

      subTime.cancel();

      update();

      debugPrint("subTime.onDone");
    });
  }

  void sendPhoneNumber() {
    try {
      Get.toNamed(Routes.verificationPage,
          arguments: [phoneNumberTxt.value, phoneResult?.messages[0]]
    // VerificationPage(
          //     phoneNumber: phoneNumberTxt.value,
          //     message: phoneResult?.messages[0] ?? ''),
          // binding: VerifyBinding());
          );
          countListener();
    } catch (error) {
      AppLogger.e('$error');
    }
  }

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
