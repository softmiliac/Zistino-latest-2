// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/image_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../controller/request_detail_controller.dart';

class RequestDetailPage
    extends GetResponsiveView<RequestDetailController> {
  RequestDetailPage({super.key, required this.entity});

  DriverDeliveryEntity entity;
  final ThemeData theme = Get.theme;



  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // controller.mapController = MapController(
    //     initPosition:
    //         GeoPoint(latitude: entity.latitude, longitude: entity.longitude),
    //     initMapWithUserPosition: false);
/*    if (entity.orderId != 0 &&entity.orderId != null) {
      controller.orderID = entity.orderId;
    }
    return GetBuilder(
        initState: (state) {
          if (entity.orderId != 0 && entity.orderId != null) {
            controller.fetchOrder(); //todo
          }
        },
        init: controller,
        builder: (_) {*/
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.shadowColor.withOpacity(0.2),
                  elevation: 15,
                  title: Text('جزئیات سفارش',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  leading: backIcon(iconColor: Colors.black),
                  backgroundColor: theme.backgroundColor,
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: a/24),
                        child: Text('موقعیت مکانی',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: a/24, vertical: a/60),
                      //   height: b / 4,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(a/50),
                      //     child: OSMFlutter(
                      //       controller: controller.mapController,
                      //       trackMyPosition: false,
                      //       initZoom: 16,
                      //       minZoomLevel: 16,
                      //       isPicker: true,
                      //       maxZoomLevel: 16,
                      //       stepZoom: 1.0,
                      //       onMapIsReady: (p0) {
                      //         controller.mapController.addMarker(GeoPoint(
                      //             latitude: entity.latitude,
                      //             longitude: entity.longitude));
                      //       },
                      //       userLocationMarker: UserLocationMaker(
                      //         personMarker: const MarkerIcon(
                      //           icon: Icon(
                      //             Icons.location_on,
                      //             color: Colors.red,
                      //             size: 55,
                      //           ),
                      //         ),
                      //         directionArrowMarker: const MarkerIcon(
                      //           icon: Icon(
                      //             Icons.double_arrow,
                      //             size: 48,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: a/24),
                        child: Text('جزئیات آدرس و تحویل دهنده',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: a,
                        margin: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/60),
                        padding: EdgeInsets.only(
                            left: a/24,
                            right: a/24,
                            top: a/24,
                            bottom: a/24),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(a/50),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: -3,
                                  blurRadius: 12,
                                  offset: Offset(0, 5))
                            ]),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: a,
                              padding: EdgeInsets.only(bottom: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "آدرس تحویل پسماند",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(height: a/100),
                                  Text(
                                    entity.address,
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            Container(
                              width: a,
                              padding:
                              EdgeInsets.symmetric(vertical: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "نام گیرنده",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(width: a/60),
                                  Expanded(
                                    child: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        entity.driver.isEmpty
                                            ? 'در انتظار تعیین راننده'
                                            : entity.driver,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.caption?.copyWith(
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: a/100),
                                  Container(
                                    width: a / 9,
                                    height: a / 9,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.primaryColor)),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/profile_avatar.png',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // if(entity.driverPhone.isNotEmpty)
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            // if(entity.driverPhone.isNotEmpty)
                            Container(
                              width: a,
                              padding: EdgeInsets.only(
                                  top: a/60,
                                  bottom: entity.driverPhone.isNotEmpty
                                      ? a/60
                                      : 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "شماره پلاک",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            a/100 / 1.5),
                                        border: Border.all(
                                            width: 1, color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 2,
                                              horizontal: a/100),
                                          child: Column(
                                            children: [
                                              Text(
                                                'ایران',
                                                style: theme.textTheme.overline
                                                    ?.copyWith(
                                                    fontFamily: 'b-nazanin',
                                                    fontSize: 9,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(height: a/100 / 2),
                                              Text(
                                                '12',
                                                style: theme.textTheme.bodyText2
                                                    ?.copyWith(
                                                    fontFamily: 'b-nazanin',
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 2,
                                              horizontal: a/80 / 2),
                                          child: Text(
                                            '345 الف 12',
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.subtitle2
                                                ?.copyWith(
                                                fontFamily: 'b-nazanin',
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade900,
                                              borderRadius:
                                              BorderRadiusDirectional.only(
                                                  topEnd: Radius.circular(
                                                      a/100 / 2.2),
                                                  bottomEnd:
                                                  Radius.circular(
                                                      a/100 /
                                                          2.2))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 1.8,
                                              horizontal: a/100 / 2),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                  'assets/pic_flag_iran.webp',
                                                  height: a/80 / 1.2),
                                              SizedBox(
                                                  height: a/100 / 1.5),
                                              Text(
                                                'I.R\nIRAN',
                                                textAlign: TextAlign.left,
                                                style: theme.textTheme.overline
                                                    ?.copyWith(
                                                    fontSize: 4,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (entity.driverPhone.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: AppColors.dividerColor,
                              ),
                            if (entity.driverPhone.isNotEmpty)
                              Container(
                                width: a,
                                padding: EdgeInsets.only(
                                    top: a/60, bottom: a/100),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(a/50),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "شماره همراه",
                                        style: theme.textTheme.caption
                                            ?.copyWith(
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                            color:
                                            AppColors.captionTextColor),
                                      ),
                                    ),
                                    SizedBox(width: a/60),
                                    Text(
                                      entity.driverPhone,
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
                      ),
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: a/24),
                        child: Text('روز و ساعت تحویل',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: a,
                        margin: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/60),
                        padding: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/24),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(a/50),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: -3,
                                  blurRadius: 12,
                                  offset: Offset(0, 5))
                            ]),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: a,
                              padding:
                              EdgeInsets.symmetric(vertical: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "روز",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Text(
                                    controller.dateFormat(entity),
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            Container(
                              width: a,
                              padding: EdgeInsets.only(top: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ساعت",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Text(
                                    controller.timeFormat(entity),
                                    // '12 : 30',
                                    textDirection: TextDirection.ltr,
                                    //todo fix pars time from gregorian to jalali
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
                      ),
                      SizedBox(height: a/20),
                      if (entity.orderId != 0 &&entity.orderId != null) //todo
                        Padding(
                          padding:
                          EdgeInsetsDirectional.only(start: a/24),
                          child: Text('محصول',
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: AppColors.captionTextColor)),
                        ),
                      if (entity.orderId != 0 &&entity.orderId != null) //todo
                        controller.obx(
                              (state) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                controller.result?.orderItems?.length ?? 0,
                                itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: a/24,
                                      vertical: a/60),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: a/20,
                                      vertical: a/24),
                                  decoration: BoxDecoration(
                                      color: theme.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          a/50),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: -3,
                                            blurRadius: 12,
                                            offset: Offset(0, 5))
                                      ]),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      imageWidget(
                                          controller
                                              .result
                                              ?.orderItems?[index]
                                              .productImage ??
                                              '',
                                          width: a / 6.5,
                                          height: a / 6.5),
                                      SizedBox(width: a/20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                controller
                                                    .result
                                                    ?.orderItems?[index]
                                                    .productName ??
                                                    '',
                                                style: theme
                                                    .textTheme.subtitle1),
                                            SizedBox(height: a/80),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "وزن پسماند",
                                                    style: theme
                                                        .textTheme.caption
                                                        ?.copyWith(
                                                        letterSpacing:
                                                        0.5,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        color: AppColors
                                                            .captionTextColor),
                                                  ),
                                                ),
                                                SizedBox(width: a/60),
                                                Text(
                                                  '${controller.result?.orderItems?[index].itemCount} کیلوگرم',
                                                  style: theme
                                                      .textTheme.caption
                                                      ?.copyWith(
                                                      letterSpacing:
                                                      0.5,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      color:
                                                      Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: a/80),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "جمع قیمت",
                                                    style: theme
                                                        .textTheme.caption
                                                        ?.copyWith(
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: AppColors
                                                          .captionTextColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: a/60),
                                                Text(
                                                  "${controller.result?.orderItems?[index].unitPrice ?? 0} ريال",
                                                  style: theme
                                                      .textTheme.caption
                                                      ?.copyWith(
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          onEmpty: emptyWidget('', height: b / 8),
                          onLoading: loadingWidget(height: b / 8),
                          onError: (error) => errorWidget('$error',
                              onTap: () => controller.fetchOrder(),
                              height: b / 8),
                        ),
                    ],
                  ),
                )),
          );
        // });
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // controller.mapController = MapController(
    //     initPosition:
    //         GeoPoint(latitude: entity.latitude, longitude: entity.longitude),
    //     initMapWithUserPosition: false);
    // if (entity.orderId != 0 &&entity.orderId != null) {
    //   controller.orderID = entity.orderId;
    // }
    // return GetBuilder(
    //     initState: (state) {
    //       if (entity.orderId != 0 &&entity.orderId != null) {
    //         controller.fetchOrder(); //todo
    //       }
    //     },
    //     init: controller,
    //     builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.shadowColor.withOpacity(0.2),
                  elevation: 15,
                  title: Text('جزئیات سفارش',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  leading: backIcon(iconColor: Colors.black),
                  backgroundColor: theme.backgroundColor,
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: a/24),
                        child: Text('موقعیت مکانی',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: a/24, vertical: a/60),
                      //   height: b / 4,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(a/50),
                      //     child: OSMFlutter(
                      //       controller: controller.mapController,
                      //       trackMyPosition: false,
                      //       initZoom: 16,
                      //       minZoomLevel: 16,
                      //       isPicker: true,
                      //       maxZoomLevel: 16,
                      //       stepZoom: 1.0,
                      //       onMapIsReady: (p0) {
                      //         controller.mapController.addMarker(GeoPoint(
                      //             latitude: entity.latitude,
                      //             longitude: entity.longitude));
                      //       },
                      //       userLocationMarker: UserLocationMaker(
                      //         personMarker: const MarkerIcon(
                      //           icon: Icon(
                      //             Icons.location_on,
                      //             color: Colors.red,
                      //             size: 55,
                      //           ),
                      //         ),
                      //         directionArrowMarker: const MarkerIcon(
                      //           icon: Icon(
                      //             Icons.double_arrow,
                      //             size: 48,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: a/24),
                        child: Text('جزئیات آدرس و تحویل دهنده',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: a,
                        margin: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/60),
                        padding: EdgeInsets.only(
                            left: a/24,
                            right: a/24,
                            top: a/24,
                            bottom: a/24),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(a/50),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: -3,
                                  blurRadius: 12,
                                  offset: Offset(0, 5))
                            ]),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: a,
                              padding: EdgeInsets.only(bottom: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a/50),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "آدرس تحویل پسماند",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(height: a/100),
                                  Text(
                                    entity.address,
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            Container(
                              width: a,
                              padding:
                                  EdgeInsets.symmetric(vertical: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "نام گیرنده",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(width: a/60),
                                  Expanded(
                                    child: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        entity.driver.isEmpty
                                            ? 'در انتظار تعیین راننده'
                                            : entity.driver,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.caption?.copyWith(
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: a/100),
                                  Container(
                                    width: a / 9,
                                    height: a / 9,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.primaryColor)),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/profile_avatar.png',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // if(entity.driverPhone.isNotEmpty)
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            // if(entity.driverPhone.isNotEmpty)
                            Container(
                              width: a,
                              padding: EdgeInsets.only(
                                  top: a/60,
                                  bottom: entity.driverPhone.isNotEmpty
                                      ? a/60
                                      : 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "شماره پلاک",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            a/100 / 1.5),
                                        border: Border.all(
                                            width: 1, color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 2,
                                              horizontal: a/100),
                                          child: Column(
                                            children: [
                                              Text(
                                                'ایران',
                                                style: theme.textTheme.overline
                                                    ?.copyWith(
                                                        fontFamily: 'b-nazanin',
                                                        fontSize: 9,
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                              SizedBox(height: a/100 / 2),
                                              Text(
                                                '12',
                                                style: theme.textTheme.bodyText2
                                                    ?.copyWith(
                                                        fontFamily: 'b-nazanin',
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 2,
                                              horizontal: a/80 / 2),
                                          child: Text(
                                            '345 الف 12',
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.subtitle2
                                                ?.copyWith(
                                                    fontFamily: 'b-nazanin',
                                                    letterSpacing: 0.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black),
                                          ),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade900,
                                              borderRadius:
                                                  BorderRadiusDirectional.only(
                                                      topEnd: Radius.circular(
                                                          a/100 / 2.2),
                                                      bottomEnd:
                                                          Radius.circular(
                                                              a/100 /
                                                                  2.2))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 1.8,
                                              horizontal: a/100 / 2),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                  'assets/pic_flag_iran.webp',
                                                  height: a/80 / 1.2),
                                              SizedBox(
                                                  height: a/100 / 1.5),
                                              Text(
                                                'I.R\nIRAN',
                                                textAlign: TextAlign.left,
                                                style: theme.textTheme.overline
                                                    ?.copyWith(
                                                        fontSize: 4,
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (entity.driverPhone.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: AppColors.dividerColor,
                              ),
                            if (entity.driverPhone.isNotEmpty)
                              Container(
                                width: a,
                                padding: EdgeInsets.only(
                                    top: a/60, bottom: a/100),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(a/50),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "شماره همراه",
                                        style: theme.textTheme.caption
                                            ?.copyWith(
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w600,
                                                color:
                                                    AppColors.captionTextColor),
                                      ),
                                    ),
                                    SizedBox(width: a/60),
                                    Text(
                                      entity.driverPhone,
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
                      ),
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: a/24),
                        child: Text('روز و ساعت تحویل',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: a,
                        margin: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/60),
                        padding: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/24),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(a/50),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: -3,
                                  blurRadius: 12,
                                  offset: Offset(0, 5))
                            ]),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: a,
                              padding:
                                  EdgeInsets.symmetric(vertical: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "روز",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Text(
                                    controller.dateFormat(entity),
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            Container(
                              width: a,
                              padding: EdgeInsets.only(top: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ساعت",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Text(
                                    controller.timeFormat(entity),
                                    // '12 : 30',
                                    textDirection: TextDirection.ltr,
                                    //todo fix pars time from gregorian to jalali
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
                      ),
                      SizedBox(height: a/20),
                      if (entity.orderId != 0 &&entity.orderId != null) //todo
                        Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: a/24),
                          child: Text('محصول',
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: AppColors.captionTextColor)),
                        ),
                      if (entity.orderId != 0 &&entity.orderId != null) //todo
                        controller.obx(
                          (state) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    controller.result?.orderItems?.length ?? 0,
                                itemBuilder: (context, index) => Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: a/24,
                                          vertical: a/60),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: a/20,
                                          vertical: a/24),
                                      decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          borderRadius: BorderRadius.circular(
                                              a/50),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                spreadRadius: -3,
                                                blurRadius: 12,
                                                offset: Offset(0, 5))
                                          ]),
                                      child: Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          imageWidget(
                                              controller
                                                      .result
                                                      ?.orderItems?[index]
                                                      .productImage ??
                                                  '',
                                              width: a / 6.5,
                                              height: a / 6.5),
                                          SizedBox(width: a/20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    controller
                                                            .result
                                                            ?.orderItems?[index]
                                                            .productName ??
                                                        '',
                                                    style: theme
                                                        .textTheme.subtitle1),
                                                SizedBox(height: a/80),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "وزن پسماند",
                                                        style: theme
                                                            .textTheme.caption
                                                            ?.copyWith(
                                                                letterSpacing:
                                                                    0.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .captionTextColor),
                                                      ),
                                                    ),
                                                    SizedBox(width: a/60),
                                                    Text(
                                                      '${controller.result?.orderItems?[index].itemCount} کیلوگرم',
                                                      style: theme
                                                          .textTheme.caption
                                                          ?.copyWith(
                                                              letterSpacing:
                                                                  0.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: a/80),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        "جمع قیمت",
                                                        style: theme
                                                            .textTheme.caption
                                                            ?.copyWith(
                                                          letterSpacing: 0.5,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .captionTextColor,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: a/60),
                                                    Text(
                                                      "${controller.result?.orderItems?[index].unitPrice ?? 0} ريال",
                                                      style: theme
                                                          .textTheme.caption
                                                          ?.copyWith(
                                                        letterSpacing: 0.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          onEmpty: emptyWidget('', height: b / 8),
                          onLoading: loadingWidget(height: b / 8),
                          onError: (error) => errorWidget('$error',
                              onTap: () => controller.fetchOrder(),
                              height: b / 8),
                        ),
                    ],
                  ),
                )),
          );
        // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // controller.mapController = MapController(
    //     initPosition:
    //         GeoPoint(latitude: entity.latitude, longitude: entity.longitude),
    //     initMapWithUserPosition: false);
    // if (entity.orderId != 0 &&entity.orderId != null) {
    //   controller.orderID = entity.orderId;
    // }
    // return GetBuilder(
    //     initState: (state) {
    //       if (entity.orderId != 0 &&entity.orderId != null) {
    //         controller.fetchOrder(); //todo
    //       }
    //     },
    //     init: controller,
    //     builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.shadowColor.withOpacity(0.2),
                  elevation: 15,
                  title: Text('جزئیات سفارش',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  leading: backIcon(iconColor: Colors.black),
                  backgroundColor: theme.backgroundColor,
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: a/24),
                        child: Text('موقعیت مکانی',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: a/24, vertical: a/60),
                      //   height: b / 4,
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(a/50),
                      //     child: OSMFlutter(
                      //       controller: controller.mapController,
                      //       trackMyPosition: false,
                      //       initZoom: 16,
                      //       minZoomLevel: 16,
                      //       isPicker: true,
                      //       maxZoomLevel: 16,
                      //       stepZoom: 1.0,
                      //       onMapIsReady: (p0) {
                      //         controller.mapController.addMarker(GeoPoint(
                      //             latitude: entity.latitude,
                      //             longitude: entity.longitude));
                      //       },
                      //       userLocationMarker: UserLocationMaker(
                      //         personMarker: const MarkerIcon(
                      //           icon: Icon(
                      //             Icons.location_on,
                      //             color: Colors.red,
                      //             size: 55,
                      //           ),
                      //         ),
                      //         directionArrowMarker: const MarkerIcon(
                      //           icon: Icon(
                      //             Icons.double_arrow,
                      //             size: 48,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: a/24),
                        child: Text('جزئیات آدرس و تحویل دهنده',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: a,
                        margin: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/60),
                        padding: EdgeInsets.only(
                            left: a/24,
                            right: a/24,
                            top: a/24,
                            bottom: a/24),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(a/50),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: -3,
                                  blurRadius: 12,
                                  offset: Offset(0, 5))
                            ]),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: a,
                              padding: EdgeInsets.only(bottom: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "آدرس تحویل پسماند",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(height: a/100),
                                  Text(
                                    entity.address,
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            Container(
                              width: a,
                              padding:
                              EdgeInsets.symmetric(vertical: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "نام گیرنده",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(width: a/60),
                                  Expanded(
                                    child: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        entity.driver.isEmpty
                                            ? 'در انتظار تعیین راننده'
                                            : entity.driver,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.caption?.copyWith(
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: a/100),
                                  Container(
                                    width: a / 9,
                                    height: a / 9,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.primaryColor)),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/profile_avatar.png',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // if(entity.driverPhone.isNotEmpty)
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            // if(entity.driverPhone.isNotEmpty)
                            Container(
                              width: a,
                              padding: EdgeInsets.only(
                                  top: a/60,
                                  bottom: entity.driverPhone.isNotEmpty
                                      ? a/60
                                      : 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "شماره پلاک",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            a/100 / 1.5),
                                        border: Border.all(
                                            width: 1, color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 2,
                                              horizontal: a/100),
                                          child: Column(
                                            children: [
                                              Text(
                                                'ایران',
                                                style: theme.textTheme.overline
                                                    ?.copyWith(
                                                    fontFamily: 'b-nazanin',
                                                    fontSize: 9,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                              SizedBox(height: a/100 / 2),
                                              Text(
                                                '12',
                                                style: theme.textTheme.bodyText2
                                                    ?.copyWith(
                                                    fontFamily: 'b-nazanin',
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 2,
                                              horizontal: a/80 / 2),
                                          child: Text(
                                            '345 الف 12',
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.subtitle2
                                                ?.copyWith(
                                                fontFamily: 'b-nazanin',
                                                letterSpacing: 0.5,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          width: 1,
                                          decoration: const BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        Container(
                                          height: a/16 / 1.2,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade900,
                                              borderRadius:
                                              BorderRadiusDirectional.only(
                                                  topEnd: Radius.circular(
                                                      a/100 / 2.2),
                                                  bottomEnd:
                                                  Radius.circular(
                                                      a/100 /
                                                          2.2))),
                                          padding: EdgeInsets.symmetric(
                                              vertical: a/100 / 1.8,
                                              horizontal: a/100 / 2),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                  'assets/pic_flag_iran.webp',
                                                  height: a/80 / 1.2),
                                              SizedBox(
                                                  height: a/100 / 1.5),
                                              Text(
                                                'I.R\nIRAN',
                                                textAlign: TextAlign.left,
                                                style: theme.textTheme.overline
                                                    ?.copyWith(
                                                    fontSize: 4,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (entity.driverPhone.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: AppColors.dividerColor,
                              ),
                            if (entity.driverPhone.isNotEmpty)
                              Container(
                                width: a,
                                padding: EdgeInsets.only(
                                    top: a/60, bottom: a/100),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(a/50),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "شماره همراه",
                                        style: theme.textTheme.caption
                                            ?.copyWith(
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                            color:
                                            AppColors.captionTextColor),
                                      ),
                                    ),
                                    SizedBox(width: a/60),
                                    Text(
                                      entity.driverPhone,
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
                      ),
                      SizedBox(height: a/20),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: a/24),
                        child: Text('روز و ساعت تحویل',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: a,
                        margin: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/60),
                        padding: EdgeInsets.symmetric(
                            horizontal: a/24, vertical: a/24),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(a/50),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: -3,
                                  blurRadius: 12,
                                  offset: Offset(0, 5))
                            ]),
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              width: a,
                              padding:
                              EdgeInsets.symmetric(vertical: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "روز",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Text(
                                    controller.dateFormat(entity),
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            Container(
                              width: a,
                              padding: EdgeInsets.only(top: a/60),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(a/50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ساعت",
                                      style: theme.textTheme.caption?.copyWith(
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.captionTextColor),
                                    ),
                                  ),
                                  SizedBox(width: a/60),
                                  Text(
                                    controller.timeFormat(entity),
                                    // '12 : 30',
                                    textDirection: TextDirection.ltr,
                                    //todo fix pars time from gregorian to jalali
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
                      ),
                      SizedBox(height: a/20),
                      if (entity.orderId != 0 &&entity.orderId != null) //todo
                        Padding(
                          padding:
                          EdgeInsetsDirectional.only(start: a/24),
                          child: Text('محصول',
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: AppColors.captionTextColor)),
                        ),
                      if (entity.orderId != 0 &&entity.orderId != null) //todo
                        controller.obx(
                              (state) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                controller.result?.orderItems?.length ?? 0,
                                itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: a/24,
                                      vertical: a/60),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: a/20,
                                      vertical: a/24),
                                  decoration: BoxDecoration(
                                      color: theme.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          a/50),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: -3,
                                            blurRadius: 12,
                                            offset: Offset(0, 5))
                                      ]),
                                  child: Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      imageWidget(
                                          controller
                                              .result
                                              ?.orderItems?[index]
                                              .productImage ??
                                              '',
                                          width: a / 6.5,
                                          height: a / 6.5),
                                      SizedBox(width: a/20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                controller
                                                    .result
                                                    ?.orderItems?[index]
                                                    .productName ??
                                                    '',
                                                style: theme
                                                    .textTheme.subtitle1),
                                            SizedBox(height: a/80),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "وزن پسماند",
                                                    style: theme
                                                        .textTheme.caption
                                                        ?.copyWith(
                                                        letterSpacing:
                                                        0.5,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600,
                                                        color: AppColors
                                                            .captionTextColor),
                                                  ),
                                                ),
                                                SizedBox(width: a/60),
                                                Text(
                                                  '${controller.result?.orderItems?[index].itemCount} کیلوگرم',
                                                  style: theme
                                                      .textTheme.caption
                                                      ?.copyWith(
                                                      letterSpacing:
                                                      0.5,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                      color:
                                                      Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: a/80),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "جمع قیمت",
                                                    style: theme
                                                        .textTheme.caption
                                                        ?.copyWith(
                                                      letterSpacing: 0.5,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: AppColors
                                                          .captionTextColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: a/60),
                                                Text(
                                                  "${controller.result?.orderItems?[index].unitPrice ?? 0} ريال",
                                                  style: theme
                                                      .textTheme.caption
                                                      ?.copyWith(
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          },
                          onEmpty: emptyWidget('', height: b / 8),
                          onLoading: loadingWidget(height: b / 8),
                          onError: (error) => errorWidget('$error',
                              onTap: () => controller.fetchOrder(),
                              height: b / 8),
                        ),
                    ],
                  ),
                )),
          );
        // });
  }
}
