import 'package:admin_dashboard/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/animation/ButtonAnimation.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../controller/introduction_controller.dart';

class IntroductionPage extends GetResponsiveView<IntroductionController> {
  IntroductionPage({Key? key}) : super(key: key);

  @override
  final IntroductionController controller = Get.put(IntroductionController());

  final ThemeData theme = Get.theme;

  @override
  Widget phone() {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: theme.backgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: theme.backgroundColor,
              statusBarIconBrightness: Brightness.dark),
        ),
        body: Obx(() => Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, -0.95),
              child: Image.asset("assets/pic_logo_zist.png",
                  color: theme.primaryColor, scale: 5),
            ),
            Positioned.fill(
              child: CarouselSlider(
                items: controller.introData
                    .map((e) => Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(xxLargeSize),
                        child: SvgPicture.asset(
                          e.image,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.55),
                      child: Text(e.text,
                          style: theme.textTheme.headline5
                              ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor)),
                    ),
                  ],
                ))
                    .toList(),
                carouselController: controller.buttonCarouselController,
                options: CarouselOptions(
                  height: fullHeight,
                  onPageChanged: (index, reason) {
                    controller.currentIndex.value = index;
                  },
                  pageSnapping: true,
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  initialPage: 0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: xLargeSize,
                    left: xLargeSize,
                    right: xLargeSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSmoothIndicator(
                        activeIndex: controller.currentIndex.value,
                        count: controller.introData.length,
                        effect: ExpandingDotsEffect(
                            dotColor: AppColors.borderColor,
                            spacing: xxSmallSize,
                            activeDotColor: theme.primaryColor,
                            dotHeight: 8,
                            dotWidth: 8),
                        textDirection: TextDirection.rtl),
                    AnimationButtonSpring(
                      AnimationButtonType.onlyScale,
                      Container(
                          width: xxLargeSize,
                          height: xxLargeSize,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // gradient: AppColors.primaryGradientColor,
                              boxShadow: [
                                BoxShadow(
                                    color: theme.primaryColor
                                        .withOpacity(0.20),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                    spreadRadius: 4)
                              ],
                              borderRadius:
                              BorderRadius.circular(standardSize),
                              color: theme.primaryColor,
                              shape: BoxShape.rectangle),
                          child: SvgPicture.asset(
                              'assets/ic_arrow_left.svg',
                              color: Colors.white)),
                      duration: 2000,
                      scaleCoefficient: 0.95,
                      onTap: () {
                        controller.buttonCarouselController.nextPage();
                        controller.currentIndex.value != 2
                            ? controller.currentIndex + 1
                            : Get.toNamed(Routes.authenticationPage);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }

  @override
  Widget tablet() {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: theme.backgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: theme.backgroundColor,
              statusBarIconBrightness: Brightness.dark),
        ),
        body: Obx(() => Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, -0.8),
              child: Image.asset("assets/pic_logo_zist.png",
                  color: theme.primaryColor, scale: 4),
            ),
            Positioned.fill(
              child: CarouselSlider(
                items: controller.introData
                    .map((e) => Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(xLargeSize),
                        child: SvgPicture.asset(
                          e.image,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, 0.55),
                      child: Text(e.text,
                          style: theme.textTheme.headline5
                              ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor)),
                    ),
                  ],
                ))
                    .toList(),
                carouselController: controller.buttonCarouselController,
                options: CarouselOptions(
                  height: fullHeight,
                  onPageChanged: (index, reason) {
                    controller.currentIndex.value = index;
                  },
                  pageSnapping: true,
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  initialPage: 0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: xLargeSize,
                    left: xLargeSize,
                    right: xLargeSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSmoothIndicator(
                        activeIndex: controller.currentIndex.value,
                        count: controller.introData.length,
                        effect: ExpandingDotsEffect(
                            dotColor: AppColors.borderColor,
                            spacing: xxSmallSize,
                            activeDotColor: theme.primaryColor,
                            dotHeight: 8,
                            dotWidth: 8),
                        textDirection: TextDirection.rtl),
                    AnimationButtonSpring(
                      AnimationButtonType.onlyScale,
                      Container(
                          width: xxLargeSize,
                          height: xxLargeSize,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // gradient: AppColors.primaryGradientColor,
                              boxShadow: [
                                BoxShadow(
                                    color: theme.primaryColor
                                        .withOpacity(0.20),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                    spreadRadius: 4)
                              ],
                              borderRadius:
                              BorderRadius.circular(standardSize),
                              color: theme.primaryColor,
                              shape: BoxShape.rectangle),
                          child: SvgPicture.asset(
                              'assets/ic_arrow_left.svg',
                              color: Colors.white)),
                      duration: 2000,
                      scaleCoefficient: 0.95,
                      onTap: () {
                        controller.buttonCarouselController.nextPage();
                        controller.currentIndex.value != 2
                            ? controller.currentIndex + 1
                            : Get.toNamed(Routes.authenticationPage);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }

  @override
  Widget desktop() {
    return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: theme.backgroundColor,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: theme.backgroundColor,
              statusBarIconBrightness: Brightness.dark),
        ),
        body: Obx(() => Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, -1),
              child: Image.asset("assets/pic_logo_zist.png",
                  color: theme.primaryColor, scale: 5),
            ),
            Positioned.fill(
              top: largeSize,
              child: CarouselSlider(
                items: controller.introData
                    .map((e) => Stack(
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-0.7, 0.0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: largeSize/1.5,
                          bottom: largeSize,
                          // start: largeSize,
                          // end: largeSize,
                        ),
                        child: SvgPicture.asset(
                          e.image,
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.7, 0.0),
                      child: Text(e.text,
                          style: theme.textTheme.headline5
                              ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.primaryColor)),
                    ),
                  ],
                ))
                    .toList(),
                carouselController: controller.buttonCarouselController,
                options: CarouselOptions(
                  height: fullHeight,
                  onPageChanged: (index, reason) {
                    controller.currentIndex.value = index;
                  },
                  pageSnapping: true,
                  autoPlayAnimationDuration: const Duration(seconds: 3),
                  autoPlay: false,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  initialPage: 0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: xSmallSize/1.2,
                    left: xLargeSize,
                    right: xLargeSize),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedSmoothIndicator(
                        activeIndex: controller.currentIndex.value,
                        count: controller.introData.length,
                        effect: ExpandingDotsEffect(
                            dotColor: AppColors.borderColor,
                            spacing: xxSmallSize/1.5,
                            activeDotColor: theme.primaryColor,
                            dotHeight: xSmallSize/2,
                            dotWidth: xSmallSize/2),
                        textDirection: TextDirection.rtl),
                    AnimationButtonSpring(
                      AnimationButtonType.onlyScale,
                      Container(
                          width: largeSize/1.3,
                          height: largeSize/1.3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // gradient: AppColors.primaryGradientColor,
                              boxShadow: [
                                BoxShadow(
                                    color: theme.primaryColor
                                        .withOpacity(0.20),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                    spreadRadius: 4)
                              ],
                              borderRadius:
                              BorderRadius.circular(xxSmallRadius),
                              color: theme.primaryColor,
                              shape: BoxShape.rectangle),
                          child: SvgPicture.asset(
                            'assets/ic_arrow_left.svg',
                            color: Colors.white,
                            height: 8,
                            width: 8,
                          )),
                      duration: 2000,
                      scaleCoefficient: 0.95,
                      onTap: () {
                        controller.buttonCarouselController.nextPage();
                        controller.currentIndex.value != 2
                            ? controller.currentIndex + 1
                            : Get.toNamed(Routes.authenticationPage);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        )));
  }

}
