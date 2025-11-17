import 'package:zistino/src/common/utils/number_format.dart';
import 'package:zistino/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/image_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../controller/residue_price_controller.dart';

class ResiduePricePage
    extends ResponsiveLayoutBaseGetView<ResiduePriceController> {
  ResiduePricePage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
  final CarouselController buttonCarouselController = CarouselController();
  RxInt categoryIndex = 0.obs;

  RxDouble height = (fullHeight / 6).obs;
  RxDouble width = (fullHeight / 7).obs;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(context);
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
  }

  @override
  Widget mobile(BuildContext context) {
    return GetBuilder(
        init: controller,
        initState: (state) {
          controller.currentIndex.value = 0;
          controller.fetchCategory();
          controller.fetchResidue();
        },
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.shadowColor.withOpacity(0.2),
                  elevation: 15,
                  title: Text('استعـلام',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  leading: backIcon(iconColor: Colors.black),
                  backgroundColor: theme.backgroundColor,
                ),
                body: controller.obx(
                      (state) {
                    return Obx(() {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: smallSize),
                                child: CarouselSlider(
                                  items: controller.result
                                      ?.map((e) =>
                                      GestureDetector(
                                        onTap: () {

                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: xSmallSize,
                                                vertical: smallSize),
                                            margin: EdgeInsets.symmetric(
                                              vertical: standardSize,
                                              horizontal: xSmallSize / 1.4,
                                            ),
                                            decoration: BoxDecoration(
                                                color: theme.backgroundColor,
                                                border: Border.all(
                                                    color: e.id ==
                                                        controller
                                                            .result?[controller
                                                            .currentIndex
                                                            .value]
                                                            .id
                                                        ? theme.primaryColor
                                                        : Colors.transparent,
                                                    width: 1),
                                                borderRadius:
                                                BorderRadius.circular(
                                                    mediumRadius),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: 0,
                                                      blurRadius: 12,
                                                      offset: Offset(0, 2))
                                                ]),
                                            child:
                                            Text(
                                              e.name,
                                            ),
                                          // imageWidget(e.imagePath,
                                          //     fit: BoxFit.contain)
                                        ),
                                      ))
                                      .toList(),
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(
                                    height: fullHeight / 4.9,
                                    onPageChanged: (index, reason) {
                                      controller.currentIndex.value = index;
                                      controller.changeItem();
                                    },
                                    aspectRatio: 1 / 1,
                                    disableCenter: false,
                                    pageSnapping: true,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.4,
                                    initialPage: controller.currentIndex.value,
                                  ),
                                )),
                            SizedBox(height: largeSize),
                            Container(
                              width: fullWidth,
                              margin: EdgeInsets.symmetric(
                                  horizontal: standardSize),
                              padding: EdgeInsets.symmetric(
                                  horizontal: smallSize, vertical: smallSize),
                              decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius:
                                  BorderRadius.circular(mediumRadius),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: -3,
                                        blurRadius: 12,
                                        offset: Offset(0, 5))
                                  ]),
                              child: Column(
                                children: [
                                  Container(
                                    width: fullWidth,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: largeSize / 1.2,
                                        vertical: smallSize),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF7FF),
                                      borderRadius:
                                      BorderRadius.circular(mediumRadius),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "حجم",
                                                    style: theme
                                                        .textTheme.bodyText2
                                                        ?.copyWith(
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: smallSize),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                      text: TextSpan(children: [
                                                        TextSpan(
                                                          text: "قیمت",
                                                          style: theme
                                                              .textTheme
                                                              .bodyText2
                                                              ?.copyWith(
                                                              letterSpacing:
                                                              0.5,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              color:
                                                              Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text: "(هر کیلوگرم)",
                                                          style: theme
                                                              .textTheme
                                                              .bodyText2
                                                              ?.copyWith(
                                                              letterSpacing:
                                                              0.5,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              color: AppColors
                                                                  .captionColor),
                                                        )
                                                      ]))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ListView.builder(
                                      physics:
                                      const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: controller
                                          .changeItem()
                                          .length
                                      // data == true ?
                                      //     controller.productRPM?.length : 0
                                      ,
                                      itemBuilder: (context, index) =>
                                          _priceList(index))
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    });
                  },
                  onLoading: loadingWidget(height: fullHeight / 1.5),
                  onEmpty: emptyWidget(
                      'اطلاعاتی وجود ندارد', height: fullHeight / 1.5),
                  onError: (error) =>
                      errorWidget(error.toString(), onTap: () {
                        controller.fetchCategory();
                        controller.fetchResidue();
                      }, height: fullHeight / 1.5),
                )),
          );
        });
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }

  Widget _priceList(int index) {
    final ResiduePriceController controller = Get.find();
    return Container(
      width: fullWidth,
      padding: EdgeInsets.symmetric(
          horizontal: largeSize / 1.2, vertical: smallSize),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? Colors.white
            : AppColors.captionColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(mediumRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      controller.changeItem()[index].name,
                      style: theme.textTheme.caption?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(width: smallSize),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      // controller.result?[index].id == controller.productRPM?[index].categories[0].id ? 'salam' : 'khodafez',
                      '${formatNumber(
                          controller.changeItem()[index].masterPrice ??
                              0)} ریال',
                      style: theme.textTheme.caption?.copyWith(
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
