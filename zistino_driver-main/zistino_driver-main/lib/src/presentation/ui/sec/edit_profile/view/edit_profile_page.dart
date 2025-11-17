import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/text_form_field_widget.dart';
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
    if (isSignUp == false) {
      if (isFirstLunch) {
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
                  leading: backIcon(iconColor: Colors.black),
                  // toolbarHeight: kToolbarHeight * 1.5,
                  title: Container(
                    margin: EdgeInsetsDirectional.only(top: smallSize),
                    child: Text(
                      'ویرایش پروفایل',
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
                                  padding: EdgeInsetsDirectional.only(start: smallSize,end: smallSize),
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
                                  onTap: () =>
                                      controller.isAnimated.value = true,
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
                                  padding: EdgeInsetsDirectional.only(start: smallSize,end: smallSize),
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
                                  padding: EdgeInsetsDirectional.only(start: smallSize,end: smallSize),
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
                                      controller.bankNameEditingController,
                                  hint: 'اسم بانک',
                                  label: 'اسم بانک',
                                  onFieldSubmitted: isNextKeyBoard.value ==
                                          false
                                      ? null
                                      : (value) =>
                                          FocusScope.of(context).nextFocus(),
                                  textInputAction: TextInputAction.next,
                                  padding: EdgeInsetsDirectional.only(start: smallSize,end: smallSize),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
          }),
    );
  }
}
