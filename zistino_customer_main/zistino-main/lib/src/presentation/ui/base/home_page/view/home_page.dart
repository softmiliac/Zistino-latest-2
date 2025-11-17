import 'package:zistino/src/domain/entities/inv/driver_delivery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/banners_widget.dart';
import '../../../sec/transaction/view/transaction_page.dart';
import '../../main_page/controller/main_controller.dart';
import '../controller/home_controller.dart';
import '../widgets/product_widget_horizental_home.dart';
import '../widgets/requests_widget.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final ThemeData theme = Get.theme;
  final MainPageController mainPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    // debugPrint('${controller.pref.zones[1].id} iddd');
    controller.getUserWallet();
    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) {
          controller.fetchDataRequests();
          controller.fetchLoadingRequests();
          controller.fetchHome();
        },
        builder: (_) {
          return Scaffold(
              backgroundColor: AppColors.homeBackgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.3,
                toolbarHeight: fullWidth / 5.5,
                shadowColor: AppColors.shadowColor,
                centerTitle: false,
                title: Row(
                  children: [
                    Container(
                      height: fullHeight / 20,
                      width: fullHeight / 20,
                      padding: EdgeInsets.all(xSmallSize / 1.5),
                      margin: EdgeInsetsDirectional.only(end: xSmallSize),
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                spreadRadius: 0.5,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ]),
                      child: Image.asset('assets/pic_white_logo.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('سلام دوست عزیز',
                            style: theme.textTheme.subtitle1
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text('خوش آمدید به زیستـینــو',
                            style: theme.textTheme.caption?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.captionTextColor)),
                      ],
                    ),
                  ],
                ),
                backgroundColor: theme.backgroundColor,
              ),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: RefreshIndicator(
                        edgeOffset: -largeSize,
                        color: theme.primaryColor,
                        onRefresh: () => controller.refreshData(),
                        child: Obx(() {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: largeSize),
                                controller.isBusyGetProductSec.value
                                    ? Column(
                                        children: [
                                          Shimmer.fromColors(
                                            baseColor: theme.backgroundColor,
                                            highlightColor: AppColors
                                                .borderColor
                                                .withOpacity(0.5),
                                            child: Container(
                                                height: fullHeight / 4.05,
                                                width: fullWidth,
                                                decoration: BoxDecoration(
                                                  color: theme.cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          standardRadius),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: standardSize)),
                                          ),
                                          Shimmer.fromColors(
                                            baseColor: theme.backgroundColor,
                                            highlightColor: AppColors
                                                .borderColor
                                                .withOpacity(0.5),
                                            child: Container(
                                                height: smallSize,
                                                width: fullWidth / 8,
                                                decoration: BoxDecoration(
                                                  color: theme.cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          smallRadius),
                                                ),
                                                margin: EdgeInsets.only(
                                                    top: standardSize / 1.2)),
                                          )
                                        ],
                                      )
                                    : controller.homeEntity.isNotEmpty
                                        ? BannersWidget(
                                            rpm: controller.homeEntity[0])
                                        : const SizedBox(),
                                if (controller
                                        .loadingRequestData?.data.isNotEmpty ??
                                    false)
                                  SizedBox(height: largeSize),
                                if (controller.isBusyGetProductSec.isFalse)
                                  if (controller.loadingRequestData?.data
                                          .isNotEmpty ??
                                      false)
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: standardSize),
                                      child: Text(
                                        "در انتظار تائید شما",
                                        style: theme.textTheme.headline6
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                if (controller.isBusyGetProductSec.isFalse)
                                  if (controller.loadingRequestData?.data
                                          .isNotEmpty ??
                                      false)
                                    SizedBox(
                                      width: fullWidth,
                                      child: controller
                                              .isBusyGetLoadingRequests.value
                                          ? const CupertinoActivityIndicator()
                                          : ListView.builder(
                                              itemCount: controller
                                                      .loadingRequestData
                                                      ?.data
                                                      .length ??
                                                  0,
                                              shrinkWrap: true,
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                start: standardSize,
                                                end: standardSize,
                                              ),
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return loadingRequestWidget(
                                                    controller
                                                            .loadingRequestData
                                                            ?.data[index] ??
                                                        DriverDeliveryEntity(
                                                            addressId: 0));
                                              }),
                                    ),
                                if (controller.homeEntity.isNotEmpty)
                                  SizedBox(height: largeSize),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: standardSize),
                                  child: Text(
                                    "خدمات زیستینــو",
                                    style: theme.textTheme.headline6
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: standardSize),
                                // mainPageController.tutorialCoachMark.isShowing ?
                                // Align(
                                //   alignment: const Alignment(0.0, -1.2),
                                //   child: SizedBox(
                                //     height: 0,
                                //     width: 0,
                                //     key: mainPageController.tutorial,
                                //   ),
                                // ) :
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: standardSize),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              // mainPageController.isBuy == false ?
                                              // GestureDetector(
                                              //   key:mainPageController.buy ,
                                              //
                                              //   child: Container(
                                              //       padding: EdgeInsets.symmetric(
                                              //           horizontal: standardSize,
                                              //           vertical: largeSize),
                                              //       decoration: BoxDecoration(
                                              //           color:
                                              //           theme.backgroundColor,
                                              //           borderRadius:
                                              //           BorderRadius.circular(
                                              //               standardRadius),
                                              //           boxShadow: const [
                                              //             BoxShadow(
                                              //                 color:
                                              //                 Colors.black12,
                                              //                 spreadRadius: -4,
                                              //                 blurRadius: 10,
                                              //                 offset:
                                              //                 Offset(0, 3))
                                              //           ]),
                                              //       child: Row(
                                              //           mainAxisAlignment:
                                              //           MainAxisAlignment
                                              //               .spaceBetween,
                                              //           children: [
                                              //             Expanded(
                                              //               child: Text(
                                              //                 "sadasdasdasd",
                                              //                 style: theme
                                              //                     .textTheme
                                              //                     .subtitle1
                                              //                     ?.copyWith(
                                              //                     fontWeight:
                                              //                     FontWeight
                                              //                         .bold),
                                              //               ),
                                              //             ),
                                              //             SizedBox(
                                              //                 height:
                                              //                 xxSmallSize),
                                              //             Container(
                                              //               height: xxLargeSize,
                                              //               width: xxLargeSize,
                                              //               padding: EdgeInsets
                                              //                   .symmetric(
                                              //                   horizontal:
                                              //                   smallSize /
                                              //                       1.2,
                                              //                   vertical:
                                              //                   smallSize /
                                              //                       1.2),
                                              //               decoration: BoxDecoration(
                                              //                   shape: BoxShape
                                              //                       .circle,
                                              //                   color: Colors.blue
                                              //                       .withOpacity(
                                              //                       0.2),
                                              //                   border: Border.all(
                                              //                       width: 1.5,
                                              //                       color: Colors
                                              //                           .blue
                                              //                           .shade700)),
                                              //               child: ClipRRect(
                                              //                 borderRadius:
                                              //                 BorderRadius
                                              //                     .circular(
                                              //                     xSmallRadius),
                                              //                 child: SvgPicture.asset(
                                              //                     'assets/ic_shop.svg',
                                              //                     fit: BoxFit
                                              //                         .contain),
                                              //               ),
                                              //             ),
                                              //           ])),
                                              // )
                                              // // Align(
                                              // //   alignment: const Alignment(0.81, 0.08),
                                              // //   child: SizedBox(
                                              // //     height: fullHeight / 8.7,
                                              // //     width: fullWidth / 2.5,
                                              // //     key: mainPageController.buy,
                                              // //   ),
                                              // // )
                                              //     :
                                              GestureDetector(
                                                key: mainPageController.buy,
                                                onTap: () => mainPageController
                                                    .selectedIndex.value = 1,
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                standardSize,
                                                            vertical:
                                                                largeSize),
                                                    decoration: BoxDecoration(
                                                        color: theme
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                standardRadius),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: -4,
                                                              blurRadius: 10,
                                                              offset:
                                                                  Offset(0, 3))
                                                        ]),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "خریـد",
                                                              style: theme
                                                                  .textTheme
                                                                  .subtitle1
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  xxSmallSize),
                                                          Container(
                                                            height: xxLargeSize,
                                                            width: xxLargeSize,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        smallSize /
                                                                            1.2,
                                                                    vertical:
                                                                        smallSize /
                                                                            1.2),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .blue
                                                                    .withOpacity(
                                                                        0.2),
                                                                border: Border.all(
                                                                    width: 1.5,
                                                                    color: Colors
                                                                        .blue
                                                                        .shade700)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          xSmallRadius),
                                                              child: SvgPicture.asset(
                                                                  'assets/ic_shop.svg',
                                                                  fit: BoxFit
                                                                      .contain),
                                                            ),
                                                          ),
                                                        ])),
                                              ),

                                              SizedBox(height: smallSize),
                                              GestureDetector(
                                                key: mainPageController.residue,
                                                onTap: () => Get.toNamed(
                                                  Routes.residuePricePage,
                                                  // transition:
                                                  //     Transition.rightToLeft
                                                ),
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                standardSize,
                                                            vertical:
                                                                largeSize),
                                                    decoration: BoxDecoration(
                                                        color: theme
                                                            .backgroundColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                standardRadius),
                                                        boxShadow: const [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black12,
                                                              spreadRadius: -4,
                                                              blurRadius: 10,
                                                              offset:
                                                                  Offset(0, 3))
                                                        ]),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "استعـلام",
                                                              style: theme
                                                                  .textTheme
                                                                  .subtitle1
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  xxSmallSize),
                                                          Container(
                                                            height: xxLargeSize,
                                                            width: xxLargeSize,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        smallSize /
                                                                            1.2,
                                                                    vertical:
                                                                        smallSize /
                                                                            1.2),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.2),
                                                                border: Border.all(
                                                                    width: 1.5,
                                                                    color: theme
                                                                        .primaryColor)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          xSmallRadius),
                                                              child: SvgPicture.asset(
                                                                  'assets/ic_recycle.svg',
                                                                  color: theme
                                                                      .primaryColor,
                                                                  fit: BoxFit
                                                                      .contain),
                                                            ),
                                                          ),
                                                        ])),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: smallSize),
                                        Expanded(
                                          key: mainPageController.wallet,
                                          flex: 1,
                                          child: Obx(() {
                                            return GestureDetector(
                                              onTap: () =>
                                                  Get.to(TransactionPage()),
                                              child: Container(
                                                  height: fullHeight / 3.8,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: standardSize,
                                                      vertical: largeSize),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          theme.backgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              standardRadius),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            spreadRadius: -4,
                                                            blurRadius: 10,
                                                            offset:
                                                                Offset(0, 3))
                                                      ]),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          height: xxLargeSize,
                                                          width: xxLargeSize,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      smallSize /
                                                                          1.2,
                                                                  vertical:
                                                                      smallSize /
                                                                          1.2),
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: const Color(
                                                                      0xFFFFC107)
                                                                  .withOpacity(
                                                                      0.2),
                                                              border: Border.all(
                                                                  width: 1.5,
                                                                  color: const Color(
                                                                      0xFFFFC107))),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        xSmallRadius),
                                                            child: SvgPicture.asset(
                                                                'assets/ic_coin_wallet.svg',
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height:
                                                                xxSmallSize),
                                                        Text(
                                                          "کیــف پـول",
                                                          style: theme.textTheme
                                                              .subtitle1
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        AnimatedSize(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      80),
                                                          child: controller
                                                                  .isBusyGetWallet
                                                                  .value
                                                              ? Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.only(
                                                                            bottom:
                                                                                xSmallSize),
                                                                        child: const CupertinoActivityIndicator(
                                                                            color:
                                                                                AppColors.captionTextColor)),
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          bottom:
                                                                              xxSmallSize),
                                                                      child:
                                                                          Text(
                                                                        ' ریال',
                                                                        style: theme
                                                                            .textTheme
                                                                            .caption
                                                                            ?.copyWith(
                                                                                fontWeight: FontWeight.bold,
                                                                                color: AppColors.captionTextColor),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              : RichText(
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  text: TextSpan(
                                                                      children: [
                                                                        TextSpan(
                                                                          text: formatNumber(controller.pref.totalWallet?[0].price ??
                                                                              0),
                                                                          style: theme
                                                                              .textTheme
                                                                              .headline6
                                                                              ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.captionTextColor),
                                                                        ),
                                                                        TextSpan(
                                                                          text:
                                                                              ' ریال',
                                                                          style: theme
                                                                              .textTheme
                                                                              .caption
                                                                              ?.copyWith(fontWeight: FontWeight.bold, color: AppColors.captionTextColor),
                                                                        ),
                                                                      ]),
                                                                ),
                                                        ),
                                                      ])),
                                            );
                                          }),
                                        ),
                                      ],
                                    )),
                                SizedBox(height: largeSize),
                                controller.homeEntity.length > 1
                                    ? AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: controller
                                                .isBusyGetProductSec.value
                                            ? Shimmer.fromColors(
                                                baseColor:
                                                    theme.backgroundColor,
                                                highlightColor: AppColors
                                                    .borderColor
                                                    .withOpacity(0.5),
                                                child: Container(
                                                  // height: largeSize/1.3,
                                                  // width: fullWidth/4.3,
                                                  // decoration: BoxDecoration(
                                                  //   color: theme.cardColor,
                                                  //   borderRadius:
                                                  //   BorderRadius.circular(
                                                  //       xxSmallRadius),
                                                  // ),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: standardSize),
                                                  child: Text(
                                                    "محصـولات",
                                                    style: theme
                                                        .textTheme.headline6
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ),
                                              )
                                            : controller.homeEntity.isNotEmpty
                                                ? Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                standardSize),
                                                    child: Text(
                                                      "محصـولات",
                                                      style: theme
                                                          .textTheme.headline6
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                      )
                                    : const SizedBox(),
                                SizedBox(height: standardSize),
                                // if (controller.homeEntity!.isNotEmpty)
                                controller.isBusyGetProductSec.value
                                    ? SizedBox(
                                        height: fullWidth / 1.5,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 2,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: smallSize),
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return Shimmer.fromColors(
                                                baseColor:
                                                    theme.backgroundColor,
                                                highlightColor: AppColors
                                                    .borderColor
                                                    .withOpacity(0.5),
                                                child: Container(
                                                    height: largeSize / 1.3,
                                                    width: fullWidth / 2.3,
                                                    decoration: BoxDecoration(
                                                      color: theme.cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              standardRadius),
                                                    ),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                xSmallSize)),
                                              );
                                            }),
                                      )
                                    : controller.homeEntity.length > 1
                                        ? SizedBox(
                                            height: fullWidth / 1.5,
                                            child: ListView.builder(
                                                itemCount: controller
                                                    .homeEntity.length,
                                                //todo fix bug in list horizontal
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  debugPrint(
                                                      '${controller.homeEntity.length} leeeqwe');
                                                  return homeWidgetSelector(
                                                      context,
                                                      controller
                                                          .homeEntity[index]);
                                                }),
                                          )
                                        : const SizedBox(),
                                SizedBox(height: xSmallSize),
                                if (controller.deliveryData?.data.isNotEmpty ??
                                    false)
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: standardSize),
                                    child: Text(
                                      "درخواست ها",
                                      style: theme.textTheme.headline6
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                SizedBox(
                                  width: fullWidth,
                                  child: controller.isBusyGetRequests.value
                                      ? Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: xLargeSize),
                                          child:
                                              const CupertinoActivityIndicator())
                                      : ListView.builder(
                                          itemCount: controller
                                                  .deliveryData?.data.length ??
                                              0,
                                          shrinkWrap: true,
                                          padding: EdgeInsetsDirectional.only(
                                            start: standardSize,
                                            end: standardSize,
                                          ),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return requestWidget(
                                                controller.deliveryData
                                                        ?.data[index] ??
                                                    DriverDeliveryEntity(
                                                        addressId: 0),
                                                index);
                                          }),
                                ),
                                const SizedBox(
                                    height: kBottomNavigationBarHeight * 2),
                              ],
                            ),
                          );
                        })),
                  ),
                  Align(
                    alignment: const Alignment(0.0, -1.5),
                    child: SizedBox(
                      height: 0,
                      width: 0,
                      key: mainPageController.tutorial,
                    ),
                  ),
                ],
              ));
        });
  }

  Widget homeWidgetSelector(
      BuildContext context, List<ProductSectionEntity> sections) {
    switch (sections[0].setting.type) {
      case ProductSectionType.scrollable:
        return const SizedBox();

      case ProductSectionType.horizontal:
        return productListHome(sections);

      case ProductSectionType.offer:
        return Container();
      case ProductSectionType.vertical:
        return const SizedBox();
      case ProductSectionType.category:
        return const SizedBox();

      case ProductSectionType.banner:
        return const SizedBox();
      // sections.length != 1
      //   ?
      //     BannersWidget(
      //   rpm: sections,
      //   height: fullWidth / 2,
      // );
      // : bannerWidget(
      // image: sections[0].imagePath,
      // id: sections[0].productId,
      // link: sections[0].linkUrl,
      // name: sections[0].name);
    }
  }
}
