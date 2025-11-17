import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/exit_dialog_widget.dart';
import '../../../base/invite_page/view/invite_page.dart';

import '../binding/profile_binding.dart';
import '../controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  ProfilePage({super.key});

  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {

    ProfileBinding().dependencies();
    debugPrint('${controller.pref.startLocationId} startLocIdHome');
    return GetBuilder<ProfileController>(
        init: controller,
        initState: (state) {
          controller.getUserInfo();
          controller.fetchWalletData();
        },
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.homeBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              shadowColor: AppColors.shadowColor.withOpacity(0.2),
              elevation: 15,
              centerTitle: true,
              title: Container(
                margin: EdgeInsetsDirectional.only(top: smallSize),
                child: const Text(
                  'پروفایل',
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(standardSize),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // String? result = await Get.to(EditProfilePage());
                            // if (result != null) {
                              controller.getUserInfo();
                            // }
                          },
                          child: SizedBox(
                            width: fullWidth / 4.4,
                            height: fullWidth / 4.4,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    width: fullWidth / 4.4,
                                    height: fullWidth / 4.4,
                                    padding: EdgeInsets.all(largeSize),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 2),
                                              color: const Color(0xff10548B)
                                                  .withOpacity(0.04),
                                              blurRadius: 5,
                                              blurStyle: BlurStyle.normal,
                                              spreadRadius: 4)
                                        ],
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                standardSize)),
                                    child: Image.asset(
                                      'assets/pic_avatar.png',
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: const Alignment(1.07, 1.07),
                                  child: SvgPicture.asset('assets/ic_edit.svg'),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: largeSize,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.user?.firstName ?? controller.pref.user.firstName} ${controller.user?.lastName ?? controller.pref.user.lastName}',
                              style: theme.textTheme.subtitle1!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: xxSmallSize,
                            ),
                            Text(
                              controller.user?.phoneNumber ??
                                  controller.pref.user.phoneNumber,
                              style: theme.textTheme.caption!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: xxSmallSize,
                            ),
                            GestureDetector(
                              // onTap: () => Get.to(TransactionPage()),
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اعتبار شما: ',
                                      style: theme.textTheme.subtitle2!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      controller.pref.totalWallet != []
                                          ? formatNumber(controller
                                                  .pref.totalWallet[0].price ??
                                              0)
                                          : '0',
                                      style: theme.textTheme.subtitle1!
                                          .copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: xLargeSize),
                    Container(
                      padding: EdgeInsets.all(smallSize),
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
                              BorderRadiusDirectional.circular(xSmallRadius)),
                      child: Column(
                        children: [
                          itemProfile(
                              isFirst: true,
                              name: 'معرفی به دوستان',
                              icon: 'assets/ic_profile-2user.svg',
                              onTap: () {
                                Get.to(InvitePage());
                              }),
                          itemProfile(
                              name: 'درباره زیستینو',
                              icon: 'assets/ic_info-circle.svg',
                              onTap: () {
                                // Get.to(AboutZistinoPage());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: standardSize),
                    Container(
                      padding: EdgeInsets.all(xSmallSize),
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
                              BorderRadiusDirectional.circular(xSmallRadius)),
                      child: itemProfile(
                        name: 'خروج',
                        isFirst: true,
                        icon: 'assets/ic_logout.svg',
                        isExit: true,
                        onTap: () => removeRequestSheet(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget itemProfile(
      {required String name,
      required String icon,
      bool isExit = false,
      bool isFirst = false,
      Color? boxColor,
      VoidCallback? onTap}) {
    return Column(
      children: [
        if (!isFirst) SizedBox(height: smallSize),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: isExit == true
                ? const Color(0xFFE74F55).withOpacity(0.15)
                : theme.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(xxSmallRadius),
            child: Row(
              children: [
                Container(
                  width: fullWidth / 9.3,
                  height: fullWidth / 9.3,
                  padding: EdgeInsets.all(smallSize / 1.2),
                  decoration: BoxDecoration(
                      color: isExit == true
                          ? const Color(0xFFE74F55).withOpacity(0.15)
                          : theme.primaryColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadiusDirectional.circular(xSmallSize)),
                  child: SvgPicture.asset(
                    icon,
                    color: isExit == true
                        ? const Color(0xFFE74F55)
                        : theme.primaryColor,
                  ),
                ),
                SizedBox(
                  width: smallSize,
                ),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.subtitle2,
                  ),
                ),
                SvgPicture.asset(
                  'assets/ic_back.svg',
                  color: Colors.black,
                  height: iconSizeXSmall,
                ),
                SizedBox(
                  width: xSmallSize,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
