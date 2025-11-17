// ignore_for_file: must_be_immutable, deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:recycling_machine/src/presentation/widgets/remove_req_sheet/remove_req_sheet.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/empty_widget.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/error_widget.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/loading_widget.dart';
import '../../../../../data/models/base/driver_delivery_model.dart';
import '../../../../../data/providers/fake_data.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../inv/residue_page/binding/binding.dart';
import '../../../inv/residue_page/view/select_residue_page.dart';
import '../../../sec/order_detail_page/view/order_detail_page.dart';
import '../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  /// Variables ///
  RxDouble height = (fullHeight / 6).obs;
  RxDouble width = (fullHeight / 7).obs;

  /// Instances ///
  final ThemeData theme = Get.theme;
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    debugPrint('${controller.pref.token} token');
    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) async {
          controller.fetchData();
          controller.mapController = MapController();
        },
        builder: (controller) {
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
                      child: GestureDetector(
                          onTap: () {
                            debugPrint(
                                '${controller.startLocationID.value} startLocIdHome');
                          },
                          child: Image.asset('assets/pic_white_logo.png')),
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
              body: RefreshIndicator(
                color: theme.primaryColor,
                onRefresh: () async {
                  controller.fetchData();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: fullWidth,
                        height: fullWidth / 3,
                        margin: EdgeInsetsDirectional.all(standardSize),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(mediumRadius),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: standardSize),
                            Text(
                              '',
                              style: theme.textTheme.headline6,
                            ),
                            controller.pref.tripId == null
                                ? controller.isBusyTrip.value == false
                                    ? Text(
                                        'آفلاین هستید',
                                        style: theme.textTheme.headline6,
                                      )
                                    : const SizedBox()
                                : controller.isBusyEndTrip.value == false
                                    ? Text(
                                        'در حال جمع آوری (آنلاین)',
                                        style: theme.textTheme.headline6,
                                      )
                                    : const SizedBox(),
                            const Spacer(),
                            GestureDetector(
                              onTap:
                              controller.pref.tripId == null
                                  ?
                                () async{
                                  controller.createTrip();
                                  controller.startForegroundTask();
                                      await controller.getPermission();
                                      // controller.createTrip();
                                      // FlutterForegroundTask.startService(
                                      //   notificationTitle: 'در حال جمع آوری',
                                      //   notificationText:
                                      //       'شما در حال اجرای کار هستید',
                                      //   callback: startCallbackNew,
                                      // );
                                    }
                                  : () {
                                      controller.endTrip();
                                    },
                              child: Container(
                                width: xxLargeSize * 1.5,
                                height: xxLargeSize * 1.5,
                                padding:
                                    EdgeInsetsDirectional.all(xSmallSize),
                                decoration: const BoxDecoration(
                                    color: AppColors.homeBackgroundColor,
                                    shape: BoxShape.circle),
                                child: controller.pref.tripId == null
                                    ? controller.isBusyTrip.value == false
                                        ? Icon(
                                            Icons.power_settings_new_rounded,
                                            color: AppColors.captionColor,
                                            size: iconSizeLarge * 2,
                                          )
                                        : const CupertinoActivityIndicator()
                                    : controller.isBusyEndTrip.value == false
                                        ? Icon(
                                            Icons.power_settings_new_rounded,
                                            color: AppColors.primaryColor,
                                            size: iconSizeLarge * 2,
                                          )
                                        : const CupertinoActivityIndicator(),
                              ),
                            ),
                            SizedBox(
                              width: mediumSize,
                            )
                          ],
                        ),
                      ),
/*
                      Container(
                        width: fullWidth,
                        height: fullWidth / 3,
                        margin: EdgeInsetsDirectional.all(standardSize),
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.4),
                            borderRadius:
                                BorderRadius.circular(standardSize)),
                        child: Center(
                            child: ElevatedButton(
                          onPressed: controller.pref.tripId.isEmpty
                              ? () async {
                                  await controller.getPermission();
                                  controller.createTrip();
                                  FlutterForegroundTask.startService(
                                    notificationTitle:
                                        'در حال جمع آوری',
                                    notificationText:
                                        'شما در حال اجرای کار هستید',
                                    callback: startCallback,
                                  );
                                }
                              : () {
                                  controller.endTrip();
                                  FlutterForegroundTask.stopService();
                                },
                          child: Text(
                            controller.pref.tripId.isEmpty
                                ? 'شروع جمع آوری'
                                : 'پایان جمع آوری',
                            style: theme.textTheme.headline6,
                          ),
                        )),
                      ),
*/
                      SizedBox(
                        // margin: EdgeInsetsDirectional.only(top: standardSize),
                        height: fullWidth / 3.3,
                        child: ListView.builder(
                            itemCount: orderCategoryData().length,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsetsDirectional.only(
                                start: standardSize),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    if (controller.isBusyOrders.isFalse) {
                                      if (controller.currentIndex.value !=
                                          index) {
                                        controller.fetchData(index: index);
                                      }
                                      controller.currentIndex.value = index;
                                    }
                                  },
                                  child: Container(
                                      width: fullWidth / 3.3,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: xSmallSize,
                                          vertical: smallSize),
                                      margin: EdgeInsetsDirectional.only(
                                          end: standardSize),
                                      decoration: BoxDecoration(
                                        color: theme.backgroundColor,
                                        border: Border.all(
                                            color: controller
                                                        .currentIndex.value ==
                                                    index
                                                ? theme.primaryColor
                                                : Colors.transparent,
                                            width: 1.4),
                                        borderRadius: BorderRadius.circular(
                                            xSmallRadius),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    xSmallRadius),
                                            child: Image.asset(
                                              orderCategoryData()[index]
                                                  .image,
                                              width: xxLargeSize,
                                            ),
                                          ),
                                          SizedBox(height: standardSize),
                                          Text(
                                            orderCategoryData()[index].text,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodyText2
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          )
                                        ],
                                      )),
                                );
                              });
                            }),
                      ),
                      SizedBox(height: xLargeSize),
                      Obx(() {
                        return Padding(
                          padding:
                              EdgeInsetsDirectional.only(start: standardSize),
                          child: Text(
                              orderCategoryData()[
                                      controller.currentIndex.value]
                                  .text,
                              style: theme.textTheme.bodyText1?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                  color: AppColors.captionTextColor)),
                        );
                      }),
                      controller.obx(
                          (state) => ListView.builder(
                              itemCount: controller.homeEntity?.data.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return _homeWidget(
                                    entity:
                                        controller.homeEntity?.data[index] ??
                                            DriverDeliveryModel(
                                                userId: '', addressId: 0));
                              }),
                          onError: (error) => errorWidget("$error",
                              onTap: () => controller.fetchData()),
                          onLoading: loadingWidget(),
                          onEmpty: emptyWidget("سفارشی وجود ندارد"))
                    ],
                  ),
                ),
              ));
        });
  }

  Widget _homeWidget({required DriverDeliveryModel entity}) {
    Jalali jalali = DateTime.parse(entity.deliveryDate)
        .toJalali(); //todo change to  deliveryDate

    String date =
        " ${jalali.formatter.yyyy} / ${jalali.formatter.m} / ${jalali.formatter.d}";

    DateTime timeOrder = DateTime.parse(entity.deliveryDate);

    String time = '${timeOrder.hour}';

    return Container(
      width: fullWidth,
      margin:
          EdgeInsets.symmetric(horizontal: standardSize, vertical: smallSize),
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          entity.status == 0
              ? GestureDetector(
                  onTap: () {
                    removeRequestSheet(model: entity);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red)),
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: iconSizeSmall,
                    ),
                  ),
                )
              : const SizedBox(),
          _itemCardWidget(
              title: "وضعیت", desc: controller.statusText(entity.status)),
          _itemCardWidget(title: "درخواست دهنده", desc: entity.creator),
          _itemCardWidget(title: "شماره همراه", desc: entity.phoneNumber),
          _itemCardWidget(title: "آدرس", desc: entity.address),
          _itemCardWidget(title: "زمان", desc: "$date  -  $time"),
          Row(
            children: [
              if (entity.status == 0 || entity.status == 2)
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                          top: xLargeSize,
                          start: xxSmallSize,
                          end: xxSmallSize),
                      child: Ink(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: theme.primaryColor),
                            color: const Color(0xffF1FCDA),
                            borderRadius: BorderRadius.circular(smallRadius)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(smallRadius),
                          splashColor: Colors.black.withOpacity(0.03),
                          onTap: () {
                            entity.status == 2
                                ? Get.off(
                                    SelectResiduePage(
                                      isFromMain: true,
                                      driverDeliveryEntity: entity,
                                    ),
                                    binding: ResiduePriceBinding())
                                : controller.editDelivery(entity);
                          },
                          child: Container(
                            width: fullWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: smallSize, horizontal: xSmallSize),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(smallRadius)),
                            child: Center(
                              child: Text(
                                entity.status == 2
                                    ? 'ثبت سفارش'
                                    : 'شروع جمع آوری',
                                style: theme.textTheme.subtitle2!
                                    .copyWith(color: theme.primaryColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (entity.status == 0)
                SizedBox(
                  width: standardSize,
                ),
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                        top: xLargeSize, start: xxSmallSize, end: xxSmallSize),
                    child: Ink(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(smallRadius)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(smallRadius),
                        splashColor: Colors.black.withOpacity(0.03),
                        onTap: () {
                          debugPrint('${entity.orderId}*-*-*-*-*-*-');
                          Get.to(OrderDetailPage(entity: entity));
                        },
                        child: Container(
                          width: fullWidth,
                          padding: EdgeInsets.symmetric(
                              vertical: smallSize, horizontal: xSmallSize),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(smallRadius)),
                          child: Center(
                            child: Text(
                              'جزئیات',
                              style: theme.textTheme.subtitle2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _itemCardWidget({required String title, required String desc}) {
    return Column(
      children: [
        Container(
          width: fullWidth,
          padding: EdgeInsets.symmetric(vertical: smallSize),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.caption?.copyWith(
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              SizedBox(width: smallSize),
              Text(
                desc,
                textDirection: TextDirection.ltr,
                style: theme.textTheme.caption?.copyWith(
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.captionTextColor),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: AppColors.dividerColor,
        )
      ],
    );
  }
}
