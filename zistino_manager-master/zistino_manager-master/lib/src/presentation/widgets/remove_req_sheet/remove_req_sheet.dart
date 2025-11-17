import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/utils/close_keyboard.dart';
import '../../../common/utils/show_result_action.dart';
import '../../../data/enums/bas/theme/show_result_type.dart';
import '../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../data/models/base/driver_delivery_model.dart';
import '../../../domain/entities/base/driver_delivery.dart';
import '../../style/colors.dart';
import '../../style/dimens.dart';
import '../../ui/base/home_page/controller/home_controller.dart';
import '../text_form_field_widget.dart';

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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(
                        top: 0,
                        bottom: smallSize,
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
                    margin: EdgeInsetsDirectional.only(
                        start: standardSize, bottom: smallSize),
                    child: Wrap(
                      spacing: 2,
                      children: [
                        Obx(() => _chipItem('کاربر پاسخ نمی دهد', () {
                              controller.statusRemove.value = 7;
                            },
                                controller.statusRemove.value == 7
                                    ? AppColors.primaryColor
                                    : AppColors.captionColor.withOpacity(0.1))),
                        Obx(() => _chipItem('کمبود زمان برای دریافت بازیافت',
                                () {
                              controller.statusRemove.value = 6;
                            },
                                controller.statusRemove.value == 6
                                    ? AppColors.primaryColor
                                    : AppColors.captionColor.withOpacity(0.1))),
                        // _chipItem('دلایل دیگر...', () {
                        //   controller.statusRemove.value =6;
                        //
                        // }
                        // ),
                      ],
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
                            return 'لطفا برای ثبت درخواست فیلد توضیحات را پر کنید';
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
                                      if (controller.statusRemove.value != -1 && descKey.currentState!.validate()) {
                                        // controller.rejectRequest(model);
                                        // controller.deliveryData?.data.removeAt(index);
                                      }else{
                                        showTheResult(
                                            resultType: SnackbarType.error,
                                            showTheResultType: ShowTheResultType.snackBar,
                                            title: 'خطا',
                                            message: 'لطفا دلیل لغو را انتخاب کنید');
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
                              controller.statusRemove.value = -1;

                              controller.descriptionController.clear();
                            },
                            child: Text('لغو',
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

List<String> _chipName = [
  'کاربر پاسخ نمی دهد',
  'کمبود زمان برای دریافت بازیافت',
  'دلایل دیگر...'
];

Widget _chipItem(String name, VoidCallback onTap, Color backGroundColor) {
  return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(name),
        padding: EdgeInsetsDirectional.all(xSmallSize),
        backgroundColor: backGroundColor,
      ));
}
