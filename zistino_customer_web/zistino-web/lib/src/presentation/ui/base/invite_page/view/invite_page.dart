import 'package:admin_dashboard/src/common/utils/show_result_action.dart';
import 'package:admin_dashboard/src/data/enums/bas/theme/snackbar_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../responsive_layout_base/responsive_layout_base.dart';
import '../controller/invite_controller.dart';

class InvitePage extends GetResponsiveView<InviteController> {
  InvitePage({super.key});

  final ThemeData theme = Get.theme;
  LocalStorageService pref = Get.find<LocalStorageService>();

  @override
  InviteController controller = Get.put(InviteController());

  @override
  Widget desktop() {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("معرفی به دوستان", style: theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: false,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(xxSmallSize),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: xLargeSize),
                  Text(
                      "لینک دعوت زیر را برای دوستانتان بفرستید تا با ثبت نام در زیستینو کد تخفیف 20000 ريالی هدیه بگیرید.",
                      style: theme.textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center),
                  SizedBox(height: standardSize),
                  Container(
                    height: smallSize,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: xxSmallSize),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.circular(xxSmallRadius/2)),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.center,
                          child: Container(
                            child: Text(pref.user.representative,
                                style: theme.textTheme.bodyText2!
                                    .copyWith(color: const Color(0xFF637381))),
                          ),
                        ),
                        PositionedDirectional(
                          start: 0,
                          top: 0,
                          bottom: 0,
                          child: Obx(() {
                            return Container(
                              width: smallSize,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controller.isCopied.value == false && Get.isSnackbarOpen == false) {
                                    controller
                                        .copyToClipboard(pref.user.representative);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: xxSmallSize/1.2),
                                ),
                                child: SvgPicture.asset(
                                    controller.isCopied.value == true
                                        ? 'assets/ic_copy_done.svg'
                                        : 'assets/ic_copy.svg',
                                    height: iconSizeMedium,
                                    color: theme.backgroundColor),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: xxSmallSize/1.7),
                  Container(
                    margin: EdgeInsets.all(xxSmallSize),
                    child: progressButton(
                      isDesktop: true,
                        isProgress: false,
                        isDisable: false,
                        onTap: () async {
                          await Share.share(pref.user.representative);
                        },
                        text: "اشتراک گذاری لینک دعوت"),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 10,
                child: Image.asset("assets/pic_invite.png", scale: 2.7)),
          ],
        ),
      ),
    );
  }

  @override
  Widget phone() {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(standardSize),
        child: progressButton(
            isProgress: false,
            isDisable: false,
            onTap: () async {
              await Share.share(pref.user.representative);
            },
            text: "اشتراک گذاری لینک دعوت"),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backIcon(),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(standardSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/pic_invite.png", scale: 3.5),
            SizedBox(height: standardSize),
            Text("معرفی به دوستان", style: theme.textTheme.headline5),
            SizedBox(height: standardSize),
            Text(
                "لینک دعوت زیر را برای دوستانتان بفرستید تا با ثبت نام در زیستینو کد تخفیف 20000 ريالی هدیه بگیرید.",
                style: theme.textTheme.bodyText1,
                textAlign: TextAlign.center),
            SizedBox(height: xxLargeSize),
            Container(
              height: xxLargeSize,
              width: fullWidth,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: standardSize),
              decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(smallRadius)),
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: mediumSize),
                      child: Text(pref.user.representative,
                          style: theme.textTheme.bodyText2!
                              .copyWith(color: const Color(0xFF637381))),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    child: Obx(() {
                      return Container(
                        width: xxLargeSize,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.isCopied.value == false && Get.isSnackbarOpen == false) {
                              controller
                                  .copyToClipboard(pref.user.representative);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                                EdgeInsets.symmetric(horizontal: xxSmallSize),
                          ),
                          child: SvgPicture.asset(
                              controller.isCopied.value == true
                                  ? 'assets/ic_copy_done.svg'
                                  : 'assets/ic_copy.svg',
                              height: iconSizeSmall,
                              color: theme.backgroundColor),
                          // child: Container(
                          //   padding: EdgeInsets.symmetric(horizontal: xxSmallSize),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(
                          //           xxSmallRadius / 1.5),
                          //       border: Border.all(
                          //           width: 1, color: Colors.black)),
                          //   child: ,
                          // ),
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
    );
  }

  @override
  Widget tablet() {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(standardSize),
        child: progressButton(
            isProgress: false,
            isDisable: false,
            onTap: () async {
              await Share.share(pref.user.representative);
            },
            text: "اشتراک گذاری لینک دعوت"),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: backIcon(),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(standardSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/pic_invite.png", scale: 3.5),
            SizedBox(height: standardSize),
            Text("معرفی به دوستان", style: theme.textTheme.headline5),
            SizedBox(height: standardSize),
            Text(
                "لینک دعوت زیر را برای دوستانتان بفرستید تا با ثبت نام در زیستینو کد تخفیف 20000 ريالی هدیه بگیرید.",
                style: theme.textTheme.bodyText1,
                textAlign: TextAlign.center),
            SizedBox(height: xxLargeSize),
            Container(
              height: xxLargeSize,
              width: fullWidth,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: standardSize),
              decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(smallRadius)),
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: mediumSize),
                      child: Text(pref.user.representative,
                          style: theme.textTheme.bodyText2!
                              .copyWith(color: const Color(0xFF637381))),
                    ),
                  ),
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    child: Obx(() {
                      return Container(
                        width: xxLargeSize,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.isCopied.value == false && Get.isSnackbarOpen == false) {
                              controller
                                  .copyToClipboard(pref.user.representative);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding:
                            EdgeInsets.symmetric(horizontal: xxSmallSize),
                          ),
                          child: SvgPicture.asset(
                              controller.isCopied.value == true
                                  ? 'assets/ic_copy_done.svg'
                                  : 'assets/ic_copy.svg',
                              height: iconSizeSmall,
                              color: theme.backgroundColor),
                          // child: Container(
                          //   padding: EdgeInsets.symmetric(horizontal: xxSmallSize),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(
                          //           xxSmallRadius / 1.5),
                          //       border: Border.all(
                          //           width: 1, color: Colors.black)),
                          //   child: ,
                          // ),
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
    );
  }
}
