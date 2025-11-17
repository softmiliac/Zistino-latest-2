import 'package:admin_zistino/src/presentation/ui/base/map_page/view/tracking_vehicle_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/base/driver_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../map_page/view/polyline_map_page.dart';
import '../binding/driver_binding.dart';
import '../controller/driver_detail_cotroller.dart';
import 'package:latlong2/latlong.dart';

class DriverDetailPage extends StatelessWidget {
  DriverDetailPage({required this.entity, Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
  final DriverEntity entity;

  @override
  Widget build(BuildContext context) {
    DriverBinding().dependencies();
   final DriverDetailController controller = Get.find();
    // debugPrint('${controller.rpmLocations?.first.id} RPMLOCATIONID');
    return GetBuilder<DriverDetailController> (
        init: controller,
        initState: (state) {
           controller.searchTrip(entity.id ?? '');

        },
        builder: (controller) {


          return WillPopScope(
            onWillPop: ()async {
                Get.delete<DriverDetailController>();
              return true;
            },
            child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  shadowColor: AppColors.shadowColor.withOpacity(0.2),
                  elevation: 15,
                  title: Text('جزئیات',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  leading: backIcon(
                    onTap: () {
                      Get.delete<DriverDetailController>();
                      Get.back();

                    },

                  ),
                  backgroundColor: theme.backgroundColor,
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                      top: standardSize, left: standardSize, right: standardSize),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('اطلاعات راننده',
                          style: theme.textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                              color: AppColors.captionTextColor)),
                      Container(
                        width: fullWidth,
                        margin: EdgeInsets.only(
                            bottom: standardSize, top: standardSize),
                        padding: EdgeInsets.symmetric(
                            horizontal: standardSize, vertical: xSmallSize),
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
                            _itemCardWidget(
                                title: "راننده",
                                desc: "${entity.firstName} ${entity.lastName}"),
                            _itemCardWidget(
                                title: "شماره همراه",
                                desc: entity.phoneNumber?.isEmpty ?? false
                                    ? "----------"
                                    : entity.phoneNumber ?? ""),
                            _itemCardWidget(
                                title: "نام بانک",
                                desc: entity.bankname?.isEmpty ?? false
                                    ? "----------"
                                    : entity.bankname ?? ""),
                            _itemCardWidget(
                                title: "شماره شبا",
                                desc: entity.sheba?.isEmpty ?? false
                                    ? "----------"
                                    : entity.sheba ?? ""),
                            _itemCardWidget(
                                title: "کد ملی",
                                desc: entity.codeMeli?.isEmpty ?? false
                                    ? "----------"
                                    : entity.codeMeli ?? ""),
                            SizedBox(height: xSmallSize),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(top: xLargeSize),
                          child: Ink(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(smallRadius)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(smallRadius),
                              splashColor: Colors.black.withOpacity(0.03),
                              onTap: () {
                                Get.to(TrackingVehiclePage(driverUserId:entity ,));
/*                          debugPrint('${entity.orderId}*-*-*-*-*-*-');
                        if (entity.orderId == 0 || entity.orderId == null) {
                        } else {
                          controller.fetchOrder(entity.orderId ?? 0);
                        }
                        controller.mapController = MapController(
                            initPosition: GeoPoint(
                                latitude: entity.latitude,
                                longitude: entity.longitude),
                            initMapWithUserPosition: false);
                        Get.off(OrderDetailPage(entity: entity));*/
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
                                    'موقعیت فعلی',
                                    style: theme.textTheme.subtitle2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: EdgeInsetsDirectional.only(top: xLargeSize),
                          child: Ink(
                            decoration: BoxDecoration(
                                border: Border.all(width: 1, color: Colors.grey),
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(smallRadius)),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(smallRadius),
                              splashColor: Colors.black.withOpacity(0.03),
                              onTap: () {
                                Get.to(PolyLinePage(entity: entity
                                  // ,firstLat: controller.rpmLocations?.first.latitude ?? 0,
                                // lastLong: controller.rpmLocations?.first.longitude ?? 0,

                                ));
/*                          debugPrint('${entity.orderId}*-*-*-*-*-*-');
                        if (entity.orderId == 0 || entity.orderId == null) {
                        } else {
                          controller.fetchOrder(entity.orderId ?? 0);
                        }
                        controller.mapController = MapController(
                            initPosition: GeoPoint(
                                latitude: entity.latitude,
                                longitude: entity.longitude),
                            initMapWithUserPosition: false);
                        Get.off(OrderDetailPage(entity: entity));*/
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
                                    'موقعیت یابی مسیر های طی شده',
                                    style: theme.textTheme.subtitle2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
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
