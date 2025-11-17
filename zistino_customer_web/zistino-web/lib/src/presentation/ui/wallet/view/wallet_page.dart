// import 'package:admin_dashboard/src/presentation/style/dimens.dart';
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
import '../../../routes/app_pages.dart';
import '../../../style/colors.dart';
import '../../../style/dimens.dart';
import '../../../widgets/text_field_widget.dart';
import '../../sec/edit_profile/view/edit_profile_page.dart';
import '../binding/wallet_binding.dart';
import '../controller/wallet_controller.dart';

class WalletPage extends GetResponsiveView<WalletController> {
  WalletPage({super.key});

  final theme = Get.theme;
  var context = Get.context!;

  @override
  Widget desktop() {
    // WalletBinding().dependencies();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    controller.shebaController.text = controller.pref.user.sheba;
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child:
      // GetBuilder(
      //     init: controller,
      //     builder: (_) {
      //       return
              Scaffold(
              backgroundColor: AppColors.homeBackgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 0,
                elevation: 0,
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(width/55),
                      margin: EdgeInsets.symmetric(horizontal: width/3),
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(xxSmallRadius),
                        border: Border.all(color: Colors.grey, width: 0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: controller.pref.user.sheba.isEmpty
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.end,
                            children: [
                              controller.pref.user.sheba.isEmpty
                                  ? InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  controller.mainPageController.selectedProfileIndex.value = 5;
                                  controller.mainPageController.selectedIndex.value = 4;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsetsDirectional.all(width/120),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          xxSmallRadius/2),
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
                              )
                                  : const SizedBox(),
                              Image.asset(
                                'assets/images/shetab-removebg-preview.png',
                                width: height/9,
                                height: height/9,
                              ),
                            ],
                          ),
                          if (controller.pref.user.sheba.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsetsDirectional.only(bottom: width/120),
                                    child: Text(
                                      'شماره شبا',
                                      style: theme.textTheme.subtitle1,
                                    )),
                                SizedBox(
                                  width: width,
                                  child: TextFormFieldWebWidget(
                                    textEditingController: controller.shebaController,
                                    readOnly: true,
                                    textDirection: TextDirection.ltr,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    suffixIcon: SizedBox(
                                        height: height/90,
                                        width: height/90,
                                        child: SvgPicture.asset(
                                          'assets/ic_ir.svg',
                                          width: iconSizeXXSmall,
                                          height: iconSizeXXSmall,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          Container(
                            margin: EdgeInsetsDirectional.only(top: width/100,bottom: width/120),
                            child: Text(
                              'مبلغ (ريال)',
                              style: theme.textTheme.subtitle1,
                            ),
                          ),
                          Form(
                            key: controller.counterFormKey,
                            child: Obx(() {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius:
                                    BorderRadius.circular(xSmallRadius)),
                                width: width,

                                child: Container(
                                  alignment: Alignment.center,
                                  width: width,
                                  height: height/15,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffE8E8E8),
                                      borderRadius:
                                      BorderRadius.circular(smallRadius)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (controller.counter.value <=
                                              10000000000000) {
                                            controller.increaseCounter();
                                          }
                                        },
                                        child: Container(
                                            width: height/15,
                                            height: height/15,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: controller.counter.value <=
                                                    10000000000000
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
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: height/36),
                                          alignment: Alignment.center,
                                          child: TextFormField(
                                            inputFormatters: <TextInputFormatter>[
                                              CurrencyTextInputFormatter(
                                                locale: 'en',
                                                decimalDigits: 0,
                                                symbol: '',
                                              )
                                            ],
                                            textAlign: TextAlign.center,
                                            controller:
                                            controller.counterController,
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
                                                hoverColor: Colors.transparent,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        xxSmallRadius/2)),
                                                disabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        xxSmallRadius/2)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        xxSmallRadius/2)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        xxSmallRadius/2)),
                                                contentPadding:
                                                const EdgeInsetsDirectional.only(
                                                    top: 0,
                                                    bottom: 0),
                                                filled: true,
                                                fillColor: Colors.transparent),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (controller.counter.value > 500000) {
                                            controller.decreaseCounter();
                                          }
                                        },
                                        child: Container(
                                            width: height/15,
                                            height: height/15,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color:
                                                controller.counter.value > 500000
                                                    ? theme.primaryColor
                                                    : const Color(0xff9F9F9F),
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
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                          Container(
                            margin: EdgeInsetsDirectional.only(top: width/90),
                            width: width,
                            child: Text(
                              'اعتبار فعلی شما ${formatNumber(controller.pref.totalWallet?[0].price ?? 0)} ريال',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.subtitle2!
                                  .copyWith(color: AppColors.captionTextColor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsetsDirectional.only(top: width/90),

                            width: width,
                            child: Text(
                              'حداقل مبلغ برای برداشت 500,000 ريال میباشد',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.subtitle2!
                                  .copyWith(color: AppColors.captionTextColor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsetsDirectional.only(top: width/90),

                            alignment: AlignmentDirectional.center,
                            child: Obx(() {
                              return GestureDetector(
                                onTap: () {
                                  closeKeyboard(context);
                                  if (Get.isSnackbarOpen == false) {
                                    if (controller.pref.user.sheba.isEmpty) {
                                      showTheResult(
                                          resultType: SnackbarType.message,
                                          showTheResultType:
                                          ShowTheResultType.snackBar,
                                          title: 'پیام',
                                          message: 'شماره شبا یافت نشد');
                                    } else if (controller.counter.value < 50000) {
                                      showTheResult(
                                          resultType: SnackbarType.message,
                                          showTheResultType:
                                          ShowTheResultType.snackBar,
                                          title: 'پیام',
                                          message:
                                          'حداقل مبلغ برداشت 500،000 ريال میباشد');
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
                                    } else if (controller.counterFormKey.currentState!
                                        .validate()) {
                                      controller.transactionWalletRequest();
                                    }
                                  }
                                },
                                child: Container(
                                  alignment: AlignmentDirectional.center,
                                  width: 250,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: controller.isBusyRequest.value == true ||
                                          controller.pref.user.sheba.isEmpty
                                          ? const Color(0xff9F9F9F)
                                          : theme.primaryColor,
                                      borderRadius: BorderRadius.circular(xxSmallRadius/2)),
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
                            }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // );
          // }
          ),
    );
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // WalletBinding().dependencies();
    controller.shebaController.text = controller.pref.user.sheba;
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child:
      // GetBuilder(
      //     init: controller,
      //     builder: (_) {
      //       return
              Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'برداشت وجه',
                  style: theme.textTheme.headline6,
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsetsDirectional.only(top: a/24),
                  margin: EdgeInsetsDirectional.all(a/24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(a/40),
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
                                      horizontal: a/24),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Get.toNamed(Routes.editProfile);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: kBottomNavigationBarHeight / 1.45,
                                      padding: EdgeInsetsDirectional.only(
                                          end: a/40, start: a/40),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              a/100),
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
                                      start: a/24),
                                  child: Text(
                                    'انتقال به شماره شبا',
                                    style: theme.textTheme.subtitle1,
                                  )),
                          Container(
                            margin:
                                EdgeInsetsDirectional.only(end: a/24),
                            child: Image.asset(
                              'assets/images/shetab-removebg-preview.png',
                              width: a / 7.5,
                              height: a / 7.5,
                            ),
                          ),
                        ],
                      ),
                      if (controller.pref.user.sheba.isNotEmpty)
                        Container(
                          padding: EdgeInsetsDirectional.only(
                              start: a/24,
                              end: a/24,
                              top: a/80,
                              bottom: a/80),
                          child: TextFormFieldWidget(
                            textEditingController: controller.shebaController,
                            readOnly: true,
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            suffixIcon: SizedBox(
                                height: a/16,
                                width: a/16,
                                child: SvgPicture.asset(
                                  'assets/ic_ir.svg',
                                  width: a/80,
                                  height: a/80,
                                )),
                          ),
                        ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: a/24, top: a/40),
                        child: Text(
                          'مبلغ (تومان)',
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                      Form(
                        key: controller.counterFormKey,
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(a/16)),
                            width: a,
                            margin: EdgeInsetsDirectional.only(
                                top: a/24,
                                start: a/24 * 1.2,
                                end: a/24 * 1.2),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: a / 1.45,
                                    height: a/16 / 1.1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE8E8E8),
                                        borderRadius:
                                            BorderRadius.circular(a/16)),
                                    child: Container(
                                      margin: EdgeInsets.only(top: a/40),
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
                                        controller:
                                            controller.counterController,
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
                                                        a/60)),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a/60)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a/60)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a/60)),
                                            contentPadding:
                                                EdgeInsetsDirectional.only(
                                                    top: a/100 / 2,
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
                                          10000000000000) {
                                        controller.increaseCounter();
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsetsDirectional.only(
                                            top: a/100),
                                        width: a/16 / 1.4,
                                        height: a/16 / 1.4,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: controller.counter.value <=
                                                    10000000000000
                                                ? theme.primaryColor
                                                : const Color(0xff9F9F9F),
                                            borderRadius: BorderRadius.circular(
                                                a/60),
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
                                            top: a/100),
                                        width: a/16 / 1.4,
                                        height: a/16 / 1.4,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                controller.counter.value > 500000
                                                    ? theme.primaryColor
                                                    : const Color(0xff9F9F9F),
                                            borderRadius: BorderRadius.circular(
                                                a/60),
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
                        }),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.only(
                            top: a/24, bottom: a/40),
                        width: a,
                        child: Text(
                          'اعتبار فعلی شما ${formatNumber(controller.pref.totalWallet?[0].price ?? 0)} تومان',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      SizedBox(
                        width: a,
                        child: Text(
                          'حداقل مبلغ برای برداشت 500,000 تومان میباشد',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            if (Get.isSnackbarOpen == false) {
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
                                        'حداقل مبلغ برداشت 500،000 تومان میباشد');
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
                              } else if (controller.counterFormKey.currentState!
                                  .validate()) {
                                controller.transactionWalletRequest();
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.only(top: a/40),
                            width: a,
                            padding: EdgeInsetsDirectional.only(
                              top: a/40,
                              bottom: a/40,
                            ),
                            decoration: BoxDecoration(
                                color: controller.isBusyRequest.value == true ||
                                        controller.pref.user.sheba.isEmpty
                                    ? const Color(0xff9F9F9F)
                                    : theme.primaryColor,
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(a/24),
                                    topEnd: Radius.circular(a/24),
                                    bottomStart: Radius.circular(a/40),
                                    bottomEnd: Radius.circular(a/40))),
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
            )
          // }),
    );
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // WalletBinding().dependencies();
    controller.shebaController.text = controller.pref.user.sheba;
    return GestureDetector(
      onTap: () => closeKeyboard(context),
      child:
      // GetBuilder(
      //     init: controller,
      //     builder: (_) {
      //       return
              Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  'برداشت وجه',
                  style: theme.textTheme.headline6,
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsetsDirectional.only(top: a/24),
                  margin: EdgeInsetsDirectional.all(a/24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(a/40),
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
                                      horizontal: a/24),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Get.toNamed(Routes.editProfile);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: kBottomNavigationBarHeight / 1.45,
                                      padding: EdgeInsetsDirectional.only(
                                          end: a/40, start: a/40),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              a/100),
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
                                      start: a/24),
                                  child: Text(
                                    'انتقال به شماره شبا',
                                    style: theme.textTheme.subtitle1,
                                  )),
                          Container(
                            margin:
                                EdgeInsetsDirectional.only(end: a/24),
                            child: Image.asset(
                              'assets/images/shetab-removebg-preview.png',
                              width: a / 7.5,
                              height: a / 7.5,
                            ),
                          ),
                        ],
                      ),
                      if (controller.pref.user.sheba.isNotEmpty)
                        Container(
                          padding: EdgeInsetsDirectional.only(
                              start: a/24,
                              end: a/24,
                              top: a/80,
                              bottom: a/80),
                          child: TextFormFieldWidget(
                            textEditingController: controller.shebaController,
                            readOnly: true,
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            suffixIcon: SizedBox(
                                height: a/16,
                                width: a/16,
                                child: SvgPicture.asset(
                                  'assets/ic_ir.svg',
                                  width: a/80,
                                  height: a/80,
                                )),
                          ),
                        ),
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: a/24, top: a/40),
                        child: Text(
                          'مبلغ (تومان)',
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                      Form(
                        key: controller.counterFormKey,
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    BorderRadius.circular(a/16)),
                            width: a,
                            margin: EdgeInsetsDirectional.only(
                                top: a/24,
                                start: a/24 * 1.2,
                                end: a/24 * 1.2),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: a / 1.45,
                                    height: a/16 / 1.1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffE8E8E8),
                                        borderRadius:
                                            BorderRadius.circular(a/16)),
                                    child: Container(
                                      margin: EdgeInsets.only(top: a/40),
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
                                        controller:
                                            controller.counterController,
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
                                                        a/60)),
                                            disabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a/60)),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a/60)),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        a/60)),
                                            contentPadding:
                                                EdgeInsetsDirectional.only(
                                                    top: a/100 / 2,
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
                                          10000000000000) {
                                        controller.increaseCounter();
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsetsDirectional.only(
                                            top: a/100),
                                        width: a/16 / 1.4,
                                        height: a/16 / 1.4,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: controller.counter.value <=
                                                    10000000000000
                                                ? theme.primaryColor
                                                : const Color(0xff9F9F9F),
                                            borderRadius: BorderRadius.circular(
                                                a/60),
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
                                      if (controller.counter.value > 50000) {
                                        controller.decreaseCounter();
                                      }
                                    },
                                    child: Container(
                                        margin: EdgeInsetsDirectional.only(
                                            top: a/100),
                                        width: a/16 / 1.4,
                                        height: a/16 / 1.4,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color:
                                                controller.counter.value > 50000
                                                    ? theme.primaryColor
                                                    : const Color(0xff9F9F9F),
                                            borderRadius: BorderRadius.circular(
                                                a/60),
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
                        }),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.only(
                            top: a/24, bottom: a/40),
                        width: a,
                        child: Text(
                          'اعتبار فعلی شما ${formatNumber(controller.pref.totalWallet?[0].price ?? 0)} تومان',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      SizedBox(
                        width: a,
                        child: Text(
                          'حداقل مبلغ برای برداشت 50,000 تومان میباشد',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            closeKeyboard(context);
                            if (Get.isSnackbarOpen == false) {
                              if (controller.pref.user.sheba.isEmpty) {
                                showTheResult(
                                    resultType: SnackbarType.message,
                                    showTheResultType:
                                        ShowTheResultType.snackBar,
                                    title: 'پیام',
                                    message: 'شماره شبا یافت نشد');
                              } else if (controller.counter.value < 50000) {
                                showTheResult(
                                    resultType: SnackbarType.message,
                                    showTheResultType:
                                        ShowTheResultType.snackBar,
                                    title: 'پیام',
                                    message:
                                        'حداقل مبلغ برداشت 50،000 تومان میباشد');
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
                              } else if (controller.counterFormKey.currentState!
                                  .validate()) {
                                controller.transactionWalletRequest();
                              }
                            }
                          },
                          child: Container(
                            margin: EdgeInsetsDirectional.only(top: a/40),
                            width: a,
                            padding: EdgeInsetsDirectional.only(
                              top: a/40,
                              bottom: a/40,
                            ),
                            decoration: BoxDecoration(
                                color: controller.isBusyRequest.value == true ||
                                        controller.pref.user.sheba.isEmpty
                                    ? const Color(0xff9F9F9F)
                                    : theme.primaryColor,
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(a/24),
                                    topEnd: Radius.circular(a/24),
                                    bottomStart: Radius.circular(a/40),
                                    bottomEnd: Radius.circular(a/40))),
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
            )
          // }),
    );
  }
}
