// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/text_form_field_widget.dart';
import '../controller/residue_controller.dart';

class CreateDriverDelivery extends StatelessWidget {
  CreateDriverDelivery({super.key,required this.DeliveryUserId});
  String DeliveryUserId;
  final theme = Get.theme;
  final ResidueDeliveryController controller = Get.find();

  // AddressEntity address;
  // int orderId;

  @override
  Widget build(BuildContext context) {
    debugPrint('${controller.pref.token} token');
    Future<bool> onBackClicked() {
      // controller.phoneNumberTxt.value = '';
      controller.clearDataInCreateDelivery();
      return Future.value(false);
    }

    return WillPopScope(
      onWillPop: onBackClicked,
      child: Scaffold(
        appBar: AppBar(
            leading: backIcon(
              onTap: () {
                controller.clearDataInCreateDelivery();
              },
            ),
            title: Text(
              'ثبت سفارش',
              style: theme.textTheme.subtitle1,
            )),
        body: GestureDetector(
          onTap: () => closeKeyboard(context),
          child: Stack(
            children: [
              Positioned.fill(
                bottom: xxLargeSize * 1.5,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: standardSize),
                    margin: EdgeInsetsDirectional.all(standardSize),
                    decoration: BoxDecoration(
                        color: AppColors.homeBackgroundColor,
                        borderRadius: BorderRadius.circular(standardSize)),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: standardSize),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'مکان ثبت',
                          textAlign: TextAlign.start,
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                      SizedBox(
                        height: standardSize,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: standardSize),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "مرکز جمع آوری پسماند زیستینو",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      SizedBox(
                        height: smallSize,
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(horizontal: standardSize),
                      //   child: Row(
                      //     children: [
                      //       const Icon(
                      //         Icons.calendar_month_outlined,
                      //         color: Colors.black,
                      //       ),
                      //       SizedBox(
                      //         width: xxSmallSize,
                      //       ),
                      //       Text(
                      //         'زمان های در دسترس',
                      //         style: theme.textTheme.subtitle2!
                      //             .copyWith(color: Colors.black),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: standardSize,
                      // ),
                      // SizedBox(
                      //   height: fullWidth / 8,
                      //   // padding: EdgeInsetsDirectional.only( end: xxSmallSize),
                      //   child: GetBuilder(
                      //       init: controller,
                      //       builder: (_) {
                      //         return ListView.builder(
                      //           shrinkWrap: true,
                      //           itemCount: controller.days.value.length,
                      //           scrollDirection: Axis.horizontal,
                      //           padding: EdgeInsetsDirectional.only(
                      //               start: standardSize, end: xSmallSize),
                      //           physics: const BouncingScrollPhysics(),
                      //           itemBuilder: (context, index) =>
                      //               dailyWidget(index),
                      //         );
                      //       }),
                      // ),
                      // SizedBox(
                      //   height: standardSize,
                      // ),
                      // SizedBox(
                      //     height: fullWidth / 4,
                      //     child: Obx(
                      //       () => ListView.builder(
                      //         shrinkWrap: true,
                      //         padding: EdgeInsetsDirectional.only(
                      //             start: standardSize, end: xSmallSize),
                      //         itemCount: controller.hours.length,
                      //         scrollDirection: Axis.horizontal,
                      //         physics: const BouncingScrollPhysics(),
                      //         itemBuilder: (context, index) =>
                      //             selectHourWidget(index),
                      //       ),
                      //     )),
                      // SizedBox(height: standardSize),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: standardSize),
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          'توضیحـات',
                          textAlign: TextAlign.start,
                          style: theme.textTheme.subtitle1,
                        ),
                      ),
                      SizedBox(height: smallSize),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: standardSize),
                        child: TextFormFieldWidget(
                          hint: 'توضیحـات',
                          textEditingController:
                              controller.descriptionController,
                          padding: EdgeInsetsDirectional.all(xSmallSize),
                          maxLine: 5,
                          onTap: () {
                            if (controller
                                .descriptionController.text.isNotEmpty) {
                              if (controller.descriptionController.text
                                      .endsWith(' ') ==
                                  false) {
                                controller.descriptionController.text =
                                    '${controller.descriptionController.text.trim()} ';
                              }
                            }
                          },
                          fillColor: theme.backgroundColor,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(smallRadius)),
                          disableBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(smallRadius)),
                          enableBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(smallRadius)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(smallRadius)),
                        ),
                      ),
                      SizedBox(height: standardSize),
                    ]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(standardSize),
                  child: Obx(() => progressButton(
                        text: 'ثبت درخواست',
                        isDisable: false,
                        isProgress: controller.isBusyCreateDelivery.value,
                        onTap: () {
                          controller.createOrder(30210,DeliveryUserId); //todo addressID
                        },
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*
void sheetSelectTime(BuildContext context) {
  final theme = Get.theme;
  showCupertinoModalPopup(
    context: context,
    builder: (context) => Stack(
      children: [
        Align(
          alignment: const Alignment(1, -0.1),
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.residuePricePage),
            child: Container(
              margin: EdgeInsetsDirectional.only(start: smallSize),
              padding: EdgeInsetsDirectional.all(xSmallSize),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(xSmallRadius)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.discount,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: xxSmallSize,
                  ),
                  Text(
                    'استعلام قیمت پسماند',
                    style: theme.textTheme.subtitle2!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CupertinoActionSheet(actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              isDefaultAction: true,
              isDestructiveAction: false,
              onPressed: () {},
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsetsDirectional.all(smallSize),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.black),
                        Text(
                          'آدرس',
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: Colors.black.withOpacity(0.5)),
                        ),
                        SizedBox(
                          width: xSmallSize,
                        ),
                        Expanded(
                          child: Text(
                            'منطقه 6 ،محله چهنو،بلوار چمن،چمن 44 ،شیرودی 12،ایستگاه چهارراه راهنمایی',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.subtitle2!
                                .copyWith(color: Colors.black.withOpacity(0.5)),
                          ),
                        ),
                        Icon(
                          Icons.edit,
                          color: theme.primaryColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: smallSize,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.only(start: smallSize),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: xxSmallSize,
                        ),
                        Text(
                          'زمان های در دسترس',
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: Colors.black.withOpacity(0.5)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: smallSize,
                  ),
                  Container(
                    height: fullWidth / 8,
                    padding: EdgeInsetsDirectional.only(
                        start: xSmallSize, end: xxSmallSize),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dailyList().length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          dailyWidget(dailyList()[index], index),
                    ),
                  ),
                  SizedBox(
                    height: smallSize,
                  ),
                  Container(
                    height: fullWidth / 4,
                    padding: EdgeInsetsDirectional.only(
                        start: xSmallSize, end: xxSmallSize),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: hourList().length,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          selectHourWidget(hourList(), index),
                    ),
                  ),
                  SizedBox(height: standardSize),
                  Container(
                      padding: EdgeInsetsDirectional.all(standardSize),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: kBottomNavigationBarHeight,
                          padding: EdgeInsetsDirectional.only(
                              end: standardSize, start: standardSize),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: theme.primaryColor.withOpacity(0.2),
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 12,
                                    spreadRadius: 0)
                              ],
                              borderRadius: BorderRadius.circular(smallRadius),
                              color: AppColors.primaryColor),
                          child: Text(
                            'ثبت درخواست',
                            style: theme.textTheme.subtitle1?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ))
                  // progressButton(
                  //   text: 'ثبت درخواست',
                  //   onTap: () {
                  //     Get.back();
                  //   },
                  // ),
                ],
              ),
            )
          ]),
        ),
      ],
    ),
  );
}
*/
