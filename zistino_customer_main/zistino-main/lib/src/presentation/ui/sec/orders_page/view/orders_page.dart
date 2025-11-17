// ignore_for_file: must_be_immutable

import 'package:zistino/src/presentation/ui/sec/orders_page/controller/orders_controller.dart';
import 'package:zistino/src/presentation/widgets/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../data/providers/fake_data.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../base/request_detail_page/view/request_detail_page.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../binding/order_binding.dart';

class OrdersPage extends ResponsiveLayoutBaseGetView<OrdersController> {
  OrdersPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;

  RxDouble height = (fullHeight / 6).obs;

  RxDouble width = (fullHeight / 7).obs;

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(context);
  }

  @override
  Widget mobile(BuildContext context) {
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
                  title:Text('سفارش ها',style: theme.textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold
                  ),),
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
                              itemCount: residueData().length,
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
                                              color: controller.currentIndex.value == index
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
                                itemCount: controller.deliveryData?.data.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return _homeWidget(
                                      entity:
                                      controller.deliveryData?.data[index] ??
                                          DriverDeliveryEntity(addressId: 0));
                                }),
                            onError: (error) => errorWidget("$error",onTap: () => controller.fetchData()),
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
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
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
          _itemCardWidget(title: "راننده", desc: entity.driver),
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
                    Get.to(RequestDetailPage(entity: entity));
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
}
