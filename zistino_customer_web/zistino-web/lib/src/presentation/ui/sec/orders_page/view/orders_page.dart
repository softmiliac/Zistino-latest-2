// ignore_for_file: must_be_immutable

import 'package:admin_dashboard/src/domain/entities/order_model.dart';
import 'package:admin_dashboard/src/presentation/ui/sec/orders_page/controller/orders_controller.dart';
import 'package:admin_dashboard/src/presentation/widgets/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../base/request_detail_page/binding/binding.dart';
import '../../../base/request_detail_page/view/request_detail_page.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../binding/order_binding.dart';

class OrdersPage extends GetResponsiveView<OrdersController> {
  OrdersPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
final context = Get.context!;
  RxDouble height = (fullHeight / 6).obs;

  RxDouble width = (fullHeight / 7).obs;

  @override
  Widget phone() {
    OrderBinding().dependencies();
    return GetBuilder<OrdersController>(
        init: controller,
        initState: (state) {
          controller.fetchData();
          // controller.mapController = MapController();
        },
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  leading: backIcon(),
                  elevation: 0.3,
                  toolbarHeight: fullWidth / 5.5,
                  shadowColor: AppColors.shadowColor,
                  centerTitle: true,
                  title: Text(
                    'سفارش ها',
                    style: theme.textTheme.subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
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
                          margin: EdgeInsetsDirectional.only(top: standardSize),
                          height: fullWidth / 3.3,
                          child: ListView.builder(
                              itemCount: 1,
                              //todo set count
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsetsDirectional.only(
                                  start: standardSize),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.currentIndex.value = index;
                                      controller.fetchData();

                                      // controller.changeItem(
                                      //     orderCategoryData()[index].status!);
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
                                (state) =>
                                ListView.builder(
                                    itemCount: controller.deliveryData?.data
                                        .length,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return _homeWidget(
                                          entity: controller
                                              .deliveryData?.data[index] ??
                                              DriverDeliveryEntity(
                                                  addressId: 0));
                                    }),
                            onError: (error) =>
                                errorWidget("$error",
                                    onTap: () => controller.fetchData()),
                            onLoading: loadingWidget(),
                            onEmpty: emptyWidget("سفارشی وجود ندارد"))
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  @override
  Widget tablet() {
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<OrdersController>(
        init: controller,
        initState: (state) {
          controller.fetchData();
          // controller.mapController = MapController();
        },
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    toolbarHeight: 0),
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
                          margin: EdgeInsetsDirectional.only(
                              top: xSmallSize / 3),
                          alignment: AlignmentDirectional.topCenter,
                          height: height/6,
                          child: ListView.builder(
                              itemCount: orderCategoryData().length,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding:
                              EdgeInsetsDirectional.only(start: xSmallSize /
                                  1.5),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.currentIndex.value = index;
                                      controller.fetchData();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: height / 90,
                                            vertical: height / 90),
                                        width: height/6,
                                        margin: EdgeInsetsDirectional.only(
                                            end: height / 25),
                                        decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.shadowColor
                                                  .withOpacity(0.16),
                                              spreadRadius: 1,
                                              blurRadius: 9,
                                              // blurStyle: BlurStyle.solid
                                            )
                                          ],
                                          border: Border.all(
                                              color: controller
                                                  .currentIndex.value ==
                                                  index
                                                  ? theme.primaryColor
                                                  : Colors.transparent,
                                              width: 1.4),
                                          borderRadius: BorderRadius.circular(
                                              height/64),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: height / 15,
                                              height: height / 15,
                                              child: Image.asset(
                                                orderCategoryData()[index]
                                                    .image,
                                                width: height / 15,
                                              ),
                                            ),
                                            // SizedBox(height: height / 50),
                                            Text(
                                              orderCategoryData()[index].text,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodyText2
                                                  ?.copyWith(
                                                  fontSize: height/55,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            )
                                          ],
                                        )),
                                  );
                                });
                              }),
                        ),
                        SizedBox(height: xSmallSize / 1.4),
                        Obx(() {
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: xSmallSize / 2),
                              child: Text(
                                  orderCategoryData()[
                                  controller.currentIndex.value]
                                      .text,
                                  style: theme.textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                      color: AppColors.captionTextColor)),
                            ),
                          );
                        }),
                        controller.obx(
                                (state) =>
                                GridView.builder(
                                    itemCount: controller.deliveryData?.data
                                        .length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        vertical: xSmallSize / 1.4,horizontal: xSmallSize/1.5),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 16/11.9,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: xSmallSize,
                                        mainAxisSpacing: xSmallSize),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return _homeWebWidget(
                                          entity: controller
                                              .deliveryData?.data[index] ??
                                              DriverDeliveryEntity(
                                                  addressId: 0));
                                    }),
                            onError: (error) =>
                                errorWidget("$error",
                                    onTap: () => controller.fetchData()),
                            onLoading: loadingWidget(),
                            onEmpty: emptyWidget("سفارشی وجود ندارد",isDesktop: true))
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  @override
  Widget desktop() {
    OrderBinding().dependencies();
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<OrdersController>(
        init: controller,
        initState: (state) {
          controller.fetchData();
          // controller.mapController = MapController();
        },
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    toolbarHeight: 0),
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
                          margin: EdgeInsetsDirectional.only(
                              top: xSmallSize / 3),
                          alignment: AlignmentDirectional.topCenter,
                          height: height/6,
                          child: ListView.builder(
                              itemCount: orderCategoryData().length,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              padding:
                              EdgeInsetsDirectional.only(start: xSmallSize /
                                  1.5),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Obx(() {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.currentIndex.value = index;
                                      controller.fetchData();
                                    },
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: height / 90,
                                            vertical: height / 90),
                                        width: height/6,
                                        margin: EdgeInsetsDirectional.only(
                                            end: height / 25),
                                        decoration: BoxDecoration(
                                          color: theme.backgroundColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.shadowColor
                                                  .withOpacity(0.16),
                                              spreadRadius: 1,
                                              blurRadius: 9,
                                              // blurStyle: BlurStyle.solid
                                            )
                                          ],
                                          border: Border.all(
                                              color: controller
                                                  .currentIndex.value ==
                                                  index
                                                  ? theme.primaryColor
                                                  : Colors.transparent,
                                              width: 1.4),
                                          borderRadius: BorderRadius.circular(
                                              height/64),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: height / 15,
                                              height: height / 15,
                                              child: Image.asset(
                                                orderCategoryData()[index]
                                                    .image,
                                                width: height / 15,
                                              ),
                                            ),
                                            // SizedBox(height: height / 50),
                                            Text(
                                              orderCategoryData()[index].text,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.bodyText2
                                                  ?.copyWith(
                                                  fontSize: height/55,
                                                  fontWeight:
                                                  FontWeight.w600),
                                            )
                                          ],
                                        )),
                                  );
                                });
                              }),
                        ),
                        SizedBox(height: xSmallSize / 1.4),
                        Obx(() {
                          return AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: Container(
                              padding: EdgeInsetsDirectional.only(
                                  start: xSmallSize / 2),
                              child: Text(
                                  orderCategoryData()[
                                  controller.currentIndex.value]
                                      .text,
                                  style: theme.textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.2,
                                      color: AppColors.captionTextColor)),
                            ),
                          );
                        }),
                        controller.obx(
                                (state) =>
                                GridView.builder(
                                    itemCount: controller.deliveryData?.data
                                        .length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.symmetric(
                                        vertical: xSmallSize / 1.4,horizontal: xSmallSize/1.5),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 16/11.9,
                                        crossAxisCount: 2,
                                        crossAxisSpacing: xSmallSize,
                                        mainAxisSpacing: xSmallSize),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return _homeWebWidget(
                                          entity: controller
                                              .deliveryData?.data[index] ??
                                              DriverDeliveryEntity(
                                                  addressId: 0));
                                    }),
                            onError: (error) =>
                                errorWidget("$error",
                                    onTap: () => controller.fetchData()),
                            onLoading: loadingWidget(),
                            onEmpty: emptyWidget("سفارشی وجود ندارد",isDesktop: true))
                      ],
                    ),
                  ),
                )),
          );
        });
  }

  Widget _homeWidget({required DriverDeliveryEntity entity}) {
    Jalali jalali = DateTime.parse(entity.createdOn).toJalali();

    String date =
        "${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}";

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
        children: [
          _itemCardWidget(title: "گیرنده", desc: entity.driver),
          _itemCardWidget(title: "شماره همراه", desc: entity.driverPhone),
          _itemCardWidget(title: "آدرس", desc: entity.address),
          _itemCardWidget(title: "زمان", desc: date),
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsetsDirectional.only(
                  top: xLargeSize, start: xxSmallSize, end: xxSmallSize),
              child: Ink(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: theme.primaryColor),
                    color: const Color(0xffF1FCDA),
                    borderRadius: BorderRadius.circular(smallRadius)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(smallRadius),
                  splashColor: Colors.black.withOpacity(0.03),
                  onTap: () {
                    Get.to(RequestDetailPage(entity: entity),
                        binding: RequestDetailBinding());
                    // controller.mapController = MapController(
                    //     initPosition: GeoPoint(
                    //         latitude: entity.latitude,
                    //         longitude: entity.longitude),
                    //     initMapWithUserPosition: false);
                    // Get.to(OrderDetailPage(entity: entity));
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
                        style: theme.textTheme.subtitle2!
                            .copyWith(color: theme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _homeWebWidget({required DriverDeliveryEntity entity}) {
    Jalali jalali = DateTime.parse(entity.createdOn).toJalali();

    String date =
        "${jalali.formatter.d} ${jalali.formatter.mN} ${jalali.formatter.yyyy}";

    return Container(
      width: fullWidth,
      padding: EdgeInsets.symmetric(
          horizontal: xSmallSize, vertical: xxSmallSize/1.7),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(xxSmallRadius/1.7),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: -3,
                blurRadius: 12,
                offset: Offset(0, 5))
          ]),
      child: Column(
        children: [
          _webItemCardWidget(title: "گیرنده", desc: entity.driver),
          _webItemCardWidget(title: "شماره همراه", desc: entity.driverPhone),
          _webItemCardWidget(title: "آدرس", desc: entity.address),
          _webItemCardWidget(title: "زمان", desc: date),
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsetsDirectional.only(
                  top: xSmallSize, start: xxSmallSize, end: xxSmallSize),
              child: Ink(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: theme.primaryColor),
                    color: const Color(0xffF1FCDA),
                    borderRadius: BorderRadius.circular(xxSmallRadius/1.7)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(xxSmallRadius/1.7),
                  splashColor: Colors.black.withOpacity(0.03),
                  onTap: () {
                    Get.to(RequestDetailPage(entity: entity),
                        binding: RequestDetailBinding());
                  },
                  child: Container(
                    width: fullWidth,
                    padding: EdgeInsets.symmetric(
                        vertical: xxSmallSize/1.4, horizontal: xxSmallSize),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(xxSmallRadius/1.7)),
                    child: Center(
                      child: Text(
                        'جزئیات',
                        style: theme.textTheme.subtitle2!
                            .copyWith(color: theme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
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

  Widget _webItemCardWidget({required String title, required String desc}) {
    return Column(
      children: [
        Container(
          width: fullWidth,
          padding: EdgeInsets.symmetric(vertical: xxSmallSize),
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
