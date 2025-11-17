import 'package:admin_dashboard/src/common/utils/number_format.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../controller/residue_price_controller.dart';

class ResiduePricePage
    extends GetResponsiveView<ResiduePriceController> {
  ResiduePricePage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
  final CarouselController buttonCarouselController = CarouselController();
  RxInt categoryIndex = 0.obs;

  RxDouble height = (
      // MediaQuery.of(Get.context!).size.height / 6
      MediaQuery.of(Get.context!).size.height/ 6
  ).obs;
  RxDouble width = (
      // MediaQuery.of(Get.context!).size.height / 7
      MediaQuery.of(Get.context!).size.height/ 7
  ).obs;



  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     // init: controller,
    //     // initState: (state) {
    //     //   controller.fetchCategory();
    //     //   controller.fetchResidue();
    //     //   controller.currentIndex.value = 0;
    //     // },
    //     // builder: (_) {
          return
            Directionality(
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
                  leading: backIcon(),
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
                                margin: EdgeInsets.only(top: a/33),
                                child: CarouselSlider(
                                  items: controller.result
                                      ?.map((e) =>
                                      Container(
                                        width: a/6,
                                        height: a/6,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: a/47,
                                            vertical: a/33),
                                        margin: EdgeInsets.symmetric(
                                          // vertical: a/40,
                                          horizontal: a/47 / 1.4,
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
                                            // borderRadius:
                                            // BorderRadius.circular(
                                            //     a/24),
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
                                      ))
                                      .toList(),
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(

                                    height: MediaQuery.of(Get.context!).size.height / 4,
                                    onPageChanged: (index, reason) {
                                      controller.currentIndex.value = index;
                                      controller.changeItem();
                                    },
                                    aspectRatio: 16/9,
                                    disableCenter: false,
                                    pageSnapping: true,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.2,
                                    initialPage: controller.currentIndex.value,
                                  ),
                                )),
                            // SizedBox(height: a/40),
                            Container(
                              width: a/2,
                              // height: a/6,

                              margin: EdgeInsets.symmetric(
                                vertical:a/24 ,
                                  horizontal: a/24),
                              padding: EdgeInsets.symmetric(
                                  horizontal: a/33, vertical: a/33),
                              decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius:
                                  BorderRadius.circular(a/24),
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
                                    width: a/2,
                                    // height: 30,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: a/60,
                                        vertical: a/200
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF7FF),
                                      borderRadius:
                                      BorderRadius.circular(a/24),
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
                                            SizedBox(width: a/33),
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
                  onLoading: loadingWidget(height: MediaQuery.of(Get.context!).size.height / 1.5),
                  onEmpty: emptyWidget(
                      'اطلاعاتی وجود ندارد', height: MediaQuery.of(Get.context!).size.height / 1.5),
                  onError: (error) =>
                      errorWidget(error.toString(), onTap: () {
                        controller.fetchCategory();
                        controller.fetchResidue();
                      }, height: MediaQuery.of(Get.context!).size.height / 1.5),
                )),
          );
        // });
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchCategory();
    //       controller.fetchResidue();
    //       controller.currentIndex.value = 0;
    //     },
    //     builder: (_) {
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
                                margin: EdgeInsets.only(top: a/33),
                                child: CarouselSlider(
                                  items: controller.result
                                      ?.map((e) =>
                                      Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: a/47,
                                              vertical: a/33),
                                          margin: EdgeInsets.symmetric(
                                            vertical: a/24,
                                            horizontal: a/47 / 1.4,
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
                                                  a/24),
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
                                      ))
                                      .toList(),
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(
                                    height: MediaQuery.of(Get.context!).size.height / 4.9,
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
                            SizedBox(height: a/16),
                            Container(
                              width: a,
                              margin: EdgeInsets.symmetric(
                                  horizontal: a/24),
                              padding: EdgeInsets.symmetric(
                                  horizontal: a/33, vertical: a/33),
                              decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius:
                                  BorderRadius.circular(a/24),
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
                                    width: a,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: a/16 / 1.2,
                                        vertical: a/33),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF7FF),
                                      borderRadius:
                                      BorderRadius.circular(a/24),
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
                                            SizedBox(width: a/33),
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
                  onLoading: loadingWidget(height: MediaQuery.of(Get.context!).size.height / 1.5),
                  onEmpty: emptyWidget(
                      'اطلاعاتی وجود ندارد', height: MediaQuery.of(Get.context!).size.height / 1.5),
                  onError: (error) =>
                      errorWidget(error.toString(), onTap: () {
                        controller.fetchCategory();
                        controller.fetchResidue();
                      }, height: MediaQuery.of(Get.context!).size.height / 1.5),
                )),
          );
        // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchCategory();
    //       controller.fetchResidue();
    //       controller.currentIndex.value = 0;
    //     },
    //     builder: (_) {
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
                                margin: EdgeInsets.only(top: a/33),
                                child: CarouselSlider(
                                  items: controller.result
                                      ?.map((e) =>
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: a/47,
                                            vertical: a/33),
                                        margin: EdgeInsets.symmetric(
                                          vertical: a/24,
                                          horizontal: a/47 / 1.4,
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
                                                a/24),
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
                                      ))
                                      .toList(),
                                  carouselController: buttonCarouselController,
                                  options: CarouselOptions(
                                    height: MediaQuery.of(Get.context!).size.height / 4.9,
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
                            SizedBox(height: a/16),
                            Container(
                              width: a,
                              margin: EdgeInsets.symmetric(
                                  horizontal: a/24),
                              padding: EdgeInsets.symmetric(
                                  horizontal: a/33, vertical: a/33),
                              decoration: BoxDecoration(
                                  color: theme.backgroundColor,
                                  borderRadius:
                                  BorderRadius.circular(a/24),
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
                                    width: a,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: a/16 / 1.2,
                                        vertical: a/33),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEEF7FF),
                                      borderRadius:
                                      BorderRadius.circular(a/24),
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
                                            SizedBox(width: a/33),
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
                  onLoading: loadingWidget(height: MediaQuery.of(Get.context!).size.height / 1.5),
                  onEmpty: emptyWidget(
                      'اطلاعاتی وجود ندارد', height: MediaQuery.of(Get.context!).size.height / 1.5),
                  onError: (error) =>
                      errorWidget(error.toString(), onTap: () {
                        controller.fetchCategory();
                        controller.fetchResidue();
                      }, height: MediaQuery.of(Get.context!).size.height / 1.5),
                )),
          );
        // });
  }

  Widget _priceList(int index) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    final ResiduePriceController controller = Get.find();
    return Container(
      width: a/2,

      padding: EdgeInsets.symmetric(
          horizontal: a/60,
          vertical: a/200
      ),
      // padding: EdgeInsets.symmetric(
      //     horizontal: a/16 / 1.2, vertical: a/33),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? Colors.white
            : AppColors.captionColor.withOpacity(0.03),
        borderRadius: BorderRadius.circular(a/24),
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
              SizedBox(width: a/33),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      // controller.result?[index].id == controller.productRPM?[index].categories[0].id ? 'salam' : 'khodafez',
                      '${formatNumber(
                          controller.changeItem()[index].masterPrice ??
                              0)} ريال',
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
