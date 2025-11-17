
// ignore_for_file: must_be_immutable

import 'package:zistino/src/presentation/ui/base/home_page/widgets/requests_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/image_widget.dart';
import '../../home_page/controller/home_controller.dart';

class RequestDetailPage extends StatelessWidget {
  RequestDetailPage({super.key, required this.entity});

  DriverDeliveryEntity entity;

  final ThemeData theme = Get.theme;
 final  HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    debugPrint('${entity.orderId } orderId');
    debugPrint('${entity.preOrderId } prefOrderId');
    debugPrint('${entity.status } status');
    debugPrint('${controller.orderResultClient?.orderItems![0].itemCount } leeeee');
    controller.totalOrderPrice = 0;
    controller.mapController = MapController(
        initPosition:
        GeoPoint(latitude: entity.latitude, longitude: entity.longitude),
        initMapWithUserPosition: false);
    // if (entity.status == 4 || entity.status == 2) {
    //   if (entity.orderId != 0 && entity.orderId != null) {
    //     // controller.preOrderId = entity.orderId!;
    //   }
    // } else {
    //   if (entity.preOrderId != 0 && entity.preOrderId != null) {
    //     // controller.preOrderId = entity.preOrderId!;
    //   }
    // }

    return GetBuilder<HomeController>(
        initState: (state) {
          if (entity.status == 4 || entity.status == 2) {
            if (
            // entity.orderId != 0 &&
                entity.orderId != null) {
              controller.fetchOrderClient(entity.preOrderId ?? 0); //todo
              controller.fetchOrderDriver(entity.orderId ?? 0); //todo
            }
          } else {
            if (
            // entity.preOrderId != 0 &&
                entity.preOrderId != null) {
              controller.fetchOrderClient(entity.preOrderId ?? 0); //todo
              controller.fetchOrderDriver(entity.orderId ?? 0); //todo
            }
          }
        },
        init: controller,
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                bottomNavigationBar: entity.status == 0 ||
                    entity.status == 2 ||
                    entity.status == 4
                    ? Container(
                  padding: EdgeInsets.all(standardSize),
                  height: fullHeight / 9.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(standardRadius),
                          topRight: Radius.circular(standardRadius)),
                      color: theme.backgroundColor),
                  child: entity.status == 4
                      ? Row(
                    children: [
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: xxSmallSize,
                                bottom: xxSmallSize,
                                start: xxSmallSize,
                                end: xxSmallSize),
                            child: Ink(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: theme.primaryColor),
                                  color: const Color(0xffF1FCDA),
                                  borderRadius:
                                  BorderRadius.circular(
                                      smallRadius)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    smallRadius),
                                splashColor:
                                Colors.black.withOpacity(0.03),
                                onTap: () {
                                  Get.offNamed(Routes.reviewPage,
                                      arguments: entity);
                                },
                                child: Container(
                                  width: fullWidth,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: xSmallSize),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          smallRadius)),
                                  child: Obx(() {
                                    return Center(
                                      child: controller
                                          .isBusyEditAccess
                                          .value
                                          ? CupertinoActivityIndicator(
                                          color: theme
                                              .primaryColor)
                                          : Text(
                                        'تائید کردن',
                                        style: theme.textTheme
                                            .subtitle2!
                                            .copyWith(
                                            color: theme
                                                .primaryColor),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: standardSize,
                      ),
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: EdgeInsetsDirectional.only(
                                top: xxSmallSize,
                                bottom: xxSmallSize,
                                start: xxSmallSize,
                                end: xxSmallSize),
                            child: Ink(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.grey),
                                  color:
                                  Colors.grey.withOpacity(0.2),
                                  borderRadius:
                                  BorderRadius.circular(
                                      smallRadius)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                    smallRadius),
                                splashColor:
                                Colors.black.withOpacity(0.03),
                                onTap: () {
                                  controller.editRequest(entity, 8);
                                },
                                child: Container(
                                  width: fullWidth,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: xSmallSize),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          smallRadius)),
                                  child: Obx(() {
                                    return Center(
                                      child: controller
                                          .isBusyEditDeny.value
                                          ? const CupertinoActivityIndicator(
                                          color: Colors.black)
                                          : Text(
                                        'رد کردن',
                                        style: theme.textTheme
                                            .subtitle2,
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                      : entity.status < 4
                      ? Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsetsDirectional.only(
                          top: xxSmallSize,
                          bottom: xxSmallSize,
                          start: xxSmallSize,
                          end: xxSmallSize),
                      child: Ink(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: theme.errorColor),
                            color: theme.errorColor
                                .withOpacity(0.05),
                            borderRadius: BorderRadius.circular(
                                smallRadius)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              smallRadius),
                          splashColor:
                          Colors.black.withOpacity(0.03),
                          onTap: () {
                            removeRequestSheet(model: entity);
                          },
                          child: Container(
                            width: fullWidth,
                            padding: EdgeInsets.symmetric(
                                horizontal: xSmallSize),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    smallRadius)),
                            child: Obx(() {
                              return Center(
                                child: controller
                                    .isBusyDelete.value
                                    ? CupertinoActivityIndicator(
                                    color: theme.errorColor)
                                    : Text(
                                  'لغو درخواست',
                                  style: theme.textTheme
                                      .subtitle2!
                                      .copyWith(
                                      color: theme
                                          .errorColor),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  )
                      : const SizedBox(),
                )
                    : const SizedBox(),
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
                      SizedBox(height: largeSize),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: standardSize),
                        child: Text('موقعیت مکانی',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: standardSize, vertical: smallSize),
                        height: fullHeight / 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(mediumRadius),
                          child: OSMFlutter(
                            controller: controller.mapController,
                            trackMyPosition: false,
                            // mapIsLoading: Container(
                            //   height: fullHeight / 4,
                            //   width: fullWidth,
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(mediumRadius),
                            //     color: AppColors.homeBackgroundColor
                            //   ),
                            //   child: Lottie.asset('assets/location_loading.json'),
                            // ),
                            initZoom: 16,
                            minZoomLevel: 16,
                            isPicker: false,
                            maxZoomLevel: 16,
                            stepZoom: 1.0,
                            onMapIsReady: (p0) {
                              controller.mapController.addMarker(GeoPoint(
                                  latitude: entity.latitude,
                                  longitude: entity.longitude));
                            },
                            userLocationMarker: UserLocationMaker(
                              personMarker: const MarkerIcon(
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 55,
                                ),
                              ),
                              directionArrowMarker: const MarkerIcon(
                                icon: Icon(
                                  Icons.double_arrow,
                                  size: 48,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: largeSize),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: standardSize),
                        child: Text('جزئیات آدرس و تحویل دهنده',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: fullWidth,
                        margin: EdgeInsets.symmetric(
                            horizontal: standardSize, vertical: smallSize),
                        padding: EdgeInsets.only(
                            left: standardSize,
                            right: standardSize,
                            top: standardSize,
                            bottom: standardSize),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(mediumRadius),
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
                              width: fullWidth,
                              padding: EdgeInsets.only(bottom: smallSize),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(mediumRadius),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "نام راننده",
                                    style: theme.textTheme.caption?.copyWith(
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.captionTextColor),
                                  ),
                                  SizedBox(width: smallSize),
                                  Expanded(
                                    child: Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        entity.driver.isEmpty
                                            ? 'در انتظار تعیین راننده'
                                            : entity.driver,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.caption
                                            ?.copyWith(
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: xxSmallSize),
                                  Container(
                                    width: fullWidth / 9,
                                    height: fullWidth / 9,
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
                            Divider(
                              thickness: 1,
                              color: AppColors.dividerColor,
                            ),
                            if(entity.vatNumber.isNotEmpty)
                              Container(
                                width: fullWidth,
                                padding: EdgeInsets.only(
                                    top: smallSize, bottom: smallSize),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(mediumRadius),
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
                                    SizedBox(width: smallSize),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              xxSmallRadius / 1.5),
                                          border: Border.all(
                                              width: 1, color: Colors.black)),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: xxSmallSize / 2,
                                                horizontal: xxSmallSize),
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
                                                SizedBox(height: xxSmallSize / 2),
                                                Text(
                                                  entity.vatNumber.isNotEmpty
                                                      ? entity.vatNumber
                                                      .replaceRange(0, 7, '')
                                                      : '12',
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
                                            height: xLargeSize / 1.2,
                                            width: 1,
                                            decoration: const BoxDecoration(
                                                color: Colors.black),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: xxSmallSize / 2,
                                                horizontal: xSmallSize / 2),
                                            child: Text(
                                              entity.vatNumber.isNotEmpty
                                                  ? '${entity.vatNumber[5]}${entity.vatNumber[4]}${entity.vatNumber[3]} ${entity.vatNumber[2]} ${entity.vatNumber[1]}${entity.vatNumber[0]}'
                                                  : '345 الف 12',
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
                                            height: xLargeSize / 1.2,
                                            width: 1,
                                            decoration: const BoxDecoration(
                                                color: Colors.black),
                                          ),
                                          Container(
                                            height: xLargeSize / 1.2,
                                            decoration: BoxDecoration(
                                                color: Colors.blue.shade900,
                                                borderRadius:
                                                BorderRadiusDirectional.only(
                                                    topEnd: Radius.circular(
                                                        xxSmallRadius / 2.2),
                                                    bottomEnd:
                                                    Radius.circular(
                                                        xxSmallRadius /
                                                            2.2))),
                                            padding: EdgeInsets.symmetric(
                                                vertical: xxSmallSize / 1.8,
                                                horizontal: xxSmallSize / 2),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Image.asset(
                                                    'assets/pic_flag_iran.webp',
                                                    height: xSmallSize / 1.2),
                                                SizedBox(
                                                    height: xxSmallSize / 1.5),
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
                            // if(entity.driverPhone.isNotEmpty)
                            if(entity.vatNumber.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: AppColors.dividerColor,
                              ),
                            // if(entity.driverPhone.isNotEmpty)
                            Container(
                              width: fullWidth,
                              padding:
                              EdgeInsets.symmetric(vertical: smallSize),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(mediumRadius),
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
                                  SizedBox(height: xxSmallSize),
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

                            if (entity.driverPhone.isNotEmpty)
                              Divider(
                                thickness: 1,
                                color: AppColors.dividerColor,
                              ),
                            if (entity.driverPhone.isNotEmpty)
                              Container(
                                width: fullWidth,
                                padding: EdgeInsets.only(
                                    top: smallSize, bottom: xxSmallSize),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(mediumRadius),
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
                                    SizedBox(width: smallSize),
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
                      SizedBox(height: largeSize),
                      Padding(
                        padding:
                        EdgeInsetsDirectional.only(start: standardSize),
                        child: Text('روز و ساعت تحویل',
                            style: theme.textTheme.bodyText1?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                                color: AppColors.captionTextColor)),
                      ),
                      Container(
                        width: fullWidth,
                        margin: EdgeInsets.symmetric(
                            horizontal: standardSize, vertical: smallSize),
                        padding: EdgeInsets.symmetric(
                            horizontal: standardSize, vertical: standardSize),
                        decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            borderRadius: BorderRadius.circular(mediumRadius),
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
                              width: fullWidth,
                              padding:
                              EdgeInsets.symmetric(vertical: smallSize),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(mediumRadius),
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
                                  SizedBox(width: smallSize),
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
                              width: fullWidth,
                              padding: EdgeInsets.only(top: smallSize),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(mediumRadius),
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
                                  SizedBox(width: smallSize),
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
                      SizedBox(height: largeSize),
                      if (entity.preOrderId != 0 && entity.preOrderId != null)
                        Padding(
                          padding:
                          EdgeInsetsDirectional.only(start: standardSize),
                          child: Text('پسماند ثبت شده توسط شما',
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: AppColors.captionTextColor)),
                        ),
                      if (entity.preOrderId != 0 &&
                          entity.preOrderId != null)
                        Obx(() {
                          return controller.isBusyGetOrderClient.value
                              ? SizedBox(
                              height: fullHeight / 5.5,
                              child: const Center(
                                  child: CupertinoActivityIndicator()))
                              : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller
                                  .orderResultClient?.orderItems?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                if (entity.status == 4 ||
                                    entity.status == 2) {
                                   ((controller.orderResultClient?.orderItems?[index].itemCount ?? 0) *
                                              (controller
                                                  .orderResultClient
                                                  ?.orderItems?[index]
                                                  .unitPrice ??
                                                  0));
                                }

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: standardSize,
                                      vertical: smallSize),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: largeSize,
                                      vertical: standardSize),
                                  decoration: BoxDecoration(
                                      color: theme.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          mediumRadius),
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
                                              .orderResultClient
                                              ?.orderItems?[index]
                                              .productImage ??
                                              '',
                                          width: fullWidth / 6.5,
                                          height: fullWidth / 6.5),
                                      SizedBox(width: largeSize),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                controller
                                                    .orderResultClient
                                                    ?.orderItems?[index]
                                                    .productName ??
                                                    '',
                                                style: theme
                                                    .textTheme.subtitle1),
                                            SizedBox(height: xSmallSize),
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
                                                SizedBox(width: smallSize),
                                                Text(
                                                  '${controller.orderResultClient?.orderItems?[index].itemCount} کیلوگرم',
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
                                            SizedBox(height: xSmallSize),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "قیمت (هر کیلوگرم):",
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
                                                SizedBox(width: smallSize),
                                                Text(
                                                  "${controller.orderResultClient?.orderItems?[index].unitPrice ?? 0} ریال",
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
                                );
                              });
                        }),
                      if (entity.status == 4 || entity.status == 2
                          ? (entity.orderId != 0 && entity.orderId != null)
                          : (entity.preOrderId != 0 &&
                          entity.preOrderId != null)) //todo
                        Padding(
                          padding:
                          EdgeInsetsDirectional.only(start: standardSize),
                          child: Text('پسماند ثبت شده توسط راننده',
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: AppColors.captionTextColor)),
                        ),
                      if (entity.status == 4 || entity.status == 2
                          ? (entity.orderId != 0 && entity.orderId != null)
                          : (entity.preOrderId != 0 &&
                          entity.preOrderId != null)) //todo
                        Obx(() {
                          return controller.isBusyGetOrderDriver.value
                              ? SizedBox(
                              height: fullHeight / 5.5,
                              child: const Center(
                                  child: CupertinoActivityIndicator()))
                              : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller
                                  .orderResultDriver?.orderItems?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                if (entity.status == 4 ||
                                    entity.status == 2) {
                                  controller.totalOrderPrice =
                                      controller.totalOrderPrice +
                                          ((controller
                                              .orderResultDriver
                                              ?.orderItems?[index]
                                              .itemCount ??
                                              0) *
                                              (controller
                                                  .orderResultDriver
                                                  ?.orderItems?[index]
                                                  .unitPrice ??
                                                  0));
                                }

                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: standardSize,
                                      vertical: smallSize),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: largeSize,
                                      vertical: standardSize),
                                  decoration: BoxDecoration(
                                      color: theme.backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          mediumRadius),
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
                                              .orderResultDriver
                                              ?.orderItems?[index]
                                              .productImage ??
                                              '',
                                          width: fullWidth / 6.5,
                                          height: fullWidth / 6.5),
                                      SizedBox(width: largeSize),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                controller
                                                    .orderResultDriver
                                                    ?.orderItems?[index]
                                                    .productName ??
                                                    '',
                                                style: theme
                                                    .textTheme.subtitle1),
                                            SizedBox(height: xSmallSize),
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
                                                SizedBox(width: smallSize),
                                                Text(
                                                  '${controller.orderResultDriver?.orderItems?[index].itemCount} کیلوگرم',
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
                                            SizedBox(height: xSmallSize),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "قیمت (هر کیلوگرم):",
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
                                                SizedBox(width: smallSize),
                                                Text(
                                                  "${controller.orderResultDriver?.orderItems?[index].unitPrice ?? 0} ریال",
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
                                );
                              });
                        })
                    ],
                  ),
                )),
          );
        });
  }


}
