// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/presentation/widgets/server_widgets/empty_widget.dart';
import 'package:admin_zistino/src/presentation/widgets/server_widgets/error_widget.dart';
import 'package:admin_zistino/src/presentation/widgets/server_widgets/loading_widget.dart';
import '../../../../../domain/entities/base/driver_entity.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

import '../../driver_detail_page/view/driver_detail_page.dart';
import '../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ThemeData theme = Get.theme;
  final HomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: controller,
        initState: (state) async {
          controller.fetchData();
          controller.mapController = MapController();
          print(controller.pref.token);
        },
        builder: (controller) {
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
                  title: GestureDetector(
                    onTap: () {},
                    child: Row(
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
                                    '${controller.startLocation} startLocIdHome');
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
                  ),
                  backgroundColor: theme.backgroundColor,
                ),
                body: RefreshIndicator(
                  onRefresh: () => controller.fetchData(),
                  color: theme.primaryColor,
                  child: controller.obx(
                          (state) => ListView.builder(
                          itemCount: controller.homeEntity?.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              right: standardSize,
                              left: standardSize,
                              top: standardSize),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return _homeWidget(
                                entity: controller.homeEntity?[index] ??
                                    DriverEntity());
                          }),
                      onError: (error) => errorWidget("$error",
                          onTap: () => controller.fetchData()),
                      onLoading: loadingWidget(height: fullHeight / 1.2),
                      onEmpty: emptyWidget("راننده ای وجود ندارد")),
                )),
          );
        });
  }

  Widget _homeWidget({required DriverEntity entity}) {
    // Jalali jalali = DateTime.parse(entity.deliveryDate)
    //     .toJalali(); //todo change to  deliveryDate
    //
    // String date =
    //     " ${jalali.formatter.yyyy} / ${jalali.formatter.m} / ${jalali.formatter.d}";
    //
    // DateTime timeOrder = DateTime.parse(entity.deliveryDate);
    //
    // String time = '${timeOrder.hour} : ${timeOrder.minute}';

    return Container(
      width: fullWidth,
      margin: EdgeInsets.only(bottom: standardSize),
      padding:
          EdgeInsets.symmetric(horizontal: standardSize, vertical: xSmallSize),
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
          // entity.status == 0
          //     ? GestureDetector(
          //         onTap: () {
          //           removeRequestSheet(model: entity);
          //         },
          //         child: Container(
          //           decoration: BoxDecoration(
          //               shape: BoxShape.circle,
          //               border: Border.all(color: Colors.red)),
          //           child: Icon(
          //             Icons.close,
          //             color: Colors.red,
          //             size: iconSizeSmall,
          //           ),
          //         ),
          //       )
          //     : const SizedBox(),
          // _itemCardWidget(
          //     title: "وضعیت", desc: controller.statusText(entity.status)),
          _itemCardWidget(
              title: "راننده", desc: "${entity.firstName} ${entity.lastName}"),
          _itemCardWidget(title: "شماره همراه", desc: entity.phoneNumber ?? ""),
          // _itemCardWidget(title: "آدرس", desc: entity.address ?? ""),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsetsDirectional.only(
                        top: xLargeSize, start: xxSmallSize, end: xxSmallSize),
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
                          Get.offNamed(Routes.selectResiduePage,arguments: entity.id);
                          // entity.status == 2 // topo fix status
                          //     ? Get.off(
                          //         SelectResiduePage(
                          //           isFromMain: true,
                          //           driverDeliveryEntity: entity,
                          //         ),
                          //         binding: ResiduePriceBinding())
                          //     : controller.createDelivery(
                          //         entity.addressId, entity.id, entity.userId);
                        },
                        child: Container(
                          width: fullWidth,
                          padding: EdgeInsets.symmetric(vertical: smallSize),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(smallRadius)),
                          child: Center(
                            child: Text(
                              'ثبت سفارش',
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
              SizedBox(
                width: standardSize,
              ),
              Expanded(
                child: Material(
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
                          Get.to(DriverDetailPage(
                            entity: entity,
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
          SizedBox(height: xSmallSize),
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
/*

typedef RequestBody = Map<String, dynamic>;

void main() async{
  do{
    stdout.write('Say someting: ');
    final line = stdout.readLineSync(encoding:utf8);
    switch(line?.trim().toLowerCase()){
      case null:
        continue;
      case 'exit':
        exit(0);
      default:
        final msg = await getMessage(line!);
        print(msg);

    }

  }while(true);
}
Future<String> getMessage(String forGreeting)async{
  final rp = ReceivePort();
  Isolate.spawn(_communicator,rp.sendPort,
  );
  final brodCastRp = rp.asBroadcastStream();
  final SendPort cummunitactorSendPort = await brodCastRp.first;
  cummunitactorSendPort.send(forGreeting );
  return brodCastRp.takeWhile((e)=>e is String).cast<String>().take(1).first;
}

void _communicator(SendPort sp)async{
  final rp = ReceivePort();
  sp.send(rp);
  final messages = rp.takeWhile((e)=>e is String).cast<String>();
  await for(final message in messages){
    for(final entry in messagesAndResponse.entries){
      if(entry.key.trim().toLowerCase()== message.trim().toLowerCase()){
        sp.send(entry.value);
        continue;

      }
    }
    sp.send('i have no response to that!');
  }

}
const messagesAndResponse={
  '':'Ask me a question like "How are you?"',
  'Hello' : 'Hi',
  'How are your?' : 'Fine',
  'what are you doing?' : 'Learning about Isolates in Dart!',
  'Are you having fun' : 'Yeah sure!',

};*/
