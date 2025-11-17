import 'package:admin_dashboard/src/domain/entities/inv/driver_delivery.dart';
// import 'package:admin_dashboard/src/presentation/style/dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/number_format.dart';
import '../../../../../data/models/base/home_model.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/banners_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../sec/transaction/view/transaction_page.dart';
import '../../main_page/controller/main_controller.dart';
import '../controller/home_controller.dart';
import '../widgets/product_widget_horizental_home.dart';
import '../widgets/requests_widget.dart';

class HomePage extends GetResponsiveView<HomeController> {
  final theme = Get.theme;
  final MainPageController mainPageController = Get.find();

  HomePage({super.key});

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // HomeBinding().dependencies();
    // controller.getUserWallet();
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchData();
    //       controller.fetchHome();
    //     },
    //     builder: (_) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0.3,
                  // toolbarHeight: fullWidth / 5.5,
                  toolbarHeight: 80,
                  shadowColor: AppColors.shadowColor,
                  centerTitle: false,
                  title: Row(
                    children: [
                      Container(
                        // height: fullHeight / 20,
                        height: b / 20,
                        // width: fullHeight / 20,
                        width: b/ 20,
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsetsDirectional.only(end: 8),
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
                body:
                // Obx(() {
                //       return
                controller.obx(
                      (state) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        controller.homeEntity != null
                            ? BannersWidget(rpm: controller.homeEntity![0])
                            : const SizedBox(),
                        const SizedBox(height: 24),
                        Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "خدمات زیستینــو",
                            style: theme.textTheme.headline6
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => mainPageController
                                            .selectedIndex.value = 1,
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 24),
                                            decoration: BoxDecoration(
                                                color: theme.backgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    18),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: -4,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3))
                                                ]),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "خرید",
                                                      style: theme
                                                          .textTheme.subtitle1
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    height: 48,
                                                    width: 48,
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        10),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blue
                                                            .withOpacity(0.2),
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: Colors.blue
                                                                .shade700)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          6),
                                                      child: SvgPicture.asset(
                                                          'assets/ic_shop.svg',
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ])),
                                      ),
                                      const SizedBox(height: 12),
                                      GestureDetector(
                                        onTap: () => Get.toNamed(
                                          Routes.residuePricePage,
                                          // transition:
                                          //     Transition.rightToLeft
                                        ),
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 24),
                                            decoration: BoxDecoration(
                                                color: theme.backgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    18),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: -4,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3))
                                                ]),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "استعلام",style: theme
                                                          .textTheme.subtitle1
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    height: 48,
                                                    width: 48,
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal:
                                                        10,
                                                        vertical:
                                                        10),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: theme
                                                            .primaryColor
                                                            .withOpacity(0.2),
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: theme
                                                                .primaryColor)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          6),
                                                      child: SvgPicture.asset(
                                                          'assets/ic_recycle.svg',
                                                          color: theme
                                                              .primaryColor,
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ])),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: Obx(() {
                                    return GestureDetector(
                                      onTap: () => Get.toNamed(Routes.transactionPage),
                                      child: Container(
                                          // height: fullHeight / 4.05,
                                          height: 205,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 24),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  18),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: -4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3))
                                              ]),
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 48,
                                                  width: 48,
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: const Color(
                                                          0xFFFFC107)
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: const Color(
                                                              0xFFFFC107))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        6),
                                                    child: SvgPicture.asset(
                                                        'assets/ic_coin_wallet.svg',
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "کیــف پـول",
                                                  style: theme
                                                      .textTheme.subtitle1
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                AnimatedSize(
                                                  duration: const Duration(
                                                      milliseconds: 80),
                                                  child:
                                                  controller.isBusyGetWallet
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
                                                          margin: const EdgeInsets.only(
                                                              bottom:
                                                              8),
                                                          child: const CupertinoActivityIndicator(
                                                              color: AppColors
                                                                  .captionTextColor)),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(
                                                            bottom:
                                                            4),
                                                        child: Text(
                                                          ' ريال',
                                                          style: theme
                                                              .textTheme
                                                              .caption
                                                              ?.copyWith(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: AppColors.captionTextColor),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                      : RichText(
                                                    text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: formatNumber(controller
                                                                .pref
                                                                .totalWallet?[0]
                                                                .price ??
                                                                0),
                                                            style: theme
                                                                .textTheme
                                                                .headline6
                                                                ?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.captionTextColor),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                            ' ريال',
                                                            style: theme
                                                                .textTheme
                                                                .caption
                                                                ?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.captionTextColor),
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
                        const SizedBox(height: 24),
                        if (controller.homeEntity?.length != 0)
                          Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "محصـولات",
                              style: theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (controller.homeEntity?.length != 0)
                          const SizedBox(height: 16),
                        // Container(
                        //   height: fullHeight / 3.2,
                        //   child: ListView.builder(
                        //       itemCount: productData().length,
                        //       shrinkWrap: true,
                        //       padding: EdgeInsetsDirectional.only(start: standardSize),
                        //       physics: const BouncingScrollPhysics(),
                        //       scrollDirection: Axis.horizontal,
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             margin:
                        //                 EdgeInsetsDirectional.only(end: standardSize),
                        //             child: productWidget(productData()[index]));
                        //       }),
                        // ),
                        ///
                        if (controller.homeEntity?.length != 0)
                          SizedBox(
                            // height: fullWidth / 1.5,
                            height: 400,
                            child: ListView.builder(
                                itemCount: controller.homeEntity?.length ?? 0,
                                //todo fix bug in list horizontal
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return homeWidgetSelectorPhone(
                                      context,
                                      controller.homeEntity?[index] ??
                                          <ProductSectionModel>[]);
                                }),
                          ),
                        const SizedBox(height: 8),
                        if (controller.deliveryData?.data.isNotEmpty ?? false)
                          Container(
                            margin:
                            const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "درخواست ها",
                              style: theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        SizedBox(
                          // width: fullWidth,
                          child: controller.isBusyGetRequests.value
                              ? Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 32),
                              child: const CupertinoActivityIndicator())
                              : ListView.builder(
                              itemCount:
                              controller.deliveryData?.data.length ?? 0,
                              shrinkWrap: true,
                              padding: const EdgeInsetsDirectional.only(
                                start: 16,
                                end: 16,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return requestWidget(
                                    controller.deliveryData?.data[index] ??
                                        DriverDeliveryEntity(addressId: 0),
                                    index);
                              }),
                          width: a,
                        ),
                        const SizedBox(height: kBottomNavigationBarHeight * 2),
                      ],
                    ),
                  ),
                  onEmpty: emptyWidget('محصولی وجود ندارد'),
                  onError: (error) => errorWidget(error.toString(), onTap: () {
                    controller.fetchData();
                    controller.fetchHome();
                  },
                      // height: fullHeight / 1.5
                      height: b/ 1.5

                  ),
                  onLoading: loadingWidget(
                      // height: fullHeight / 1.5
                      height:b / 1.5
                  ),
                  // ;
                  // }),
                ),
              ));
        // });
  }

  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;

    // HomeBinding().dependencies();
    // controller.getUserWallet();
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchData();
    //       controller.fetchHome();
    //     },
    //     builder: (_) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
          ),
          body: controller.obx(
                (state) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // width: fullWidth / 2.3,
                          width:a / 2.5,
                          // width:640,
                          margin:const EdgeInsetsDirectional.only(end: 20),
                          child: Row(
                            children: [
                              const  SizedBox(width: 0),

                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => mainPageController
                                          .selectedIndex.value = 1,
                                      child: Container(
                                          height: a / 10.6
                                          ,

                                          padding: EdgeInsets.symmetric(
                                              horizontal:   a / 100
                                              , vertical: a / 80),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor, borderRadius:
                                          BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: -4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3))
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
                                                        .textTheme.subtitle1
                                                        ?.copyWith(
                                                      fontSize: a/80,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  height: a / 20,
                                                  width: a / 20,
                                                  padding: EdgeInsetsDirectional.all(a / 100),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: Colors
                                                              .blue.shade700)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(2),
                                                    child: SvgPicture.asset(
                                                        'assets/ic_shop.svg',
                                                        width: a / 20,
                                                        height: a / 20,
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                              ])),
                                    ),
                                      SizedBox(height: a / 100),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(
                                        Routes.residuePricePage,
                                        // transition:
                                        //     Transition.rightToLeft
                                      ),
                                      child: Container(
                                          height: a / 10.6,

                                          padding: EdgeInsets.symmetric(
                                              horizontal:   a / 100
                                              , vertical: a / 80),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: -4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3))
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
                                                        .textTheme.subtitle1
                                                        ?.copyWith(
                                                        fontSize: a/80,

                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  height: a / 20,
                                                  width: a / 20,
                                                  padding:const EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: theme.primaryColor
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: theme
                                                              .primaryColor)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    child: SvgPicture.asset(
                                                        'assets/ic_recycle.svg',
                                                        color:
                                                        theme.primaryColor,
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                              ])),
                                    ),
                                  ],
                                ),
                              ),
                              const  SizedBox(width: 20),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () => Get.toNamed(Routes.transactionPage),
                                  child: Container(
                                      width: a / 6.5,
                                      height: a / 5
                                      ,
                                      // height: fullWidth / 4,
                                      // height: a/ 4,
                                      padding:const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 24),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                              8),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: -4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3))
                                          ]),
                                      child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: a / 15,

                                              width: a / 15,
                                              padding: const EdgeInsetsDirectional.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: const Color(0xFFFFC107)
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color: const Color(
                                                          0xFFFFC107))),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(6),
                                                child: SvgPicture.asset(
                                                  'assets/ic_coin_wallet.svg',
                                                  fit: BoxFit.contain,
                                                  width: 8,
                                                  height: 8,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "کیــف پـول",
                                              style: theme.textTheme.subtitle1
                                                  ?.copyWith(
                                                  fontSize: a/80,

                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 80),
                                              child: controller
                                                  .isBusyGetWallet.value
                                                  ? Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  Container(
                                                      margin: const EdgeInsets.only(
                                                          bottom:
                                                          8),
                                                      child: const CupertinoActivityIndicator(
                                                          color: AppColors
                                                              .captionTextColor)),
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        bottom:
                                                        4),
                                                    child: Text(
                                                      ' ريال',
                                                      style: theme
                                                          .textTheme
                                                          .caption
                                                          ?.copyWith(
                                                          fontSize: a/80,

                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: AppColors
                                                              .captionTextColor),
                                                    ),
                                                  )
                                                ],
                                              )
                                                  : RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(

                                                    text: formatNumber(
                                                        controller
                                                            .pref
                                                            .totalWallet?[
                                                        0]
                                                            .price ??
                                                            0),
                                                    style: theme.textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                        fontSize: a/80,

                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: AppColors
                                                            .captionTextColor),
                                                  ),
                                                  TextSpan(
                                                    text: ' ريال',
                                                    style: theme
                                                        .textTheme.caption
                                                        ?.copyWith(
                                                        fontSize: a/80,

                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: AppColors
                                                            .captionTextColor),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ])),
                                );
                              }),
                            ],
                          )),


                      controller.homeEntity != null
                          ? Container(
                          color: Colors.white,

                          child: BannersWidget(rpm: controller.homeEntity![0]))
                          : const SizedBox(),
                      const SizedBox(width:0,),
                    ],
                  ),
                  if (controller.homeEntity?.length != 0)
                    Container(
                      alignment: AlignmentDirectional.centerStart,

                      margin:
                      const EdgeInsetsDirectional.only(top: 42,start: 20),
                      child: Text(
                        "محصـولات",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (controller.homeEntity?.length != 0)
                    const SizedBox(height: 28),

                  if (controller.homeEntity?.length != 0)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: a/5.4,
                      child: ListView.builder(

                          scrollDirection: Axis.horizontal,
                          itemCount: controller.homeEntity?.length ?? 0,
                          //todo fix bug in list horizontal
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return homeWidgetSelectorDesktop(
                                context,
                                controller.homeEntity?[index] ??
                                    <ProductSectionModel>[]);
                          }),
                    ),
                  const SizedBox(height: 8),
                  if (controller.deliveryData?.data.isNotEmpty ?? false)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      margin:
                      const EdgeInsetsDirectional.only(start:20),
                      child: Text(
                        "درخواست ها",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(
                    // width: fullWidth,
                    width:a,

                    child: controller.isBusyGetRequests.value
                        ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32),
                        child: const CupertinoActivityIndicator())
                        : SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                          controller.deliveryData?.data.length ?? 0,
                          shrinkWrap: true,
                          padding:const EdgeInsetsDirectional.only(
                            start: 20,
                            // end: standardSize,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return requestWidgetDesktop(
                                controller.deliveryData?.data[index] ??
                                    DriverDeliveryEntity(addressId: 0),
                                index);
                          }),
                    ),
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight * 2),
                ],
              ),
            ),
            onEmpty: emptyWidget('محصولی وجود ندارد'),
            onError: (error) => errorWidget(error.toString(), onTap: () {
              controller.fetchData();
              controller.fetchHome();
            },
                // height: fullHeight / 1.5
                height: b/ 1.5

            ),
            onLoading: loadingWidget(
              // height: fullHeight / 1.5
                height: b/ 1.5
            ),
          ),
        ));
        // });
    // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;

/*
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 0,
          ),
          body: controller.obx(
                (state) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        // width: fullWidth / 2.3,
                          width:a / 2.5,
                          // width:640,
                          margin:const EdgeInsetsDirectional.only(end: 20),
                          child: Row(
                            children: [
                              const  SizedBox(width: 0),

                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => mainPageController
                                          .selectedIndex.value = 1,
                                      child: Container(
                                          height: a / 10.6
                                          ,

                                          padding: EdgeInsets.symmetric(
                                              horizontal:   a / 100
                                              , vertical: a / 80),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor, borderRadius:
                                          BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: -4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3))
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
                                                        .textTheme.subtitle1
                                                        ?.copyWith(
                                                        fontSize: a/80,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  height: a / 20,
                                                  width: a / 20,
                                                  padding: EdgeInsetsDirectional.all(a / 100),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.blue
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: Colors
                                                              .blue.shade700)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(2),
                                                    child: SvgPicture.asset(
                                                        'assets/ic_shop.svg',
                                                        width: a / 20,
                                                        height: a / 20,
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                              ])),
                                    ),
                                    SizedBox(height: a / 100),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(
                                        Routes.residuePricePage,
                                        // transition:
                                        //     Transition.rightToLeft
                                      ),
                                      child: Container(
                                          height: a / 10.6,

                                          padding: EdgeInsets.symmetric(
                                              horizontal:   a / 100
                                              , vertical: a / 80),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: -4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3))
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
                                                        .textTheme.subtitle1
                                                        ?.copyWith(
                                                        fontSize: a/80,

                                                        fontWeight:
                                                        FontWeight
                                                            .bold),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  height: a / 20,
                                                  width: a / 20,
                                                  padding:const EdgeInsets.symmetric(
                                                      horizontal:
                                                      10,
                                                      vertical:
                                                      10),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: theme.primaryColor
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: theme
                                                              .primaryColor)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                    child: SvgPicture.asset(
                                                        'assets/ic_recycle.svg',
                                                        color:
                                                        theme.primaryColor,
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                              ])),
                                    ),
                                  ],
                                ),
                              ),
                              const  SizedBox(width: 20),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () => Get.toNamed(Routes.transactionPage),
                                  child: Container(
                                      width: a / 6.5,
                                      height: a / 5
                                      ,
                                      // height: fullWidth / 4,
                                      // height: a/ 4,
                                      padding:const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 24),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                              8),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: -4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3))
                                          ]),
                                      child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              height: a / 15,

                                              width: a / 15,
                                              padding: const EdgeInsetsDirectional.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: const Color(0xFFFFC107)
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color: const Color(
                                                          0xFFFFC107))),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(6),
                                                child: SvgPicture.asset(
                                                  'assets/ic_coin_wallet.svg',
                                                  fit: BoxFit.contain,
                                                  width: 8,
                                                  height: 8,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "کیــف پـول",
                                              style: theme.textTheme.subtitle1
                                                  ?.copyWith(
                                                  fontSize: a/80,

                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 80),
                                              child: controller
                                                  .isBusyGetWallet.value
                                                  ? Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .end,
                                                children: [
                                                  Container(
                                                      margin: const EdgeInsets.only(
                                                          bottom:
                                                          8),
                                                      child: const CupertinoActivityIndicator(
                                                          color: AppColors
                                                              .captionTextColor)),
                                                  Container(
                                                    margin: const EdgeInsets.only(
                                                        bottom:
                                                        4),
                                                    child: Text(
                                                      ' ريال',
                                                      style: theme
                                                          .textTheme
                                                          .caption
                                                          ?.copyWith(
                                                          fontSize: a/80,

                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: AppColors
                                                              .captionTextColor),
                                                    ),
                                                  )
                                                ],
                                              )
                                                  : RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(

                                                    text: formatNumber(
                                                        controller
                                                            .pref
                                                            .totalWallet?[
                                                        0]
                                                            .price ??
                                                            0),
                                                    style: theme.textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                        fontSize: a/80,

                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: AppColors
                                                            .captionTextColor),
                                                  ),
                                                  TextSpan(
                                                    text: ' ريال',
                                                    style: theme
                                                        .textTheme.caption
                                                        ?.copyWith(
                                                        fontSize: a/80,

                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        color: AppColors
                                                            .captionTextColor),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ])),
                                );
                              }),
                            ],
                          )),


                      controller.homeEntity != null
                          ? Container(
                          color: Colors.white,

                          child: BannersWidget(rpm: controller.homeEntity![0]))
                          : const SizedBox(),
                      const SizedBox(width:0,),
                    ],
                  ),
                  if (controller.homeEntity?.length != 0)
                    Container(
                      alignment: AlignmentDirectional.centerStart,

                      margin:
                      const EdgeInsetsDirectional.only(top: 42,start: 20),
                      child: Text(
                        "محصـولات",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (controller.homeEntity?.length != 0)
                    const SizedBox(height: 28),

                  if (controller.homeEntity?.length != 0)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: a/5.4,
                      child: ListView.builder(

                          scrollDirection: Axis.horizontal,
                          itemCount: controller.homeEntity?.length ?? 0,
                          //todo fix bug in list horizontal
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return homeWidgetSelectorDesktop(
                                context,
                                controller.homeEntity?[index] ??
                                    <ProductSectionModel>[]);
                          }),
                    ),
                  const SizedBox(height: 8),
                  if (controller.deliveryData?.data.isNotEmpty ?? false)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      margin:
                      const EdgeInsetsDirectional.only(start:20),
                      child: Text(
                        "درخواست ها",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(
                    // width: fullWidth,
                    width:a,

                    child: controller.isBusyGetRequests.value
                        ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32),
                        child: const CupertinoActivityIndicator())
                        : SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                          controller.deliveryData?.data.length ?? 0,
                          shrinkWrap: true,
                          padding:const EdgeInsetsDirectional.only(
                            start: 20,
                            // end: standardSize,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return requestWidgetDesktop(
                                controller.deliveryData?.data[index] ??
                                    DriverDeliveryEntity(addressId: 0),
                                index);
                          }),
                    ),
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight * 2),
                ],
              ),
            ),
            onEmpty: emptyWidget('محصولی وجود ندارد'),
            onError: (error) => errorWidget(error.toString(), onTap: () {
              controller.fetchData();
              controller.fetchHome();
            },
                // height: fullHeight / 1.5
                height: b/ 1.5

            ),
            onLoading: loadingWidget(
              // height: fullHeight / 1.5
                height: b/ 1.5
            ),
          ),
        ));
*/
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.3,
            // toolbarHeight: fullWidth / 5.5,
            toolbarHeight: 80,
            shadowColor: AppColors.shadowColor,
            centerTitle: false,
            title: Row(
              children: [
                Container(
                  // height: fullHeight / 20,
                  height: b / 20,
                  // width: fullHeight / 20,
                  width: b/ 20,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsetsDirectional.only(end: 8),
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
          body:
          // Obx(() {
          //       return
          controller.obx(
                (state) => SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  controller.homeEntity != null
                      ? BannersWidget(rpm: controller.homeEntity![0])
                      : const SizedBox(),
                  const SizedBox(height: 24),
                  Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "خدمات زیستینــو",
                      style: theme.textTheme.headline6
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () => mainPageController
                                      .selectedIndex.value = 1,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 24),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius:
                                          BorderRadius.circular(
                                              18),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: -4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3))
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
                                                    .textTheme.subtitle1
                                                    ?.copyWith(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              height: 48,
                                              width: 48,
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal:
                                                  10,
                                                  vertical:
                                                  10),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blue
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color: Colors.blue
                                                          .shade700)),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    6),
                                                child: SvgPicture.asset(
                                                    'assets/ic_shop.svg',
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                          ])),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                    Routes.residuePricePage,
                                    // transition:
                                    //     Transition.rightToLeft
                                  ),
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 24),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius:
                                          BorderRadius.circular(
                                              18),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: -4,
                                                blurRadius: 10,
                                                offset: Offset(0, 3))
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
                                                    .textTheme.subtitle1
                                                    ?.copyWith(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              height: 48,
                                              width: 48,
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal:
                                                  10,
                                                  vertical:
                                                  10),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: theme
                                                      .primaryColor
                                                      .withOpacity(0.2),
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color: theme
                                                          .primaryColor)),
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    6),
                                                child: SvgPicture.asset(
                                                    'assets/ic_recycle.svg',
                                                    color: theme
                                                        .primaryColor,
                                                    fit: BoxFit.contain),
                                              ),
                                            ),
                                          ])),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Obx(() {
                              return GestureDetector(
                                onTap: () => Get.toNamed(Routes.transactionPage),
                                child: Container(
                                  // height: fullHeight / 4.05,
                                    height: 205,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 24),
                                    decoration: BoxDecoration(
                                        color: theme.backgroundColor,
                                        borderRadius:
                                        BorderRadius.circular(
                                            18),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Colors.black12,
                                              spreadRadius: -4,
                                              blurRadius: 10,
                                              offset: Offset(0, 3))
                                        ]),
                                    child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Container(
                                            height: 48,
                                            width: 48,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: const Color(
                                                    0xFFFFC107)
                                                    .withOpacity(0.2),
                                                border: Border.all(
                                                    width: 1.5,
                                                    color: const Color(
                                                        0xFFFFC107))),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  6),
                                              child: SvgPicture.asset(
                                                  'assets/ic_coin_wallet.svg',
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "کیــف پـول",
                                            style: theme
                                                .textTheme.subtitle1
                                                ?.copyWith(
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                          AnimatedSize(
                                            duration: const Duration(
                                                milliseconds: 80),
                                            child:
                                            controller.isBusyGetWallet
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
                                                    margin: const EdgeInsets.only(
                                                        bottom:
                                                        8),
                                                    child: const CupertinoActivityIndicator(
                                                        color: AppColors
                                                            .captionTextColor)),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .only(
                                                      bottom:
                                                      4),
                                                  child: Text(
                                                    ' ريال',
                                                    style: theme
                                                        .textTheme
                                                        .caption
                                                        ?.copyWith(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: AppColors.captionTextColor),
                                                  ),
                                                )
                                              ],
                                            )
                                                : RichText(
                                              text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: formatNumber(controller
                                                          .pref
                                                          .totalWallet?[0]
                                                          .price ??
                                                          0),
                                                      style: theme
                                                          .textTheme
                                                          .headline6
                                                          ?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.captionTextColor),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                      ' ريال',
                                                      style: theme
                                                          .textTheme
                                                          .caption
                                                          ?.copyWith(
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.captionTextColor),
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
                  const SizedBox(height: 24),
                  if (controller.homeEntity?.length != 0)
                    Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "محصـولات",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (controller.homeEntity?.length != 0)
                    const SizedBox(height: 16),
                  // Container(
                  //   height: fullHeight / 3.2,
                  //   child: ListView.builder(
                  //       itemCount: productData().length,
                  //       shrinkWrap: true,
                  //       padding: EdgeInsetsDirectional.only(start: standardSize),
                  //       physics: const BouncingScrollPhysics(),
                  //       scrollDirection: Axis.horizontal,
                  //       itemBuilder: (context, index) {
                  //         return Container(
                  //             margin:
                  //                 EdgeInsetsDirectional.only(end: standardSize),
                  //             child: productWidget(productData()[index]));
                  //       }),
                  // ),
                  ///
                  if (controller.homeEntity?.length != 0)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      height: a/3,
                      child: ListView.builder(

                          scrollDirection: Axis.horizontal,
                          itemCount: controller.homeEntity?.length ?? 0,
                          //todo fix bug in list horizontal
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return homeWidgetSelectorTablet(
                                context,
                                controller.homeEntity?[index] ??
                                    <ProductSectionModel>[]);
                          }),
                    ),
                  const SizedBox(height: 8),
                  if (controller.deliveryData?.data.isNotEmpty ?? false)
                    Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "درخواست ها",
                        style: theme.textTheme.headline6
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  SizedBox(
                    // width: fullWidth,
                    child: controller.isBusyGetRequests.value
                        ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32),
                        child: const CupertinoActivityIndicator())
                        : SizedBox(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                          controller.deliveryData?.data.length ?? 0,
                          shrinkWrap: true,
                          padding:const EdgeInsetsDirectional.only(
                            start: 20,
                            // end: standardSize,
                          ),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return requestWidgetDesktop(
                                controller.deliveryData?.data[index] ??
                                    DriverDeliveryEntity(addressId: 0),
                                index);
                          }),
                    ),
                    width: a,
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight * 2),
                ],
              ),
            ),
            onEmpty: emptyWidget('محصولی وجود ندارد'),
            onError: (error) => errorWidget(error.toString(), onTap: () {
              controller.fetchData();
              controller.fetchHome();
            },
                // height: fullHeight / 1.5
                height: b/ 1.5

            ),
            onLoading: loadingWidget(
              // height: fullHeight / 1.5
                height:b / 1.5
            ),
            // ;
            // }),
          ),
        ));


    /* HomeBinding().dependencies();
    controller.getUserWallet();
    return GetBuilder(
        init: controller,
        initState: (state) {
          controller.fetchData();
          controller.fetchHome();
        },
        builder: (_) {
          return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
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
                body:
                // Obx(() {
                //       return
                controller.obx(
                      (state) => SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: largeSize),
                        controller.homeEntity != null
                            ? BannersWidget(rpm: controller.homeEntity![0])
                            : const SizedBox(),
                        SizedBox(height: largeSize),
                        Container(
                          margin:
                          EdgeInsets.symmetric(horizontal: standardSize),
                          child: Text(
                            "خدمات زیستینــو",
                            style: theme.textTheme.headline6
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: standardSize),
                        Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: standardSize),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => mainPageController
                                            .selectedIndex.value = 1,
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: standardSize,
                                                vertical: largeSize),
                                            decoration: BoxDecoration(
                                                color: theme.backgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    standardRadius),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: -4,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3))
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
                                                          .textTheme.subtitle1
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: xxSmallSize),
                                                  Container(
                                                    height: xxLargeSize,
                                                    width: xxLargeSize,
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal:
                                                        smallSize / 1.2,
                                                        vertical:
                                                        smallSize /
                                                            1.2),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blue
                                                            .withOpacity(0.2),
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: Colors.blue
                                                                .shade700)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          xSmallRadius),
                                                      child: SvgPicture.asset(
                                                          'assets/ic_shop.svg',
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ])),
                                      ),
                                      SizedBox(height: smallSize),
                                      GestureDetector(
                                        onTap: () => Get.toNamed(
                                          Routes.residuePricePage,
                                          // transition:
                                          //     Transition.rightToLeft
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: standardSize,
                                                vertical: largeSize),
                                            decoration: BoxDecoration(
                                                color: theme.backgroundColor,
                                                borderRadius:
                                                BorderRadius.circular(
                                                    standardRadius),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      spreadRadius: -4,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 3))
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
                                                          .textTheme.subtitle1
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ),
                                                  SizedBox(height: xxSmallSize),
                                                  Container(
                                                    height: xxLargeSize,
                                                    width: xxLargeSize,
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal:
                                                        smallSize / 1.2,
                                                        vertical:
                                                        smallSize /
                                                            1.2),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: theme
                                                            .primaryColor
                                                            .withOpacity(0.2),
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color: theme
                                                                .primaryColor)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          xSmallRadius),
                                                      child: SvgPicture.asset(
                                                          'assets/ic_recycle.svg',
                                                          color: theme
                                                              .primaryColor,
                                                          fit: BoxFit.contain),
                                                    ),
                                                  ),
                                                ])),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: smallSize),
                                Expanded(
                                  flex: 1,
                                  child: Obx(() {
                                    return GestureDetector(
                                      onTap: () => Get.to(TransactionPage()),
                                      child: Container(
                                          height: fullHeight / 4.05,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: standardSize,
                                              vertical: largeSize),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  standardRadius),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: -4,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 3))
                                              ]),
                                          child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Container(
                                                  height: xxLargeSize,
                                                  width: xxLargeSize,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                      smallSize / 1.2,
                                                      vertical:
                                                      smallSize / 1.2),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: const Color(
                                                          0xFFFFC107)
                                                          .withOpacity(0.2),
                                                      border: Border.all(
                                                          width: 1.5,
                                                          color: const Color(
                                                              0xFFFFC107))),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        xSmallRadius),
                                                    child: SvgPicture.asset(
                                                        'assets/ic_coin_wallet.svg',
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                                SizedBox(height: xxSmallSize),
                                                Text(
                                                  "کیــف پـول",
                                                  style: theme
                                                      .textTheme.subtitle1
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight.bold),
                                                ),
                                                AnimatedSize(
                                                  duration: const Duration(
                                                      milliseconds: 80),
                                                  child:
                                                  controller.isBusyGetWallet
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
                                                              color: AppColors
                                                                  .captionTextColor)),
                                                      Container(
                                                        margin: EdgeInsets
                                                            .only(
                                                            bottom:
                                                            xxSmallSize),
                                                        child: Text(
                                                          ' ريال',
                                                          style: theme
                                                              .textTheme
                                                              .caption
                                                              ?.copyWith(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: AppColors.captionTextColor),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                      : RichText(
                                                    text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: formatNumber(controller
                                                                .pref
                                                                .totalWallet?[0]
                                                                .price ??
                                                                0),
                                                            style: theme
                                                                .textTheme
                                                                .headline6
                                                                ?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.captionTextColor),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                            ' ريال',
                                                            style: theme
                                                                .textTheme
                                                                .caption
                                                                ?.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.captionTextColor),
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
                        if (controller.homeEntity?.length != 0)
                          Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: standardSize),
                            child: Text(
                              "محصـولات",
                              style: theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (controller.homeEntity?.length != 0)
                          SizedBox(height: standardSize),
                        // Container(
                        //   height: fullHeight / 3.2,
                        //   child: ListView.builder(
                        //       itemCount: productData().length,
                        //       shrinkWrap: true,
                        //       padding: EdgeInsetsDirectional.only(start: standardSize),
                        //       physics: const BouncingScrollPhysics(),
                        //       scrollDirection: Axis.horizontal,
                        //       itemBuilder: (context, index) {
                        //         return Container(
                        //             margin:
                        //                 EdgeInsetsDirectional.only(end: standardSize),
                        //             child: productWidget(productData()[index]));
                        //       }),
                        // ),
                        ///
                        if (controller.homeEntity?.length != 0)
                          SizedBox(
                            height: fullWidth / 1.5,
                            child: ListView.builder(
                                itemCount: controller.homeEntity?.length ?? 0,
                                //todo fix bug in list horizontal
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return homeWidgetSelector(
                                      context,
                                      controller.homeEntity?[index] ??
                                          <ProductSectionModel>[]);
                                }),
                          ),
                        SizedBox(height: xSmallSize),
                        if (controller.deliveryData?.data.isNotEmpty ?? false)
                          Container(
                            margin:
                            EdgeInsets.symmetric(horizontal: standardSize),
                            child: Text(
                              "درخواست ها",
                              style: theme.textTheme.headline6
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        SizedBox(
                          width: fullWidth,
                          child: controller.isBusyGetRequests.value
                              ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: xLargeSize),
                              child: const CupertinoActivityIndicator())
                              : ListView.builder(
                              itemCount:
                              controller.deliveryData?.data.length ?? 0,
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(
                                start: standardSize,
                                end: standardSize,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return requestWidget(
                                    controller.deliveryData?.data[index] ??
                                        DriverDeliveryEntity(addressId: 0),
                                    index);
                              }),
                        ),
                        const SizedBox(height: kBottomNavigationBarHeight * 2),
                      ],
                    ),
                  ),
                  onEmpty: emptyWidget('محصولی وجود ندارد'),
                  onError: (error) => errorWidget(error.toString(), onTap: () {
                    controller.fetchData();
                    controller.fetchHome();
                  }, height: fullHeight / 1.5),
                  onLoading: loadingWidget(height: fullHeight / 1.5),
                  // ;
                  // }),
                ),
              ));
        });*/
  }

  Widget homeWidgetSelectorDesktop(
      BuildContext context, List<ProductSectionEntity> sections) {
    switch (sections[0].setting.type) {
      case ProductSectionType.scrollable:
        return const SizedBox();

      case ProductSectionType.horizontal:
        return productListHomeDesktop(sections);

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
Widget homeWidgetSelectorPhone(
      BuildContext context, List<ProductSectionEntity> sections) {
    switch (sections[0].setting.type) {
      case ProductSectionType.scrollable:
        return const SizedBox();

      case ProductSectionType.horizontal:
        return productListHomePhone(sections);

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
Widget homeWidgetSelectorTablet(
    BuildContext context, List<ProductSectionEntity> sections) {
  switch (sections[0].setting.type) {
    case ProductSectionType.scrollable:
      return const SizedBox();

    case ProductSectionType.horizontal:
      return productListHomeTablet(sections);

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