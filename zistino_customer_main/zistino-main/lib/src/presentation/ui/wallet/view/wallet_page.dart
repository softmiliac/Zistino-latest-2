import 'package:zistino/src/presentation/style/dimens.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../common/utils/close_keyboard.dart';
import '../../../../common/utils/number_format.dart';
import '../../../../common/utils/show_result_action.dart';
import '../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../style/colors.dart';
import '../../../widgets/text_field_widget.dart';
import '../../base/responsive_layout_base/responsive_layout_base.dart';
import '../../sec/edit_profile/view/edit_profile_page.dart';
import '../binding/wallet_binding.dart';
import '../controller/wallet_controller.dart';

class WalletPage extends ResponsiveLayoutBaseGetView<WalletController> {
  WalletPage({super.key});

  final theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(context);
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
  }

  @override
  Widget mobile(BuildContext context) {
    WalletBinding().dependencies();
    controller.shebaController.text = controller.pref.user.sheba;
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child: GetBuilder(
          init: controller,
          builder: (_) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'برداشت وجه',
                  style: theme.textTheme.headline6,
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsetsDirectional.only(top: standardSize),
                  margin: EdgeInsetsDirectional.all(standardSize),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(smallRadius),
                      border: Border.all(color: Colors.grey, width: 0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: const Offset(0, 0))
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: controller.pref.user.sheba.isEmpty
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.end,
                        children: [
                          controller.pref.user.sheba.isEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: standardSize),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Get.to(EditProfilePage());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: kBottomNavigationBarHeight / 1.45,
                                      padding: EdgeInsetsDirectional.only(
                                          end: smallSize, start: smallSize),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              xxSmallRadius),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: theme.primaryColor,
                                              width: 1.2)),
                                      child: Text(
                                        "افزودن شماره شـبا",
                                        style: theme.textTheme.bodyText2
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: theme.primaryColor),
                                      ),
                                    ),
                                  ))
                              : Container(
                                  margin: EdgeInsetsDirectional.only(
                                      start: standardSize),
                                  child: Text(
                                    'انتقال به شماره شبا',
                                    style: theme.textTheme.subtitle1,
                                  )),
                          Container(
                            margin:
                                EdgeInsetsDirectional.only(end: standardSize),
                            child: Image.asset(
                              'assets/images/shetab-removebg-preview.png',
                              width: fullWidth / 7.5,
                              height: fullWidth / 7.5,
                            ),
                          ),
                        ],
                      ),
                      if (controller.pref.user.sheba.isNotEmpty)
                        Container(
                          padding: EdgeInsetsDirectional.only(
                              start: standardSize,
                              end: standardSize,
                              top: xSmallSize,
                              bottom: xSmallSize),
                          child: TextFormFieldWidget(
                            textEditingController: controller.shebaController,
                            readOnly: true,
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.number,
                            onTap: () {

                            },
                            textInputAction: TextInputAction.done,

                            suffixIcon: SizedBox(
                                height: xxLargeSize,
                                width: xxLargeSize,
                                child: SvgPicture.asset(
                                  'assets/ic_ir.svg',
                                  width: iconSizeXXSmall,
                                  height: iconSizeXXSmall,
                                )),
                          ),
                        ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: standardSize, top: smallSize),
                        child: Text(
                          'مبلغ (ریال)',
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                      Form(
                        key: controller.counterFormKey,
                        child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(xxLargeSize)),
                              width: fullWidth,
                              margin: EdgeInsetsDirectional.only(
                                  top: standardSize,
                                  start: standardSize * 1.2,
                                  end: standardSize * 1.2),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: fullWidth / 1.45,
                                      height: xxLargeSize / 1.1,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffE8E8E8),
                                          borderRadius:
                                              BorderRadius.circular(xxLargeSize)),
                                      child: Container(
                                        margin: EdgeInsets.only(top: smallSize),
                                        child: TextFormField(
                                          inputFormatters: <TextInputFormatter>[
                                            CurrencyTextInputFormatter(
                                              locale: 'en',
                                              decimalDigits: 0,
                                              // customPattern: ',',
                                              symbol: '',
                                            )
                                          ],
                                          textAlign: TextAlign.center,
                                          controller: controller.counterController,
                                          onChanged: (value) {
                                            controller.counter.value = int.parse(
                                                controller.counterController.text
                                                    .replaceAll(',', ''));
                                          },
                                          maxLines: 1,
                                          maxLength: 17,
                                          keyboardType: TextInputType.phone,
                                          cursorColor: theme.primaryColor,
                                          style: theme.textTheme.bodyText2
                                              ?.copyWith(color: Colors.black),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          xSmallRadius)),
                                              disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          xSmallRadius)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          xSmallRadius)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          xSmallRadius)),
                                              contentPadding:
                                                  EdgeInsetsDirectional.only(
                                                      top: xxSmallSize / 2,
                                                      bottom: 0),
                                              filled: true,
                                              fillColor: Colors.transparent),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.counter.value <=
                                            999999999999) {
                                          controller.increaseCounter();
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsetsDirectional.only(
                                              top: xxSmallSize),
                                          width: xxLargeSize / 1.4,
                                          height: xxLargeSize / 1.4,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: controller.counter.value <=
                                                      999999999999
                                                  ? theme.primaryColor
                                                  : const Color(0xff9F9F9F),
                                              borderRadius: BorderRadius.circular(
                                                  xSmallRadius),
                                              border: Border.all(
                                                  color: Colors.white, width: 2)),
                                          child: Center(
                                              child: SvgPicture.asset(
                                            'assets/ic_plus.svg',
                                            color: Colors.white,
                                          ))),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.counter.value > 500000) {
                                          controller.decreaseCounter();
                                        }
                                      },
                                      child: Container(
                                          margin: EdgeInsetsDirectional.only(
                                              top: xxSmallSize),
                                          width: xxLargeSize / 1.4,
                                          height: xxLargeSize / 1.4,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: controller.counter.value > 500000 ? theme.primaryColor : const Color(0xff9F9F9F),
                                              borderRadius: BorderRadius.circular(
                                                  xSmallRadius),
                                              border: Border.all(
                                                  color: Colors.white, width: 2)),
                                          child: Center(
                                              child: SvgPicture.asset(
                                            'assets/ic_minus.svg',
                                            color: Colors.white,
                                          ))),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.only(
                            top: standardSize, bottom: smallSize),
                        width: fullWidth,
                        child: Text(
                          'اعتبار فعلی شما ${formatNumber(controller.pref.totalWallet?[0].price ?? 0)} ریال',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      SizedBox(
                        width: fullWidth,
                        child: Text(
                          'حداقل مبلغ برای برداشت 500,000 ریال میباشد',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            if(Get.isSnackbarOpen == false){
                              if (controller.pref.user.sheba.isEmpty) {
                                showTheResult(
                                    resultType: SnackbarType.message,
                                    showTheResultType:
                                    ShowTheResultType.snackBar,
                                    title: 'پیام',
                                    message: 'شماره شبا یافت نشد');
                              } else if (controller.counter.value < 500000) {
                                showTheResult(
                                    resultType: SnackbarType.message,
                                    showTheResultType:
                                    ShowTheResultType.snackBar,
                                    title: 'پیام',
                                    message:
                                    'حداقل مبلغ برداشت 500،000 ریال میباشد');
                              } else if (controller.counter.value >
                                  (controller.pref.totalWallet?[0].price ??
                                      0)) {
                                showTheResult(
                                    resultType: SnackbarType.error,
                                    showTheResultType:
                                    ShowTheResultType.snackBar,
                                    title: 'خطا',
                                    message:
                                    'مبلغ وارد شده بیشتر از اعتبار کیف پول شما میباشد');

                            }else if (controller.counterFormKey.currentState!
                                  .validate()) {
                                controller.transactionWalletRequest();
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.only(top: smallSize),
                            width: fullWidth,
                            padding: EdgeInsetsDirectional.only(
                              top: controller.isBusyRequest.value
                                  ? standardSize / 1.15
                                  : smallSize,
                              bottom: controller.isBusyRequest.value
                                  ? standardSize / 1.15
                                  : smallSize,

                            ),
                            decoration: BoxDecoration(
                                color: controller.isBusyRequest.value == true ||
                                        controller.pref.user.sheba.isEmpty
                                    ? const Color(0xff9F9F9F)
                                    : theme.primaryColor,
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(standardRadius),
                                    topEnd: Radius.circular(standardRadius),
                                    bottomStart: Radius.circular(smallRadius),
                                    bottomEnd: Radius.circular(smallRadius))),
                            child: controller.isBusyRequest.value == false
                                ? Text(
                                    'ثبت درخواست',
                                    style: theme.textTheme.subtitle1!
                                        .copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                : const CupertinoActivityIndicator(
                                    color: Colors.white),
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }
}
