import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/base/home_entity.dart';
import '../style/colors.dart';
// import '../style/dimens.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/image_widget.dart';

class BannersWidget extends GetResponsiveView {
  final CarouselController buttonCarouselController = CarouselController();
  final ThemeData theme = Get.theme;
  final currentIndex = 0.obs;
  final  List<ProductSectionEntity> rpm;
  final double? height;

  BannersWidget({
    Key? key,
    this.height,
    required this.rpm,
  }) : super(key: key);

  @override
  Widget desktop() {
    return Obx(
          () => Container(
// color: Colors.blue,
            // width: fullWidth/2,
            width: MediaQuery.of(Get.context!).size.width/1.8,
            // width: 655,
          // height: fullWidth / 4,
          // height: MediaQuery.of(Get.context!).size.width / 4,
              height: MediaQuery.of(Get.context!).size.width / 5,
              // decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
              //   color: Colors.red,

              child: Stack(
        children: [
            CarouselSlider(
              items: rpm
                  .map(
                    (e) => Container(
                      // width: fullWidth,
                      width: MediaQuery.of(Get.context!).size.width,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(18),
                    child: imageWidget(e.productModel?.masterImage ?? '',
                        fit: BoxFit.contain,
                      // width: fullWidth,
                      width: MediaQuery.of(Get.context!).size.width,

                        radius: 0,
                        errorImageColor: Colors.white,
                    ),
                  ),
                ),
              )
                  .toList(),
              carouselController: buttonCarouselController,
              options: CarouselOptions(

                height: height,
                onPageChanged: (index, reason) {
                  currentIndex.value = index;
                },
                pageSnapping: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1,
                initialPage: 0,
              ),
            ),
            // SizedBox(height: 12),
            SizedBox(
              // width: fullWidth / 3.5,
              width: MediaQuery.of(Get.context!).size.width / 3.5,
              // height: MediaQuery.of(Get.context!).size.width / 5,

              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex.value,
                  count: rpm.length,
                  effect: ScrollingDotsEffect(
                    maxVisibleDots: 7,
                    dotColor: AppColors.dividerColor,
                    spacing: 6,
                    activeDotScale: 2,
                    activeDotColor: theme.primaryColor,
                    dotHeight: 8,
                    dotWidth: 8,
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
  Widget phone() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            items: rpm
                .map(
                  (e) => Container(
                    padding: EdgeInsetsDirectional.only(
                      start: 16,
                      end: 16,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: imageWidget(e.productModel?.masterImage ?? '',
                          fit: BoxFit.cover,
                          // height: fullWidth / 4,
                          height: MediaQuery.of(Get.context!).size.width/ 4,
                          radius: 12,
                          // width: fullWidth
                          width:MediaQuery.of(Get.context!).size.width
                      ),
                    ),
                  ),
                )
                .toList(),
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: height,
              onPageChanged: (index, reason) {
                currentIndex.value = index;
              },
              pageSnapping: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 500),
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1,
              initialPage: 0,
            ),
          ),
          SizedBox(height: 12),
          Container(
            margin: EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
            ),
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex.value,
              count: rpm.length,
              effect: ScrollingDotsEffect(
                maxVisibleDots: 7,
                dotColor: AppColors.dividerColor,
                spacing: 6,
                activeDotScale: 2,
                activeDotColor: theme.primaryColor,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget tablet() {
    return Obx(
          () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            items: rpm
                .map(
                  (e) => Container(
                padding: EdgeInsetsDirectional.only(
                  start: 16,
                  end: 16,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: imageWidget(e.productModel?.masterImage ?? '',
                      fit: BoxFit.cover,
                      // height: fullWidth / 4,
                      height: MediaQuery.of(Get.context!).size.width/ 4,
                      radius: 12,
                      // width: fullWidth
                      width:MediaQuery.of(Get.context!).size.width
                  ),
                ),
              ),
            )
                .toList(),
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              height: height,
              onPageChanged: (index, reason) {
                currentIndex.value = index;
              },
              pageSnapping: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 500),
              autoPlay: true,
              enlargeCenterPage: false,
              viewportFraction: 1,
              initialPage: 0,
            ),
          ),
          SizedBox(height: 12),
          Container(
            margin: EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
            ),
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex.value,
              count: rpm.length,
              effect: ScrollingDotsEffect(
                maxVisibleDots: 7,
                dotColor: AppColors.dividerColor,
                spacing: 6,
                activeDotScale: 2,
                activeDotColor: theme.primaryColor,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );

/*
    return Obx(
          () => Container(
// color: Colors.blue,
        // width: fullWidth/2,
        width: MediaQuery.of(Get.context!).size.width/1.8,
        // width: 655,
        // height: fullWidth / 4,
        // height: MediaQuery.of(Get.context!).size.width / 4,
        height: MediaQuery.of(Get.context!).size.width / 5,
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(18),
        //   color: Colors.red,

        child: Stack(
          children: [
            CarouselSlider(
              items: rpm
                  .map(
                    (e) => Container(
                  // width: fullWidth,
                  width: MediaQuery.of(Get.context!).size.width,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(18),
                    child: imageWidget(e.productModel?.masterImage ?? '',
                      fit: BoxFit.contain,
                      // width: fullWidth,
                      width: MediaQuery.of(Get.context!).size.width,

                      radius: 0,
                      errorImageColor: Colors.white,
                    ),
                  ),
                ),
              )
                  .toList(),
              carouselController: buttonCarouselController,
              options: CarouselOptions(

                height: height,
                onPageChanged: (index, reason) {
                  currentIndex.value = index;
                },
                pageSnapping: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                autoPlay: true,
                enlargeCenterPage: false,
                viewportFraction: 1,
                initialPage: 0,
              ),
            ),
            // SizedBox(height: 12),
            SizedBox(
              // width: fullWidth / 3.5,
              // width: MediaQuery.of(Get.context!).size.width / 3.5,
              width: MediaQuery.of(Get.context!).size.width / 3.5,


              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex.value,
                  count: rpm.length,
                  effect: ScrollingDotsEffect(
                    maxVisibleDots: 7,
                    dotColor: AppColors.dividerColor,
                    spacing: 6,
                    activeDotScale: 2,
                    activeDotColor: theme.primaryColor,
                    dotHeight: 8,
                    dotWidth: 8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
*/
  }
}
