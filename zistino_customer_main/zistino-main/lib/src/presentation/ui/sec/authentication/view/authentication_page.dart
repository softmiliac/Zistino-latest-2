import 'package:zistino/src/presentation/style/animation/slide_transition.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../../base/terms_and_conditions_page/view/terms_and_conditions_page.dart';
import '../controller/authentication_controller.dart';

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({
    Key? key,
  }) : super(key: key);

  /// Instances ///
  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child: GetBuilder<AuthenticationController>(
          init: AuthenticationController(),
          builder: (controller) {
            return WillPopScope(
              onWillPop: controller.onBackClickedAuthenticationPage,
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
                                        key: controller.phoneNumberFormKey,
                                        child: TextFormFieldWidget(
                                          textEditingController:
                                          controller.phoneTextController,
                                          onChange: (value) {
                                            controller.phoneNumberTxt.value =
                                                value;
                                            if (value.trim().length == 11) {
                                              closeKeyboard(context);
                                            }
                                            controller.update();
                                          },
                                          hint: "*********09",
                                          padding: EdgeInsetsDirectional.all(
                                              smallSize),
                                          label: 'شماره مـوبایل',
                                          maxLength: 11,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return "لطفا فیلد را پر کنید.";
                                            } else if (!value!
                                                .startsWith("09") ||
                                                value
                                                    .trim()
                                                    .replaceAll(' ', '')
                                                    .length <
                                                    11) {
                                              return 'شماره همراه نامعتبر است.'
                                                  .tr;
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          onTap: () {

                                          },
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SlideFadeTransition(
                                      delayStart: const Duration(milliseconds: 250),
                                      direction: Direction.horizontal,
                                      animationDuration:
                                      const Duration(milliseconds: 1000),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Obx(() => Checkbox(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(xxSmallRadius)),
                                            value: controller
                                                .isCheckedCondition.value,
                                            onChanged: (value) => controller
                                                .isCheckedCondition
                                                .value = value ?? false,
                                          )),
                                          Expanded(
                                            child: RichText(
                                              maxLines: 3,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    recognizer:
                                                    TapGestureRecognizer()..onTap = ()=> Get.to(TermsAndConditionsPage()),
                                                    text: 'شرایط استفاده از خدمات',
                                                    style: theme
                                                        .textTheme.bodyText2!
                                                        .copyWith(
                                                      decoration: TextDecoration.underline,
                                                      color: theme.primaryColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' و '
                                                        .tr,
                                                    style: theme
                                                        .textTheme.bodyText2!
                                                        .copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = ()=> Get.to(TermsAndConditionsPage()),
                                                    text: "حریم خصوصی",
                                                    style: theme
                                                        .textTheme.bodyText2!
                                                        .copyWith(
                                                      decoration: TextDecoration.underline,
                                                      color: theme.primaryColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: ' را میپذیرم'
                                                        .tr,
                                                    style: theme
                                                        .textTheme.bodyText2!
                                                        .copyWith(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SlideFadeTransition(
                                      delayStart: const Duration(milliseconds: 250),
                                      animationDuration:
                                      const Duration(milliseconds: 1000),
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsetsDirectional.only(
                                            bottom: standardSize),
                                        child: progressButton(
                                            text: 'ارسال کد تایید',
                                            isDisable:
                                            controller.phoneNumberTxt
                                                .value ==
                                                '' || controller.isCheckedCondition.isFalse
                                                ? true
                                                : false,
                                            isProgress: controller
                                                .isBusyVerification.value,
                                            onTap: () {
                                              if (controller.phoneNumberFormKey
                                                  .currentState!
                                                  .validate()) {
                                                controller.sendCode();
                                              }
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }))
                      ],
                    ),
                  )),
            );
          }),
    );
  }


}
