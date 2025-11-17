import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../style/animation/slide_transition.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/text_form_field_widget.dart';
import '../controller/authentication_controller.dart';

class AuthenticationPage extends StatelessWidget{
   AuthenticationPage({super.key});

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
                                              if (controller.phoneNumberFormKey
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
                  )),
            );
          }),
    );

  }

}