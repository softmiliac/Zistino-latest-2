// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:recycling_machine/src/data/models/base/driver_delivery_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/image_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/remove_req_sheet/remove_req_sheet.dart';
import '../../../base/home_page/controller/home_controller.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../../../inv/residue_page/binding/binding.dart';
import '../../../inv/residue_page/view/select_residue_page.dart';

class OrderDetailPage extends StatelessWidget {
  OrderDetailPage({required this.entity, super.key});

  HomeController controller = Get.find();

  final DriverDeliveryModel entity;

  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    debugPrint('${entity.orderId} status');
    DateTime timeOrder = DateTime.parse(entity.deliveryDate);

    String time =
        '${timeOrder.hour} : ${intl.DateFormat('mm').format(timeOrder)}';

    Jalali jalali = DateTime.parse(entity.deliveryDate).toJalali();

    String date =
        "${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}";

    controller.mapController = MapController(
        initPosition: GeoPoint(
            latitude: entity.latitude,
            longitude: entity.longitude),
        initMapWithUserPosition: false);

    if (entity.status == 4 || entity.status == 2) {
      if (entity.orderId != 0 && entity.orderId != null) {
        controller.orderID = entity.orderId!;
      }
    } else {
      if (entity.preOrderId != 0 && entity.preOrderId != null) {
        controller.orderID = entity.preOrderId!;
      }
    }

    return GetBuilder<HomeController>(
        initState: (state) {
          if (entity.status == 4 || entity.status == 2) {
            if (entity.orderId != 0 && entity.orderId != null) {
              controller.fetchOrder(); //todo
            }
          } else {
            if (entity.preOrderId != 0 && entity.preOrderId != null) {
              controller.fetchOrder(); //todo
            }
          }
        },
        init: controller,
        builder: (logic) {
          return WillPopScope(
            onWillPop: () async {
              Get.back();
              return false;
            },
            child: Directionality(
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
                    leading: backIcon(),
                    backgroundColor: theme.backgroundColor,
                  ),
                  bottomNavigationBar: entity.status == 0 || entity.status == 2
                      ? Container(
                    decoration: BoxDecoration(
                        color: theme.backgroundColor,
                        boxShadow: [
                          BoxShadow(
                              color:
                              AppColors.shadowColor.withOpacity(0.2),
                              offset: const Offset(0, -5),
                              spreadRadius: 0,
                              blurRadius: 10)
                        ]),
                    padding: EdgeInsets.all(largeSize),
                    child: Row(
                      children: [
                        Expanded(
                          child: progressButton(
                              hasBorder: true,
                              isDisable: false,
                              isProgress: false,
                              onTap: () {
                                entity.status == 2
                                    ? Get.to(
                                    SelectResiduePage(
                                      isFromMain: false,
                                      driverDeliveryEntity: entity,
                                    ),
                                    binding: ResiduePriceBinding())
                                    : controller.editDelivery(entity);
                              },
                              text: entity.status == 2
                                  ? 'ثبت سفارش'
                                  : "شروع جمع آوری"),
                        ),
                        SizedBox(
                          width: smallSize,
                        ),
                        Expanded(
                          child: progressButton(
                              isDisable: false,
                              isProgress: false,
                              onTap: () {
                                removeRequestSheet(model: entity);
                              },
                              text: "رد کردن"),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox(),
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
                              initZoom: 16,
                              minZoomLevel: 16,
                              isPicker: true,
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
                        Container(
                          margin: EdgeInsets.only(
                              left: standardSize, right: standardSize),
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: theme.primaryColor),
                                  color: const Color(0xffF1FCDA),
                                  borderRadius:
                                  BorderRadius.circular(smallRadius)),
                              child: InkWell(
                                borderRadius:
                                BorderRadius.circular(smallRadius),
                                splashColor: Colors.black.withOpacity(0.03),
                                onTap: () {
                                  MapsLauncher.launchCoordinates(
                                      entity.latitude,
                                      entity.longitude,
                                      'رفتن به این موقعیت مکانی');
                                },
                                child: Container(
                                  width: fullWidth,
                                  padding: EdgeInsets.symmetric(
                                      vertical: smallSize,
                                      horizontal: xSmallSize),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(smallRadius)),
                                  child: Center(
                                    child: Text(
                                      'مسیریابی',
                                      style: theme.textTheme.subtitle2!
                                          .copyWith(color: theme.primaryColor),
                                    ),
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
                          child: Column(
                            children: [
                              Container(
                                width: fullWidth,
                                padding: EdgeInsets.only(bottom: smallSize),
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
                                        "نام تحویل دهنده",
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
                                      entity.creator,
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
                                      entity.phoneNumber,
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
                        Container(
                          margin: EdgeInsets.only(
                              left: standardSize, right: standardSize),
                          child: Material(
                            color: Colors.transparent,
                            child: Ink(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: theme.primaryColor),
                                  color: const Color(0xffF1FCDA),
                                  borderRadius:
                                  BorderRadius.circular(smallRadius)),
                              child: InkWell(
                                borderRadius:
                                BorderRadius.circular(smallRadius),
                                splashColor: Colors.black.withOpacity(0.03),
                                onTap: () async {
                                  try {
                                    var phoneNumber =
                                        "tel:${entity.phoneNumber}";
                                    if (await canLaunchUrl(
                                        Uri.parse(phoneNumber))) {
                                      await launchUrl(Uri.parse(phoneNumber));
                                    } else {
                                      throw 'Could not launch $phoneNumber';
                                    }
                                  } catch (e) {
                                    rethrow;
                                  }
                                },
                                child: Container(
                                  width: fullWidth,
                                  padding: EdgeInsets.symmetric(
                                      vertical: smallSize,
                                      horizontal: xSmallSize),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(smallRadius)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'تماس با مشتری',
                                        style: theme.textTheme.subtitle2!
                                            .copyWith(
                                            color: theme.primaryColor),
                                      ),
                                      SizedBox(width: xxSmallSize),
                                      Icon(
                                        Icons.call,
                                        color: theme.primaryColor,
                                      ),
                                    ],
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
                          child: Column(
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
                                      date,
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
                                      time,
                                      textDirection: TextDirection.ltr,
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
                        if (entity.status == 4 || entity.status == 2
                            ? (entity.orderId != 0 && entity.orderId != null)
                            : (entity.preOrderId != 0 &&
                            entity.preOrderId != null))
                          Obx(() {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: standardSize),
                                  child: Text('پسماند',
                                      style: theme.textTheme.bodyText1
                                          ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.2,
                                          color: AppColors.captionTextColor)),
                                ),
                                controller.isBusyGetOrder.isTrue
                                    ? const CupertinoActivityIndicator()
                                    : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount:
                                    controller.orderResult?.orderItems?.length ??
                                        0,
                                    itemBuilder: (context, index) =>
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: standardSize,
                                              vertical: smallSize),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: largeSize,
                                              vertical: standardSize),
                                          decoration: BoxDecoration(
                                              color: theme.backgroundColor,
                                              borderRadius: BorderRadius
                                                  .circular(
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
                                                      .orderResult
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
                                                            .orderResult
                                                            ?.orderItems?[
                                                        index]
                                                            .productName ??
                                                            '',
                                                        style: theme
                                                            .textTheme
                                                            .subtitle1),
                                                    SizedBox(
                                                        height: xSmallSize),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "وزن پسماند",
                                                            style: theme
                                                                .textTheme
                                                                .caption
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
                                                        SizedBox(
                                                            width: smallSize),
                                                        Text(
                                                          '${controller.orderResult
                                                              ?.orderItems?[index]
                                                              .itemCount} کیلوگرم',
                                                          style: theme
                                                              .textTheme.caption
                                                              ?.copyWith(
                                                              letterSpacing:
                                                              0.5,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: xSmallSize),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "قیمت (هر کیلوگرم):",
                                                            style: theme
                                                                .textTheme
                                                                .caption
                                                                ?.copyWith(
                                                              letterSpacing: 0.5,
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              color: AppColors
                                                                  .captionTextColor,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width: smallSize),
                                                        Text(
                                                          "${controller.orderResult
                                                              ?.orderItems?[index]
                                                              .unitPrice ??
                                                              0} ریال",
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
                                        )),
                              ],
                            );
                          }),
                      ],
                    ),
                  )),
            ),
          );
        });  }

}
