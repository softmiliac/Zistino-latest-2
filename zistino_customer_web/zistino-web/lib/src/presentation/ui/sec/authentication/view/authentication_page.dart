import 'package:admin_dashboard/src/presentation/style/animation/slide_transition.dart';
import 'package:admin_dashboard/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/text_field_widget.dart';
import '../controller/authentication_controller.dart';

class AuthenticationPage
    extends GetResponsiveView<AuthenticationController> {
  AuthenticationPage({
    Key? key,
  }) : super(key: key);

  final ThemeData theme = Get.theme;

  final phoneNumberFormKey = GlobalKey<FormState>();


  @override
  Widget phone() {
    return GestureDetector(
      onTap: () => closeKeyboard(Get.context!),
      child: WillPopScope(
        onWillPop: controller.onBackClickedAuthenticationPage,
        child: GetBuilder(
            init: controller,
            builder: (_) {
              return Scaffold(
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
                          child: Column(
                            children: [
                              SizedBox(height: xxLargeSize),
                              SlideFadeTransition(
                                delayStart: const Duration(milliseconds: 150),
                                animationDuration:
                                    const Duration(milliseconds: 1000),
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
                                animationDuration:
                                    const Duration(milliseconds: 1000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsetsDirectional.only(
                                          bottom: xLargeSize),
                                      child: Text(
                                        "شماره موبایل خود را وارد کنید",
                                        style: theme.textTheme.headline5
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: standardSize,
                                          end: standardSize),
                                      child: Form(
                                        key: phoneNumberFormKey,
                                        child: TextFormFieldWidget(
                                          textEditingController:
                                              controller.phoneTextController,
                                          onChange: (value) {
                                            controller.phoneNumberTxt.value =
                                                value;
                                            if (value.trim().length == 11) {
                                              closeKeyboard(Get.context!);
                                            }
                                            controller.update();
                                          },
                                          hint: "*********09",
                                          padding: EdgeInsetsDirectional.all(smallSize),
                                          label: 'شماره مـوبایل',
                                          maxLength: 11,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "لطفا فیلد را پر کنید.";
                                            } else if (!value!
                                                    .startsWith("09") ||
                                                value.trim().replaceAll(' ', '').length < 11) {
                                              return 'شماره همراه نامعتبر است.'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Obx(() {
                              return Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: standardSize, end: standardSize),
                                child: SlideFadeTransition(
                                  delayStart: const Duration(milliseconds: 250),
                                  animationDuration:
                                      const Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsetsDirectional.only(
                                            bottom: standardSize),
                                        child: progressButton(
                                            text: 'ارسال کد تایید',
                                            isDisable:
                                                controller.phoneNumberTxt
                                                            .value ==
                                                        ''
                                                    ? true
                                                    : false,
                                            isProgress: controller
                                                .isBusyVerification.value,
                                            onTap: () {
                                              if (phoneNumberFormKey
                                                  .currentState!
                                                  .validate()) {
                                                controller.sendCode();
                                              }
                                            }),
                                      )),
                                ),
                              );
                            }))
                      ],
                    ),
                  ));
            }),
      ),
    );
  }

  @override
  Widget desktop() {
    return GestureDetector(
      onTap: () => closeKeyboard(Get.context!),
      child: WillPopScope(
        onWillPop: controller.onBackClickedAuthenticationPage,
        child: GetBuilder(
            init: controller,
            builder: (_) {
              return Scaffold(
                  resizeToAvoidBottomInset: true,
                  backgroundColor: theme.backgroundColor,
                  appBar: AppBar(
                    toolbarHeight: 0,
                    backgroundColor: theme.backgroundColor,
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      height: fullHeight,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: smallSize),
                                SlideFadeTransition(
                                  delayStart: const Duration(milliseconds: 150),
                                  animationDuration:
                                  const Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Container(
                                      height: fullHeight / 5,
                                      // width: fullWidth / 3.4,
                                      padding: EdgeInsets.all(smallSize/1.2),
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
                                SizedBox(height: smallSize),
                                SlideFadeTransition(
                                  delayStart: const Duration(milliseconds: 200),
                                  animationDuration:
                                  const Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Container(
                                    width: fullWidth/2.9,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: EdgeInsetsDirectional.only(
                                              bottom: smallSize),
                                          child: Text(
                                            "شماره موبایل خود را وارد کنید",
                                            style: theme.textTheme.headline5
                                                ?.copyWith(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsetsDirectional.only(
                                              start: standardSize,
                                              end: standardSize),
                                          child: Form(
                                            key: phoneNumberFormKey,
                                            child: TextFormFieldWebWidget(
                                              textDirection: TextDirection.ltr,
                                              textEditingController:
                                              controller.phoneTextController,
                                              onChange: (value) {
                                                controller.phoneNumberTxt.value =
                                                    value;
                                                if (value.trim().length == 11) {
                                                  closeKeyboard(Get.context!);
                                                }
                                                controller.update();
                                              },
                                              hint: "09*********",
                                              padding: EdgeInsetsDirectional.only(end: xxSmallSize),
                                              label: 'شماره مـوبایل',
                                              maxLength: 11,
                                              validator: (value) {
                                                if (value?.isEmpty ?? true) {
                                                  return "لطفا فیلد را پر کنید.";
                                                } else if (!value!
                                                    .startsWith("09") ||
                                                    value.trim().replaceAll(' ', '').length < 11) {
                                                  return 'شماره همراه نامعتبر است.'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.done,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: smallSize),
                                        Obx(() {
                                          return Container(
                                            margin: EdgeInsetsDirectional.only(
                                                start: standardSize, end: standardSize),
                                            child: SlideFadeTransition(
                                              delayStart: const Duration(milliseconds: 250),
                                              animationDuration:
                                              const Duration(milliseconds: 1000),
                                              curve: Curves.fastLinearToSlowEaseIn,
                                              child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    width: double.infinity,
                                                    margin: EdgeInsetsDirectional.only(
                                                        bottom: standardSize),
                                                    child: progressButton(
                                                        text: 'ارسال کد تایید',
                                                        isDesktop: true,
                                                        isDisable:
                                                        controller.phoneNumberTxt
                                                            .value ==
                                                            ''
                                                            ? true
                                                            : false,
                                                        isProgress: controller
                                                            .isBusyVerification.value,
                                                        onTap: () {
                                                          if (phoneNumberFormKey
                                                              .currentState!
                                                              .validate()) {
                                                            controller.sendCode();
                                                          }
                                                        }),
                                                  )),
                                            ),
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            }),
      ),
    );
  }

  @override
  Widget tablet() {
    return GestureDetector(
      onTap: () => closeKeyboard(Get.context!),
      child: WillPopScope(
        onWillPop: controller.onBackClickedAuthenticationPage,
        child: GetBuilder(
            init: controller,
            builder: (_) {
              return Scaffold(
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
                          child: Column(
                            children: [
                              SizedBox(height: xxLargeSize),
                              SlideFadeTransition(
                                delayStart: const Duration(milliseconds: 150),
                                animationDuration:
                                const Duration(milliseconds: 1000),
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
                                animationDuration:
                                const Duration(milliseconds: 1000),
                                curve: Curves.fastLinearToSlowEaseIn,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsetsDirectional.only(
                                          bottom: xLargeSize),
                                      child: Text(
                                        "شماره موبایل خود را وارد کنید",
                                        style: theme.textTheme.headline5
                                            ?.copyWith(
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsetsDirectional.only(
                                          start: standardSize,
                                          end: standardSize),
                                      child: Form(
                                        key: phoneNumberFormKey,
                                        child: TextFormFieldWidget(
                                          textEditingController:
                                          controller.phoneTextController,
                                          onChange: (value) {
                                            controller.phoneNumberTxt.value =
                                                value;
                                            if (value.trim().length == 11) {
                                              closeKeyboard(Get.context!);
                                            }
                                            controller.update();
                                          },
                                          hint: "*********09",
                                          padding: EdgeInsetsDirectional.all(smallSize),
                                          label: 'شماره مـوبایل',
                                          maxLength: 11,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "لطفا فیلد را پر کنید.";
                                            } else if (!value!
                                                .startsWith("09") ||
                                                value.trim().replaceAll(' ', '').length < 11) {
                                              return 'شماره همراه نامعتبر است.'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.done,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: Obx(() {
                              return Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: standardSize, end: standardSize),
                                child: SlideFadeTransition(
                                  delayStart: const Duration(milliseconds: 250),
                                  animationDuration:
                                  const Duration(milliseconds: 1000),
                                  curve: Curves.fastLinearToSlowEaseIn,
                                  child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsetsDirectional.only(
                                            bottom: standardSize),
                                        child: progressButton(
                                            text: 'ارسال کد تایید',
                                            isDisable:
                                            controller.phoneNumberTxt
                                                .value ==
                                                ''
                                                ? true
                                                : false,
                                            isProgress: controller
                                                .isBusyVerification.value,
                                            onTap: () {
                                              if (phoneNumberFormKey
                                                  .currentState!
                                                  .validate()) {
                                                controller.sendCode();
                                              }
                                            }),
                                      )),
                                ),
                              );
                            }))
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}
