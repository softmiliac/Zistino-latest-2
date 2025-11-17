import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/base/home_entity.dart';
import '../style/colors.dart';
import '../style/dimens.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/image_widget.dart';
import '../ui/base/responsive_layout_base/responsive_layout_base.dart';

class BannersWidget extends ResponsiveLayoutBaseGetView {
  final CarouselController buttonCarouselController = CarouselController();
  final ThemeData theme = Get.theme;
  final currentIndex = 0.obs;
  final List<ProductSectionEntity> rpm;
  final double? height;

  BannersWidget({
    Key? key,
    this.height,
    required this.rpm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(context);
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }

  Future<void> _launchUrl(String linkUrl) async {
    final Uri _url = Uri.parse(linkUrl);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget mobile(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider(
            items: rpm.map(
              (e) {
                return GestureDetector(
                  onTap: () => _launchUrl(e.linkUrl),
                  child: Container(
                    padding: EdgeInsetsDirectional.only(
                      start: standardSize,
                      end: standardSize,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(standardRadius),
                      child: imageWidget(e.imagePath,
                          fit: BoxFit.cover,
                          backgroundColor: theme.backgroundColor,
                          height: fullWidth / 4,
                          radius: smallRadius,
                          width: fullWidth),
                    ),
                  ),
                );
              },
            ).toList(),
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
          SizedBox(height: smallSize),
          Container(
            margin: EdgeInsetsDirectional.only(
              start: standardSize,
              end: standardSize,
            ),
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex.value,
              count: rpm.length,
              effect: ScrollingDotsEffect(
                maxVisibleDots: 7,
                dotColor: AppColors.dividerColor,
                spacing: xSmallSize / 1.5,
                activeDotScale: xxSmallSize / 2.8,
                activeDotColor: theme.primaryColor,
                dotHeight: xxSmallSize / 0.6,
                dotWidth: xxSmallSize / 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }
}
