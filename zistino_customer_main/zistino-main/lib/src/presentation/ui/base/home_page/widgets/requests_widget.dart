import 'package:zistino/src/common/utils/close_keyboard.dart';
import 'package:zistino/src/presentation/ui/base/home_page/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../data/models/inv/driver_delivery_model.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../request_detail_page/view/request_detail_page.dart';

Widget requestWidget(DriverDeliveryModel model, int index) {
  var slidable = Slidable.of(Get.context!);
  var theme = Get.theme;
  return SlidableAutoCloseBehavior(
    closeWhenTapped: false,
    child: Slidable(
      enabled: true,
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: GestureDetector(
            onTap: () {
              removeRequestSheet(model: model);
              // slidable?.close();
              // removeAddressSheet(Get.context!, AddressEntity());
            },
            child: Container(
                width: fullWidth / 5,
                margin: EdgeInsetsDirectional.only(
                  top: standardSize,
                  start: standardSize,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.errorColor),
                  borderRadius: BorderRadiusDirectional.circular(standardSize),
                  color: theme.errorColor.withOpacity(0.09),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset('assets/trash.svg',
                          width: iconSizeMedium,
                          height: iconSizeMedium,
                          color: theme.errorColor),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: smallSize),
                      child: Text(
                        'لغو',
                        style: theme.textTheme.caption!.copyWith(
                            color: theme.errorColor,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )),
          ),
          children: const []),
      child: GestureDetector(
        onTap: () => Get.to(RequestDetailPage(entity: model)),
        child: Container(
          margin: EdgeInsetsDirectional.only(
            top: standardSize,
          ),
          padding: EdgeInsetsDirectional.all(standardSize),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(xSmallRadius),
            color: Colors.white,
            // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,
            // spreadRadius: 3
            // )]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _rowItems('assets/ic_frame.svg', model.creator),
              SizedBox(
                height: smallSize,
              ),
              _rowItems('assets/ic_location.svg', model.address),
              SizedBox(
                height: smallSize,
              ),
              _rowItems('assets/ic_call.svg', model.phoneNumber),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loadingRequestWidget(DriverDeliveryModel entity) {
   ThemeData theme = Get.theme;

  return Container(
    width: fullWidth,
    margin: EdgeInsets.symmetric(vertical: smallSize),
    padding: EdgeInsets.only(
        left: standardSize,
        right: standardSize,
        top: standardSize,
        bottom: standardSize),
    decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(mediumRadius),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12,
              spreadRadius: -3,
              blurRadius: 12,
              offset: Offset(0, 5))
        ]),
    child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: fullWidth,
            padding: EdgeInsets.only(bottom: smallSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(mediumRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "نام راننده",
                  style: theme.textTheme.caption?.copyWith(
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.captionTextColor),
                ),
                SizedBox(width: smallSize),
                Expanded(
                  child: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      entity.driver.isEmpty
                          ? 'در انتظار تعیین راننده'
                          : entity.driver,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.caption?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: xxSmallSize),
                Container(
                  width: fullWidth / 9,
                  height: fullWidth / 9,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(width: 1, color: AppColors.primaryColor)),
                  child: Center(
                    child: Image.asset(
                      'assets/images/profile_avatar.png',
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: AppColors.dividerColor,
          ),
          if(entity.vatNumber.isNotEmpty)
            Container(
              width: fullWidth,
              padding: EdgeInsets.only(
                  top: smallSize, bottom: smallSize),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(mediumRadius),
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "شماره پلاک",
                      style: theme.textTheme.caption?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.captionTextColor),
                    ),
                  ),
                  SizedBox(width: smallSize),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            xxSmallRadius / 1.5),
                        border: Border.all(
                            width: 1, color: Colors.black)),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: xxSmallSize / 2,
                              horizontal: xxSmallSize),
                          child: Column(
                            children: [
                              Text(
                                'ایران',
                                style: theme.textTheme.overline
                                    ?.copyWith(
                                    fontFamily: 'b-nazanin',
                                    fontSize: 9,
                                    letterSpacing: 0.5,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: Colors.black),
                              ),
                              SizedBox(height: xxSmallSize / 2),
                              Text(
                                entity.vatNumber.isNotEmpty
                                    ? entity.vatNumber
                                    .replaceRange(0, 7, '')
                                    : '12',
                                style: theme.textTheme.bodyText2
                                    ?.copyWith(
                                    fontFamily: 'b-nazanin',
                                    letterSpacing: 0.5,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: xLargeSize / 1.2,
                          width: 1,
                          decoration: const BoxDecoration(
                              color: Colors.black),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: xxSmallSize / 2,
                              horizontal: xSmallSize / 2),
                          child: Text(
                            entity.vatNumber.isNotEmpty
                                ? '${entity.vatNumber[5]}${entity.vatNumber[4]}${entity.vatNumber[3]} ${entity.vatNumber[2]} ${entity.vatNumber[1]}${entity.vatNumber[0]}'
                                : '345 الف 12',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.subtitle2
                                ?.copyWith(
                                fontFamily: 'b-nazanin',
                                letterSpacing: 0.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          height: xLargeSize / 1.2,
                          width: 1,
                          decoration: const BoxDecoration(
                              color: Colors.black),
                        ),
                        Container(
                          height: xLargeSize / 1.2,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius:
                              BorderRadiusDirectional.only(
                                  topEnd: Radius.circular(
                                      xxSmallRadius / 2.2),
                                  bottomEnd:
                                  Radius.circular(
                                      xxSmallRadius /
                                          2.2))),
                          padding: EdgeInsets.symmetric(
                              vertical: xxSmallSize / 1.8,
                              horizontal: xxSmallSize / 2),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  'assets/pic_flag_iran.webp',
                                  height: xSmallSize / 1.2),
                              SizedBox(
                                  height: xxSmallSize / 1.5),
                              Text(
                                'I.R\nIRAN',
                                textAlign: TextAlign.left,
                                style: theme.textTheme.overline
                                    ?.copyWith(
                                    fontSize: 4,
                                    letterSpacing: 0.5,
                                    fontWeight:
                                    FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          // if(entity.driverPhone.isNotEmpty)
          Divider(
            thickness: 1,
            color: AppColors.dividerColor,
          ),
          // if(entity.driverPhone.isNotEmpty)
          Container(
            width: fullWidth,
            padding: EdgeInsets.symmetric(vertical: smallSize),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(mediumRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "آدرس تحویل پسماند",
                  style: theme.textTheme.caption?.copyWith(
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.captionTextColor),
                ),
                SizedBox(height: xxSmallSize),
                Text(
                  entity.address,
                  style: theme.textTheme.caption?.copyWith(
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
          ),

          // if (entity.driverPhone.isNotEmpty)
          //   Divider(
          //     thickness: 1,
          //     color: AppColors.dividerColor,
          //   ),
          // if (entity.driverPhone.isNotEmpty)
          //   Container(
          //     width: fullWidth,
          //     padding: EdgeInsets.only(top: smallSize, bottom: xxSmallSize),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(mediumRadius),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Expanded(
          //           child: Text(
          //             "شماره همراه",
          //             style: theme.textTheme.caption?.copyWith(
          //                 letterSpacing: 0.5,
          //                 fontWeight: FontWeight.w600,
          //                 color: AppColors.captionTextColor),
          //           ),
          //         ),
          //         SizedBox(width: smallSize),
          //         Text(
          //           entity.driverPhone,
          //           style: theme.textTheme.caption?.copyWith(
          //               letterSpacing: 0.5,
          //               fontWeight: FontWeight.w600,
          //               color: Colors.black),
          //         ),
          //       ],
          //     ),
          //   ),

          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsetsDirectional.only(
                  top: standardSize),
              child: Ink(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: theme.primaryColor),
                    color: const Color(0xffF1FCDA),
                    borderRadius: BorderRadius.circular(smallRadius)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(smallRadius),
                  splashColor: Colors.black.withOpacity(0.03),
                  onTap: () {
                    Get.to(RequestDetailPage(entity: entity));
                  },
                  child: Container(
                    width: fullWidth,
                    padding: EdgeInsets.symmetric(
                        vertical: smallSize, horizontal: xSmallSize),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(smallRadius)),
                    child: Center(
                      child: Text(
                        'جزئیات',
                        style: theme.textTheme.subtitle2!
                            .copyWith(color: theme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    ),
  );

  // return SlidableAutoCloseBehavior(
  //   closeWhenTapped: false,
  //   child: GestureDetector(
  //     onTap: () => Get.to(RequestDetailPage(entity: model)),
  //     child: Container(
  //       margin: EdgeInsetsDirectional.only(
  //         top: standardSize,
  //       ),
  //       padding: EdgeInsetsDirectional.all(standardSize),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(xSmallRadius),
  //         color: Colors.white,
  //         // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,
  //         // spreadRadius: 3
  //         // )]
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           _rowItems('assets/ic_frame.svg', model.creator),
  //           SizedBox(
  //             height: smallSize,
  //           ),
  //           _rowItems('assets/ic_location.svg', model.address),
  //           SizedBox(
  //             height: smallSize,
  //           ),
  //           _rowItems('assets/ic_call.svg', model.phoneNumber),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}

Widget _rowItems(String icon, String name) {
  final theme = Get.theme;

  return Row(
    children: [
      SvgPicture.asset(
        icon,
        color: theme.primaryColor,
      ),
      SizedBox(width: smallSize),
      Expanded(
        child: Text(
          name,
          style: theme.textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      )
    ],
  );
}

void removeRequestSheet({required DriverDeliveryEntity model}) {
  final HomeController controller = Get.find<HomeController>();
  final theme = Get.theme;
  final descKey = GlobalKey<FormState>();
  showModalBottomSheet(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(largeSize),
          topLeft: Radius.circular(largeSize),
        ),
      ),
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () => closeKeyboard(context),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(largeSize),
                    topLeft: Radius.circular(largeSize),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff10548B).withOpacity(0.16),
                      spreadRadius: 10,
                      blurRadius: 10,
                      // blurStyle: BlurStyle.solid
                    )
                  ]),
              padding: EdgeInsets.symmetric(vertical: largeSize),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: largeSize,
                        bottom: standardSize,
                        start: standardSize,
                        end: standardSize),
                    child: Text(
                      'دلیل لغو درخواست خود را بیان کنید؟',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: standardSize),
                    child: Form(
                      key: descKey,
                      child: TextFormFieldWidget(
                        hint: 'توضیحـات',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'لطفا برای ثبت درخواست لغو فیلد توضیحات را پر کنید';
                          }
                          return null;
                        },
                        textEditingController: controller.descriptionController,
                        padding: EdgeInsetsDirectional.all(xSmallSize),
                        maxLine: 5,
                        fillColor: AppColors.homeBackgroundColor,
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
                  ),
                  SizedBox(height: largeSize),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Obx(() {
                          return Container(
                            margin:
                                EdgeInsetsDirectional.only(start: standardSize),
                            width: fullWidth / 2.4,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: controller.isBusyDelete.value
                                          ? fullWidth / 26.9
                                          : fullWidth / 26),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(mediumRadius),
                                      side: const BorderSide(
                                          width: 1,
                                          color: AppColors.primaryColor))),
                              onPressed: controller.isBusyDelete.value
                                  ? null
                                  : () {
                                      if (descKey.currentState!.validate()) {
                                        controller.deleteRequest(model);
                                        // controller.deliveryData?.data.removeAt(index);
                                        // Get.back();
                                      }
                                    },
                              child: controller.isBusyDelete.value
                                  ? const CupertinoActivityIndicator()
                                  : Text('تایید',
                                      style: theme.textTheme.bodyText2
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor)),
                            ),
                          );
                        }),
                        Container(
                          margin: EdgeInsetsDirectional.only(end: standardSize),
                          width: fullWidth / 2.4,
                          // margin: EdgeInsetsDirectional.only(start: xSmallSize),
                          child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: fullWidth / 26),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(mediumRadius),
                                    side: BorderSide.none)),
                            onPressed: () {
                              Get.back();
                              controller.descriptionController.clear();
                            },
                            child: Text('انصراف',
                                style: theme.textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.backgroundColor)),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        );
      });
}
