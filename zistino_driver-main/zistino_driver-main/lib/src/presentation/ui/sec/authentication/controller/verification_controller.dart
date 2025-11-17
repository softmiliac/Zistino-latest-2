import 'dart:async';
// import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:countdown/countdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/exceptions/server_exception.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/sec/auth_model.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/usecases/sec/auth_usecase.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';
import '../../edit_profile/view/edit_profile_page.dart';
import 'authentication_controller.dart';

class VerificationController extends GetxController {

  /// Variable ///

  RxBool isBusyLogin = false.obs;

  final LoginUseCase _loginUseCase = LoginUseCase();

  final UserUseCase _useCase = UserUseCase();

  RxBool isDisabledButton = false.obs;

  final verificationFormKey = GlobalKey<FormState>();
  final verificationTabletFormKey = GlobalKey<FormState>();
  final verificationDesktopFormKey = GlobalKey<FormState>();

  RxBool isBusyVerification = false.obs;


  RxString codeTxt = ''.obs;
  RxString phoneNumberTxt = ''.obs;
  RxString tokenTxt = ''.obs;

  RxString comingSms = ''.obs;

  late CountDown countDownTime;

  late StreamSubscription<Duration> subTime;

  RxString time = "".obs;

  late String tokenResult;

  bool isOpenKeyboard = false;

  LoginSignupResult? result;

  User? user;

  /// Instances ///

  AuthenticationController authenticationController = Get.find();
  final LocalStorageService _pref = Get.find<LocalStorageService>();
  TextEditingController verificationTextController = TextEditingController();
  MainPageController mainPageController = Get.put(MainPageController());

  /// Functions ///

  Future<User?> getUserInfo() async {
    try {
      user = await _useCase.execute();

      return user;
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

  Future<bool> onBackClickedVerificationPage() {
    Get.back();
    verificationTextController.text = '';
    codeTxt.value = '';
    comingSms.value = '';
    // AltSmsAutofill().unregisterListener();
    subTime.cancel();
    return Future.value(true);
  }

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

  Future sendDataToServer() async {
    try {
      if (isBusyLogin.value == false) {
        isBusyLogin.value = true;

        update();

        LoginRQM rqm = LoginRQM(
            phoneNumber: phoneNumberTxt.value.trim(),
            code: verificationTextController.text.trim(),
            token: tokenTxt.value);

        result = await _loginUseCase.execute(rqm);

        await getUserInfo();

        Future.delayed(Duration(milliseconds: 2000));
        isBusyLogin.value = false;
        verificationTextController.clear();
        _pref.isFirstTimeLaunch = false;
        if (user?.firstName != '' || (user?.firstName.isNotEmpty ?? false)) {
          mainPageController.selectedIndex.value = 0;
          Get.offAll(MainPage());
        } else if(user?.firstName == '' || (user?.firstName.isEmpty ?? false)){
          _pref.user.phoneNumber = phoneNumberTxt.value;
          _pref.user.id = user?.id ?? '';
          Get.offAll(EditProfilePage(isSignUp: true));
        }
        authenticationController.phoneTextController.clear();
        codeTxt.value = '';
        comingSms.value = '';
        // AltSmsAutofill().unregisterListener();
        subTime.cancel();
        update();
      } else {
        isBusyLogin.value = false;
        update();
      }
    }
    // on NoInternetException catch (e){
    //   noInternetWidget();
    //   isBusyLogin = false;
    //   update();
    // }
    catch (e) {
      isBusyLogin.value = false;
      update();
      showTheResult(
          title: "خطا",
          message:ExceptionConstants.serverError,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      List<String> messages = [];

      AppLogger.catchLog(e);

      if (e is Failure) {
        messages.add(e.message);
        // title = e.code;
      } else if (e is List<String>) {
        messages.addAll(e);
      }

      rethrow;
    }
  }


  @override
  void onInit() {
    super.onInit();
    countListener();
  } // Future<void> initSmsListener() async {
  //   try {
  //     comingSms.value = await AltSmsAutofill().listenForSms ?? '';
  //     debugPrint("====>Message: $comingSms");
  //     debugPrint(comingSms.value[23]);
  //     codeTxt.value = comingSms.value[23] +
  //         comingSms.value[24] +
  //         comingSms.value[25] +
  //         comingSms.value[26] +
  //         comingSms.value[27] +
  //         comingSms.value[
  //         28]; //todo (get code from wordIndex in sms).
  //     debugPrint(codeTxt.value);
  //     verificationTextController.text = codeTxt.value;
  //     debugPrint('*~*~*~*~*~ Controller Code ${verificationTextController.text}');
  //     update();
  //     Future.delayed(const Duration(milliseconds: 200));
  //     await sendDataToServer();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  bool isDisabled() {
    isDisabledButton.value = codeTxt.value == '' ? true : false;
    return isDisabledButton.value;
  }
}
