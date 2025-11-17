// ignore_for_file: must_be_immutable
import 'package:zistino/src/presentation/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../binding/edit_profile_binding.dart';
import '../controller/edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  EditProfilePage({this.isSignUp = false, super.key});

  /// Variables///
  bool isSignUp;
  bool isFirstLunch = true;
  RxBool isNextKeyBoard = false.obs;

  /// Instances///
  final theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    EditProfileBinding().dependencies();
    debugPrint('${controller. pref.user.userName.trim()} pref');

    if (isSignUp == false) {
      if (isFirstLunch) {
        Jalali birthdate = controller.pref.user.birthdate.isNotEmpty
            ? Jalali.fromDateTime(
                DateTime.parse(controller.pref.user.birthdate))
            : Jalali.now();
        controller.firstNameEditingController.text =
            controller.pref.user.firstName.isNotEmpty
                ? '${controller.pref.user.firstName.trim()} '
                : '';
        controller.lastNameEditingController.text =
            controller.pref.user.lastName.isNotEmpty
                ? '${controller.pref.user.lastName.trim()} '
                : '';
        controller.emailEditingController.text = controller.pref.user.email;
        controller.shebaNumberEditingController.text =
            controller.pref.user.sheba.replaceAll('IR', '');
        controller.bankNameEditingController.text =
            controller.pref.user.bankname.isNotEmpty
                ? '${controller.pref.user.bankname.trim()} '
                : '';
        controller.representativeEditingController.text =
            controller.pref.user.representativeBy;
        controller.birthDateEditingController.text =
            "${birthdate.formatter.d} ${birthdate.formatter.mN} ${birthdate.formatter.yyyy}";
        controller.value.value =
            controller.pref.user.companyName == 'خانگــی' ? 0 : 1;
        // controller.cityEditingController.text = controller.pref.user.;
        // controller.addressEditingController.text = controller.pref.user.;//todo fix another item from server
        isFirstLunch = false;
      }
    }
    return GestureDetector(
      onTap: () {
        closeKeyboard(context);
        controller.isAnimated.value = false;
      },
      child: GetBuilder<EditProfileController>(
          init: controller,
          builder: (_) {
            return Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.shadowColor.withOpacity(0.2),
                  elevation: 15,
                  centerTitle: true,
                  leading: isSignUp
                      ? const SizedBox()
                      : backIcon(iconColor: Colors.black),
                  // toolbarHeight: kToolbarHeight * 1.5,
                  title: Container(
                    margin: EdgeInsetsDirectional.only(top: smallSize),
                    child: Text(
                      isSignUp ? 'ثبت نام' : 'ویرایش پروفایل',
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  padding: EdgeInsetsDirectional.all(largeSize),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 2),
                            color: const Color(0xff10548B).withOpacity(0.04),
                            blurRadius: 5,
                            blurStyle: BlurStyle.normal,
                            spreadRadius: 4)
                      ],
                      borderRadius: BorderRadiusDirectional.vertical(
                          top: Radius.circular(smallSize))),
                  child: progressButton(
                      isProgress: controller.isBusyEdit.value,
                      isDisable: false,
                      onTap: () {
                        if (controller.editProfileFormKey.currentState!
                            .validate()) {
                          controller.editProfile(isSignUp: isSignUp);
                        }
                      },
                      text: isSignUp ? 'ثبت اطلاعات' : 'ویرایش پروفایل'),
                ),
                body: NotificationListener(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return true;
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: smallSize),
                      margin: EdgeInsets.symmetric(
                          horizontal: standardSize, vertical: largeSize),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color:
                                    const Color(0xff10548B).withOpacity(0.04),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: 4)
                          ],
                          borderRadius:
                              BorderRadiusDirectional.circular(standardSize)),
                      child: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: controller.editProfileFormKey,
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsetsDirectional.only(
                                    top: standardSize,
                                    start: standardSize,
                                    end: standardSize),
                                child: TextFormFieldWidget(
                                  textEditingController:
                                      controller.firstNameEditingController,
                                  hint: 'نام',
                                  onTap: () {
                                    controller.isAnimated.value = true;
                                    isSignUp
                                        ? controller.firstNameEditingController
                                                .text =
                                            controller
                                                .firstNameEditingController.text
                                                .trim()
                                        : null;
                                  },
                                  onFieldSubmitted: isNextKeyBoard.value ==
                                          false
                                      ? null
                                      : (value) =>
                                          FocusScope.of(context).nextFocus(),
                                  onChange: (value) {
                                    controller.firstNameEditingController.text
                                            .isEmpty
                                        ? isNextKeyBoard.value = true
                                        : false;
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'لطفا فیلد را پر کنید';
                                    }
                                    return null;
                                  },
                                  padding: EdgeInsetsDirectional.only(
                                      start: smallSize, end: smallSize),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  enableBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  fillColor: AppColors.homeBackgroundColor,
                                  textInputAction: TextInputAction.next,
                                  label: 'نام',
                                )),
                            Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: standardSize,
                                    end: standardSize,
                                    top: smallSize),
                                child: TextFormFieldWidget(
                                  textEditingController:
                                      controller.lastNameEditingController,
                                  hint: 'نام خانوادگی',
                                  label: 'نام خانوادگی',
                                  onTap: () {
                                    controller.isAnimated.value = true;
                                    isSignUp
                                        ? controller.lastNameEditingController
                                                .text =
                                            controller
                                                .lastNameEditingController.text
                                                .trim()
                                        : null;
                                  },
                                  onFieldSubmitted: isNextKeyBoard.value ==
                                          false
                                      ? null
                                      : (value) =>
                                          FocusScope.of(context).nextFocus(),
                                  onChange: (value) {
                                    controller.firstNameEditingController.text
                                            .isEmpty
                                        ? isNextKeyBoard.value = true
                                        : false;
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'لطفا فیلد را پر کنید';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  padding: EdgeInsetsDirectional.only(
                                      start: smallSize, end: smallSize),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  enableBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  fillColor: AppColors.homeBackgroundColor,
                                )),
                            Container(
                                padding: EdgeInsetsDirectional.only(
                                    start: standardSize,
                                    end: standardSize,
                                    top: smallSize),
                                child: TextFormFieldWidget(
                                  readOnly: true,
                                  textEditingController:
                                      controller.birthDateEditingController,
                                  hint: 'تاریخ تولد',
                                  label: 'تاریخ تولد',
                                  onTap: () {
                                    controller.isAnimated.value = true;
                                    controller
                                        .showDatePickerReceivedDate(context);
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'لطفا تاریخ تولد خود را انتخاب کنید';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  padding: EdgeInsetsDirectional.only(
                                      start: smallSize, end: smallSize),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  enableBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  fillColor: AppColors.homeBackgroundColor,
                                )),
                            // Container(
                            //   padding: EdgeInsetsDirectional.only(
                            //       start: standardSize,
                            //       end: standardSize,
                            //       top: standardSize),
                            //   child: TextFormFieldEditProfileWidget(
                            //     textEditingController:
                            //         controller.addressEditingController,
                            //     onTap: () =>
                            //         controller.isAnimated.value = true,
                            //     hint: 'آدرس',
                            //     label:
                            //         'آدرس(انتخاب از روی نقشه با استفاده از دکمه لوکیشن)',
                            //     onFieldSubmitted: isNextKeyBoard.value ==
                            //             false
                            //         ? null
                            //         : (value) =>
                            //             FocusScope.of(context).nextFocus(),
                            //     textInputAction: TextInputAction.next,
                            //     prefixIcon: GestureDetector(
                            //       onTap: () => Get.to(MapPage()),
                            //       child: Column(
                            //         mainAxisSize: MainAxisSize.max,
                            //         children: [
                            //           Container(
                            //               margin: EdgeInsetsDirectional.only(
                            //                   end: smallSize),
                            //               padding: EdgeInsetsDirectional.all(
                            //                   smallSize),
                            //               // width: iconSizeXSmall,
                            //               // height: iconSizeXSmall,
                            //               decoration: BoxDecoration(
                            //                   color: theme.primaryColor,
                            //                   borderRadius:
                            //                       BorderRadiusDirectional
                            //                           .circular(smallRadius)),
                            //               child: SvgPicture.asset(
                            //                   'assets/ic_location.svg',
                            //                   color: AppColors
                            //                       .homeBackgroundColor)),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                                padding: EdgeInsetsDirectional.only(
                                    top: standardSize,
                                    start: standardSize,
                                    end: standardSize),
                                child: TextFormFieldWidget(
                                  textEditingController:
                                      controller.emailEditingController,
                                  hint: 'ایمیل',
                                  onFieldSubmitted: isNextKeyBoard.value ==
                                          false
                                      ? null
                                      : (value) =>
                                          FocusScope.of(context).nextFocus(),
                                  onChange: (value) {
                                    controller
                                            .emailEditingController.text.isEmpty
                                        ? isNextKeyBoard.value = true
                                        : false;
                                  },
                                  validator: (value) {
                                    if (value?.isEmpty ?? false) {
                                      return 'لطفا فیلد را پر کنید';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  label: 'ایمیل',
                                  padding: EdgeInsetsDirectional.only(
                                      start: smallSize, end: smallSize),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  enableBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  fillColor: AppColors.homeBackgroundColor,
                                )),
                            Container(
                              margin: EdgeInsetsDirectional.only(
                                  bottom: xSmallSize,
                                  top: standardSize,
                                  start: standardSize,
                                  end: standardSize),
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                'نوع کاربری',
                                style: theme.textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlackColor,
                                ),
                              ),
                            ),
                            Obx(() {
                              return Container(
                                margin: EdgeInsetsDirectional.only(
                                    bottom: xSmallSize,
                                    start: standardSize,
                                    end: standardSize),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: userTypeWidget(
                                          onTap: () {
                                            controller.value.value = 0;
                                          },
                                          name: 'خانگــی',
                                          isSelect:
                                              controller.value.value == 0),
                                    ),
                                    SizedBox(width: standardSize),
                                    Expanded(
                                      flex: 1,
                                      child: userTypeWidget(
                                          onTap: () {
                                            controller.value.value = 1;
                                          },
                                          name: 'صنفــی',
                                          isSelect:
                                              controller.value.value == 1),
                                    )
                                  ],
                                ),
                              );
                            }),
                            Container(
                                padding: EdgeInsetsDirectional.only(
                                    top: standardSize,
                                    start: standardSize,
                                    end: standardSize),
                                child: TextFormFieldWidget(
                                  textEditingController:
                                      controller.bankNameEditingController,
                                  hint: 'اسم بانک',
                                  label: 'اسم بانک',
                                  onTap: () {
                                    isSignUp
                                        ? controller.bankNameEditingController
                                                .text =
                                            controller
                                                .bankNameEditingController.text
                                                .trim()
                                        : null;
                                  },
                                  onFieldSubmitted: isNextKeyBoard.value ==
                                          false
                                      ? null
                                      : (value) =>
                                          FocusScope.of(context).nextFocus(),
                                  textInputAction: TextInputAction.next,
                                  padding: EdgeInsetsDirectional.only(
                                      start: smallSize, end: smallSize),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  enableBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  fillColor: AppColors.homeBackgroundColor,
                                )),
                            Container(
                                padding: EdgeInsetsDirectional.only(
                                    top: standardSize,
                                    start: standardSize,
                                    end: standardSize),
                                child: TextFormFieldWidget(
                                  textEditingController:
                                      controller.shebaNumberEditingController,
                                  // padding: EdgeInsetsDirectional.only(start: standardSize),
                                  hint: '012345678912345678912345',
                                  label: 'شماره شبا',
                                  validator: (value) {
                                    if (value?.isNotEmpty ?? false) {
                                      if ((value?.length ?? 0) != 24) {
                                        return 'شماره شبا 24 رقمی میباشد';
                                      }
                                    }
                                    return null;
                                  },
                                  textDirection: TextDirection.ltr,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  counterStyle: theme.textTheme.caption,
                                  onTap: () {

                                  },
                                  // padding: EdgeInsetsDirectional.only(start: smallSize,end: smallSize),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  enableBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.circular(xSmallRadius)),
                                  fillColor: AppColors.homeBackgroundColor,
                                  suffixIcon: Container(
                                      height: xxLargeSize,
                                      width: xxLargeSize,
                                      child: SvgPicture.asset(
                                        'assets/ic_ir.svg',
                                        width: iconSizeXXSmall,
                                        height: iconSizeXXSmall,
                                      )),
                                )),
                            if (isSignUp == true)
                              Container(
                                  padding: EdgeInsetsDirectional.only(
                                      top: standardSize,
                                      start: standardSize,
                                      end: standardSize),
                                  child: TextFormFieldWidget(
                                    readOnly: isSignUp ? false : true,
                                    textEditingController: controller
                                        .representativeEditingController,
                                    // padding: EdgeInsetsDirectional.only(start: standardSize),
                                    hint: 'کد معرف',
                                    label: 'کد معرف',
                                    textInputAction: TextInputAction.done,
                                    padding: EdgeInsetsDirectional.only(
                                        start: smallSize, end: smallSize),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(
                                            xSmallRadius)),
                                    enableBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(
                                            xSmallRadius)),
                                    fillColor: AppColors.homeBackgroundColor,
                                  )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }),
    );
  }

// void _dialogEducation() {
//   showDialog(
//     context: Get.context!,
//     builder: (context) => Stack(
//       children: [
//         AlertDialog(
//           title: Container(
//               margin: EdgeInsetsDirectional.only(bottom: standardSize),
//               child: Text(
//                 'میزان تحصیلات خود را مشخص کنید',
//                 style: theme.textTheme.subtitle2,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 textAlign: TextAlign.center,
//               )),
//           titleTextStyle: theme.textTheme.subtitle2,
//           contentPadding: EdgeInsetsDirectional.only(
//               top: 0, bottom: 0, start: standardSize, end: standardSize),
//           content: SizedBox(
//               height: fullWidth / 7,
//               width: fullWidth,
//               child: NotificationListener(
//                 onNotification: (OverscrollIndicatorNotification overScroll) {
//                   overScroll.disallowIndicator();
//                   return true;
//                 },
//                 child: SizedBox(
//                   height: fullWidth / 3,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         height: 1,
//                         decoration:
//                             const BoxDecoration(color: AppColors.borderColor),
//                       ),
//                       Expanded(
//                         child: PageView.builder(
//                           itemCount: edFakeModel().length,
//                           scrollDirection: Axis.vertical,
//                           controller: PageController(
//                               viewportFraction: 0.9,
//                               initialPage: controller.focusedIndex),
//                           onPageChanged: (int index) {
//                             controller.onItemFocus(index);
//                           },
//                           itemBuilder: (_, i) {
//                             return Transform.scale(
//                               alignment: Alignment.center,
//                               scale: i == controller.focusedIndex ? 1 : 0.9,
//                               child: Container(
//                                 margin: EdgeInsetsDirectional.only(
//                                     top: smallSize),
//                                 child: Text(
//                                   edFakeModel()[i].educationLevel,
//                                   style: theme.textTheme.subtitle2,
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Container(
//                         height: 1,
//                         decoration:
//                             const BoxDecoration(color: AppColors.borderColor),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // child: ListView.builder(
//                 //   shrinkWrap: true,
//                 //   scrollDirection: Axis.vertical,
//                 //
//                 //   // onItemFocus: controller.onItemFocus,
//                 //   // itemSize: 6,
//                 //   itemCount: edFakeModel().length,
//                 //   itemBuilder: (context, index) {
//                 //     {
//                 //       // if (index % 2 == 0) {
//                 //         return _buildCarousel(context,index ~/ 2,edFakeModel()[index]);
//                 //       // }
//                 //       // else {
//                 //       //   return Divider();
//                 //       }
//                 //       // _itemEdList(edFakeModel()[index]);
//                 //     // }
//                 //   }  )
//               )),
//           actions: [
//             // GestureDetector(
//             //   onTap: () {
//             //     Get.back();
//             //     controller.educationEditingController.text =
//             //         edFakeModel()[controller.focusedIndex].educationLevel;
//             //     // controller.educationEditingController.text;
//             //   },
//             //   child: Container(
//             //     margin: EdgeInsetsDirectional.all(smallSize),
//             //     decoration: BoxDecoration(
//             //         color: theme.primaryColor,
//             //         borderRadius: BorderRadius.circular(xSmallRadius)),
//             //     width: fullWidth,
//             //     padding: EdgeInsetsDirectional.all(standardSize / 1.2),
//             //     child: Text(
//             //       'تایید',
//             //       style: theme.textTheme.subtitle2!
//             //           .copyWith(color: Colors.white),
//             //       textAlign: TextAlign.center,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//         Align(
//           alignment: const Alignment(0, -0.30),
//           child: Container(
//             padding:
//                 EdgeInsetsDirectional.only(top: smallSize, bottom: smallSize),
//             width: fullWidth / 1.5,
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 4),
//                 ],
//                 borderRadius: BorderRadius.circular(smallRadius)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SvgPicture.asset('assets/ic_education.svg'),
//                 // const Icon(Icons.map, color: Colors.blue),
//                 SizedBox(width: xxSmallSize),
//                 Text(
//                   'میزان تحصیلات',
//                   style: theme.textTheme.subtitle1,
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

  Widget userTypeWidget(
      {required VoidCallback onTap,
      required String name,
      required bool isSelect}) {
    var theme = Get.theme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.only(
              bottom: xSmallSize,
              left: smallSize,
              right: smallSize,
              top: xSmallSize),
          decoration: BoxDecoration(
            color:
                isSelect ? theme.primaryColor : AppColors.homeBackgroundColor,
            borderRadius: BorderRadius.circular(xSmallRadius),
          ),
          child: Container(
            alignment: AlignmentDirectional.center,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.subtitle2?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.7,
                  color: isSelect
                      ? AppColors.textWhiteColor
                      : AppColors.textBlackColor),
            ),
          )),
    );
  }
}
