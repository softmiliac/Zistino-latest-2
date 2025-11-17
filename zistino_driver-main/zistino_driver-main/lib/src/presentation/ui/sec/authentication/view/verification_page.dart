// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../style/animation/slide_transition.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../controller/verification_controller.dart';

class VerificationPage extends StatelessWidget {
  VerificationPage(
      {super.key, required this.phoneNumber, required this.message});


  /// Variables ///
  final ThemeData theme = Get.theme;
  String phoneNumber = '';
  String message = '';

  /// Instance ///

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
        init: VerificationController(),
        builder: (controller) {
          controller.phoneNumberTxt.value = phoneNumber;
          controller.tokenTxt.value = message;
          return WillPopScope(
            onWillPop: controller.onBackClickedVerificationPage,
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              backgroundColor: theme.backgroundColor,
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: theme.backgroundColor,
              ),
              body: SizedBox(
                height: fullHeight,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(children: [
                        SizedBox(height: xxLargeSize),
                        SlideFadeTransition(
                          delayStart: const Duration(milliseconds: 150),
                          animationDuration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                              height: fullWidth / 4,
                              // width: fullWidth / 3.4,
                              padding: EdgeInsets.all(largeSize / 1.5),
                              decoration: BoxDecoration(
                                  boxShadow: const [
                                    BoxShadow(
                                        color: AppColors.shadowColor,
                                        blurRadius: 4,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.0, 1))
                                  ],
                                  shape: BoxShape.circle,
                                  color: theme.primaryColor),
                              child: Image.asset(
                                'assets/pic_white_logo.png',
                                fit: BoxFit.contain,
                              )),
                        ),
                        SizedBox(height: xLargeSize),
                        SlideFadeTransition(
                          delayStart: const Duration(milliseconds: 200),
                          animationDuration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: standardSize, end: standardSize),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.center,
                                  margin: EdgeInsetsDirectional.only(
                                      bottom: xLargeSize),
                                  child: Text(
                                    "رمز یکبار مصرف را وارد کنید",
                                    textAlign: TextAlign.start,
                                    style: theme.textTheme.headline5
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: smallSize),
                        SlideFadeTransition(
                          delayStart: const Duration(milliseconds: 200),
                          animationDuration: const Duration(milliseconds: 1000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: standardSize, end: standardSize),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: AlignmentDirectional.center,
                                  margin: EdgeInsetsDirectional.only(
                                      bottom: standardSize / 1.2),
                                  child: Text(
                                    "رمز یکبار مصرف به شماره $phoneNumber ارسال شد.",
                                    textAlign: TextAlign.start,
                                    style: theme.textTheme.subtitle2,
                                  ),
                                ),
                                Form(
                                  key: controller.verificationFormKey,
                                  child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: PinCodeTextField(
                                      controller:
                                          controller.verificationTextController,
                                      validator: (value) {
                                        if (value!.length < 6) {
                                          return "";
                                        }
                                        return null;
                                      },
                                      cursorColor: theme.primaryColor,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      textStyle: theme.textTheme.subtitle1
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                      length: 6,
                                      autoDisposeControllers: false,
                                      errorTextMargin:
                                          const EdgeInsets.all(10000000),
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderRadius:
                                            BorderRadius.circular(smallRadius),
                                        borderWidth: 0.7,
                                        fieldHeight: fullWidth / 7.5,
                                        fieldWidth: fullWidth / 7.5,
                                        selectedColor: theme.primaryColor,
                                        inactiveFillColor:
                                            AppColors.homeBackgroundColor,
                                        selectedFillColor:
                                            AppColors.homeBackgroundColor,
                                        inactiveColor: Colors.transparent,
                                        activeColor: theme.primaryColor,
                                        activeFillColor:
                                            AppColors.homeBackgroundColor,
                                      ),
                                      autoDismissKeyboard: true,
                                      enablePinAutofill: true,
                                      showCursor: false,
                                      animationDuration:
                                          const Duration(milliseconds: 300),
                                      backgroundColor: Colors.transparent,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      enableActiveFill: true,
                                      appContext: context,
                                      onChanged: (String value) {
                                        controller.codeTxt.value = value;
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: xLargeSize),
                                Obx(() => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "زمان باقی مانده تا ارسال مجدد:",
                                          style:
                                              theme.textTheme.caption!.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.captionTextColor,
                                          ),
                                        ),
                                        SizedBox(width: xSmallSize),
                                        controller.isBusyVerification.value
                                            ? const CupertinoActivityIndicator(
                                                color:
                                                    AppColors.captionTextColor)
                                            : controller.time.value == "00:00"
                                                ? GestureDetector(
                                                    onTap: () {
                                                      controller.codeTxt.value =
                                                          '';
                                                      controller
                                                          .verificationTextController
                                                          .text = '';
                                                      controller
                                                          .authenticationController
                                                          .sendCode();
                                                      controller
                                                          .countListener();
                                                    },
                                                    child: Text(
                                                      "ارسال مجدد کد",
                                                      style: theme
                                                          .textTheme.caption!
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: AppColors
                                                            .textBlackColor,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    controller.time.value,
                                                    style: theme
                                                        .textTheme.subtitle2!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                      ],
                                    )),
                                SizedBox(height: xLargeSize),
                                AnimatedOpacity(
                                  duration:const Duration(milliseconds: 200),
                                  opacity: controller.isBusyLogin.value ==
                                              false &&
                                          controller.isBusyVerification.value ==
                                              false
                                      ? 1
                                      : 0.5,
                                  child: InkWell(
                                    splashColor: Colors.black.withOpacity(0.05),
                                    borderRadius:
                                        BorderRadius.circular(xxSmallRadius),
                                    onTap:
                                        controller.isBusyLogin.value == false &&
                                                controller.isBusyVerification
                                                        .value ==
                                                    false
                                            ? controller
                                                .onBackClickedVerificationPage
                                            : null,
                                    child: Padding(
                                      padding: EdgeInsets.all(xSmallSize),
                                      child: Text(
                                        "تغییر شماره تلفن همراه",
                                        style:
                                            theme.textTheme.subtitle2!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textBlackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: standardSize, end: standardSize),
                      child: SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 250),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(() {
                              return Container(
                                  width: double.infinity,
                                  margin: EdgeInsetsDirectional.only(
                                      bottom: standardSize),
                                  child: progressButton(
                                      text: 'ثبت کد تایید',
                                      isDisable: controller.isDisabled(),
                                      isProgress: controller.isBusyLogin.value,
                                      onTap: () {
                                        if (controller
                                            .verificationFormKey.currentState!
                                            .validate()) {
                                          controller.sendDataToServer();
                                        }
                                      }));
                            })),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
