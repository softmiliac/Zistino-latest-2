import 'package:admin_dashboard/src/presentation/ui/base/main_page/controller/main_controller.dart';
import 'package:admin_dashboard/src/presentation/ui/base/main_page/view/main_page.dart';
import 'package:admin_dashboard/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../style/animation/slide_transition.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../controller/review_controller.dart';

class ReviewPage extends GetResponsiveView {
  ReviewPage({Key? key, required this.address, required this.driver})
      : super(key: key);

  final ThemeData theme = Get.theme;
  String address = '';
  String driver = '';
  RxDouble rating = 2.5.obs;

  @override
  ReviewController controller = Get.put(ReviewController());
  MainPageController mainPageController = Get.put(MainPageController());



  @override
  Widget phone() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: AppColors.shadowColor.withOpacity(0.2),
        elevation: 15,
        title: Text('بازخورد جمع آوری',
            style: theme.textTheme.subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
          splashRadius: standardSize,
          splashColor: AppColors.splashColor,
          icon: Icon(CupertinoIcons.clear_thick,
              size: iconSizeSmall, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: theme.backgroundColor,
      ),
      body: SizedBox(
        height: fullHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: fullHeight / 9),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "به سفر خود امتیاز دهید",
                            textAlign: TextAlign.start,
                            style: theme.textTheme.subtitle1
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: RatingBar.builder(
                          itemCount: 5,
                          unratedColor: theme.primaryColor.withOpacity(0.25),
                          allowHalfRating: true,
                          glowColor: theme.dividerColor,
                          itemPadding: EdgeInsets.symmetric(horizontal: xxSmallSize),
                          initialRating: rating.value,
                          itemBuilder: (context, index) {
                            return Icon(CupertinoIcons.star_fill,
                                color: theme.primaryColor);
                          },
                          onRatingUpdate: (double value) {
                            rating.value = value;
                          },
                        ),
                      ),
                      SizedBox(height: xxLargeSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Text(
                          "به $address",
                          textAlign: TextAlign.start,
                          style: theme.textTheme.subtitle2
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                              start: standardSize, end: standardSize),
                          child: Text(
                            "توسط $driver",
                            // "توسط کامران ایزدی",
                            style: theme.textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.captionColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: standardSize / 1.3),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: standardSize, end: standardSize),
                            child: Container(
                              width: fullWidth / 7.5,
                              height: fullWidth / 7.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: AppColors.dividerColor)),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/profile_avatar.png',
                                ),
                              ),
                            )),
                      ),
                    ]),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.85),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: SlideFadeTransition(
                  delayStart: const Duration(milliseconds: 250),
                  animationDuration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Obx(() {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 130),
                      opacity: rating.value == 0.0 ? 0.5 : 1,
                      child: progressButton(
                          text: 'ثبت بازخورد',
                          isDisable: false,
                          isProgress: false,
                          onTap: () {
                            if (rating.value != 0.0) {
                              Get.back();
                            }
                          }),
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.95),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: SlideFadeTransition(
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                        start: standardSize, end: standardSize),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.eye_slash,
                            size: iconSizeSmall, color: AppColors.captionColor),
                        SizedBox(width: smallSize),
                        Text(
                          // "توسط $driver",
                          "نظرات شما با حفظ حریم شخصیتان ثبت خواهد شد.",
                          style: theme.textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.captionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktop() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: AppColors.shadowColor.withOpacity(0.2),
        elevation: 15,
        title: Text('بازخورد جمع آوری',
            style: theme.textTheme.subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
          splashRadius: standardSize,
          splashColor: AppColors.splashColor,
          icon: Icon(CupertinoIcons.clear_thick,
              size: iconSizeSmall, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: theme.backgroundColor,
      ),
      body: SizedBox(
        height: fullHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: fullHeight / 9),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "به سفر خود امتیاز دهید",
                            textAlign: TextAlign.start,
                            style: theme.textTheme.subtitle1
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: RatingBar.builder(
                          itemCount: 5,
                          unratedColor: theme.primaryColor.withOpacity(0.25),
                          allowHalfRating: true,
                          glowColor: theme.dividerColor,
                          itemPadding: EdgeInsets.symmetric(horizontal: xxSmallSize),
                          initialRating: rating.value,
                          itemBuilder: (context, index) {
                            return Icon(CupertinoIcons.star_fill,
                                color: theme.primaryColor);
                          },
                          onRatingUpdate: (double value) {
                            rating.value = value;
                          },
                        ),
                      ),
                      SizedBox(height: xxLargeSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Text(
                          "به $address",
                          textAlign: TextAlign.start,
                          style: theme.textTheme.subtitle2
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                              start: standardSize, end: standardSize),
                          child: Text(
                            "توسط $driver",
                            // "توسط کامران ایزدی",
                            style: theme.textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.captionColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: standardSize / 1.3),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: standardSize, end: standardSize),
                            child: Container(
                              width: fullWidth / 7.5,
                              height: fullWidth / 7.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: AppColors.dividerColor)),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/profile_avatar.png',
                                ),
                              ),
                            )),
                      ),
                    ]),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.85),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: SlideFadeTransition(
                  delayStart: const Duration(milliseconds: 250),
                  animationDuration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Obx(() {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 130),
                      opacity: rating.value == 0.0 ? 0.5 : 1,
                      child: progressButton(
                          text: 'ثبت بازخورد',
                          isDisable: false,
                          isProgress: false,
                          onTap: () {
                            if (rating.value != 0.0) {
                              Get.back();
                            }
                          }),
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.95),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: SlideFadeTransition(
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                        start: standardSize, end: standardSize),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.eye_slash,
                            size: iconSizeSmall, color: AppColors.captionColor),
                        SizedBox(width: smallSize),
                        Text(
                          // "توسط $driver",
                          "نظرات شما با حفظ حریم شخصیتان ثبت خواهد شد.",
                          style: theme.textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.captionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shadowColor: AppColors.shadowColor.withOpacity(0.2),
        elevation: 15,
        title: Text('بازخورد جمع آوری',
            style: theme.textTheme.subtitle1
                ?.copyWith(fontWeight: FontWeight.bold)),
        leading: IconButton(
          splashRadius: standardSize,
          splashColor: AppColors.splashColor,
          icon: Icon(CupertinoIcons.clear_thick,
              size: iconSizeSmall, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: theme.backgroundColor,
      ),
      body: SizedBox(
        height: fullHeight,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: fullHeight / 9),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "به سفر خود امتیاز دهید",
                            textAlign: TextAlign.start,
                            style: theme.textTheme.subtitle1
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: RatingBar.builder(
                          itemCount: 5,
                          unratedColor: theme.primaryColor.withOpacity(0.25),
                          allowHalfRating: true,
                          glowColor: theme.dividerColor,
                          itemPadding: EdgeInsets.symmetric(horizontal: xxSmallSize),
                          initialRating: rating.value,
                          itemBuilder: (context, index) {
                            return Icon(CupertinoIcons.star_fill,
                                color: theme.primaryColor);
                          },
                          onRatingUpdate: (double value) {
                            rating.value = value;
                          },
                        ),
                      ),
                      SizedBox(height: xxLargeSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Text(
                          "به $address",
                          textAlign: TextAlign.start,
                          style: theme.textTheme.subtitle2
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(
                              start: standardSize, end: standardSize),
                          child: Text(
                            "توسط $driver",
                            // "توسط کامران ایزدی",
                            style: theme.textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.captionColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: standardSize / 1.3),
                      SlideFadeTransition(
                        delayStart: const Duration(milliseconds: 200),
                        animationDuration: const Duration(milliseconds: 1000),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: Container(
                            margin: EdgeInsetsDirectional.only(
                                start: standardSize, end: standardSize),
                            child: Container(
                              width: fullWidth / 7.5,
                              height: fullWidth / 7.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: AppColors.dividerColor)),
                              child: Center(
                                child: Image.asset(
                                  'assets/images/profile_avatar.png',
                                ),
                              ),
                            )),
                      ),
                    ]),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.85),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: SlideFadeTransition(
                  delayStart: const Duration(milliseconds: 250),
                  animationDuration: const Duration(milliseconds: 800),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Obx(() {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 130),
                      opacity: rating.value == 0.0 ? 0.5 : 1,
                      child: progressButton(
                          text: 'ثبت بازخورد',
                          isDisable: false,
                          isProgress: false,
                          onTap: () {
                            if (rating.value != 0.0) {
                              Get.back();
                            }
                          }),
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.95),
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: standardSize, end: standardSize),
                child: SlideFadeTransition(
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                        start: standardSize, end: standardSize),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.eye_slash,
                            size: iconSizeSmall, color: AppColors.captionColor),
                        SizedBox(width: smallSize),
                        Text(
                          // "توسط $driver",
                          "نظرات شما با حفظ حریم شخصیتان ثبت خواهد شد.",
                          style: theme.textTheme.caption!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.captionColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
