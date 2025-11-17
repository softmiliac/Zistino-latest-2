// ignore_for_file: must_be_immutable

import 'package:admin_dashboard/src/presentation/ui/base/main_page/view/main_page.dart';
import 'package:admin_dashboard/src/presentation/ui/map_page/controller/map_controller.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import '../../../../domain/entities/inv/time_box.dart';
import '../../../style/dimens.dart';
import '../../../widgets/back_widget.dart';
import '../../../widgets/progress_button.dart';
import '../../base/residue_price_page/binding/binding.dart';
import '../../inv/residue_page/binding/binding.dart';
import '../binding/map_binding.dart';
import '../widgets/add_address_widget.dart';
import '../widgets/address_list.dart';

class MapPage extends GetResponsiveView<MyMapController> {
  MapPage({super.key});

  // @override
  // State<StatefulWidget> createState() => _LocationAppExampleState();
// }

// class _LocationAppExampleState extends State<MapPage> {
  /// Variables ///
  final theme = Get.theme;
  RxBool isTapped = false.obs;

  /// Instances ///
  // controller controller = Get.find();

  /// Futures ///
  Future<bool> onBackClicked() {
    Get.
    off(MainPage());
    // controller.selectedDay.value = DayBox(date: DateTime.now(),text: 'امروز');
    // Get.off(LawyerLicenseInfoPage());
    // controller.selectedHour.value = null;// Get.off(LawyerLicenseInfoPage());
    return Future.value(false);
  }


  @override
  Widget phone() {
    return Container(color: Colors.red,width: 200,height: 200,);
  }


  @override
  Widget tablet() {
    return Container(color: Colors.blue,width: 555,height: 200,);

  }


  @override
  Widget desktop() {
    return Container(color: Colors.yellow,width: 1000,height: 600,);

  } // @override
  // void initState() {
  //   super.initState();
  // }


/*
  @override
  Widget build(BuildContext context) {


    // MapBinding().dependencies();

    // controller.addressController.text = '${controller.txtTextField.trim()} ';
    return
      GetBuilder<MyMapController>(
      init: controller,
      // initState: (state) =>
      // controller.controller = PickerMapController(
        // initPosition:GeoPoint(latitude: 34,longitude: 36),
        // initMapWithUserPosition: true,
      // ),

      builder: (_) {
        return Container();

        */
/* WillPopScope(
          onWillPop: onBackClicked,
          child: Scaffold(
            body: CustomPickerLocation(
              controller: controller.controller,
              appBarPicker: AppBar(

                title: Text(
                  'انتخاب آدرس و زمان',
                  style: theme.textTheme.subtitle1,
                ),
                backgroundColor: Colors.white,
                // leading:
                // const Icon(
                //   Icons.arrow_back,
                //   color: Colors.black,
                // ),
                leading: backIcon(onTap: onBackClicked),
              ),
              bottomWidgetPicker: Positioned(
                bottom: standardSize,
                right: 0,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      margin: EdgeInsetsDirectional.only(start: standardSize),
                      child: FloatingActionButton(
                        mini: true,
                        child: const Icon(Icons.location_on),
                        onPressed: () async {
                          // =    PickerMapController(
                          //   initPosition: lawyerLicenseInfoController.geoPoint,
                          //   initMapWithUserPosition: true,
                          // );
                          GeoPoint geoPoint =
                              await controller.controller.osmBaseController.myLocation();
                          debugPrint(
                              '${controller.controller.osmBaseController.myLocation()} asda');
                          controller.controller.goToLocation(geoPoint);

                          await controller.controller.osmBaseController
                              .changeLocation(geoPoint);
                          await controller.controller.osmBaseController.setZoom(stepZoom: 3);
                        },
                      ),
                    ),
                    SizedBox(
                      height: xxSmallSize,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: standardSize,
                      ),
                      child: progressButton(
                        isDisable: false,
                        onTap: () async {
                          // controller.lat = controller.controller.initPosition?.latitude;
                          // controller.long = controller.controller.initPosition?.longitude;

                          GeoPoint a = await controller.controller
                              .getCurrentPositionAdvancedPositionPicker();
                          controller.geoPoint = a;
                          // controller.controller =    controller.controller = PickerMapController(
                          //   // initPosition:GeoPoint(latitude: 34,longitude: 36),
                          //   initMapWithUserPosition: true,
                          // );

                          addAddressSheet(context);
                        },
                        // async {
                        //   var a = await controller
                        //       .getCurrentPositionAdvancedPositionPicker();
                        //   Get.back(result: a);
                        // },
                        text: "اضافه کردن آدرس جدید",
                        isProgress: false,
                      ),
                    ),
                    SizedBox(height: smallSize,),

                   controller.pref.addresses.isEmpty ? const SizedBox() :  addressList(),

                  ],
                ),
              ),
              pickerConfig: CustomPickerLocationConfig(
                initZoom: 16,
                minZoomLevel: 6,
                maxZoomLevel: 18,
                stepZoom: 1.0,


                advancedMarkerPicker: MarkerIcon(
                  iconWidget: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: iconSizeLarge * 4,
                  ),
                  // icon:Icon(Icons.access_alarm) ,
                  // assetMarker: AssetMarker(scaleAssetImage: 12,
                  // image: AssetImage('assets/avatar.JPG')),
                  // SvgPicture.asset("assets/ic_location_bold.svg",
                  //     width: fullWidth/4, height: fullWidth/4),
                ),
              ),
            ),
          ),
        );*//*

      }
    );
  }
*/

  void dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Stack(
        children: [
          AlertDialog(
            title: Container(
                margin: EdgeInsetsDirectional.only(
                    top: standardSize, bottom: standardSize),
                child: Text(
                  'لطفا جزییات آدرس،مانند خیابان،کوچه،پلاک و...را برای مسیریابی بهتر راننده وارد نمایید',
                  style: theme.textTheme.subtitle2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            titleTextStyle: theme.textTheme.subtitle2,
            contentPadding: EdgeInsetsDirectional.only(
                top: 0, bottom: 0, start: standardSize, end: standardSize),
            content: Container(
              padding: EdgeInsetsDirectional.all(xSmallSize),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(xSmallRadius),
                  border: Border.all(
                      color: Colors.black.withOpacity(0.2), width: 1)),
              child: Text(
                'منطقه 6 ،محله چهنو،بلوار چمن،چمن 44 ،شیرودی 12،ایستگاه چهارراه راهنمایی',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.subtitle2!
                    .copyWith(color: Colors.black.withOpacity(0.5)),
              ),
              // TextFormFieldEditProfileWidget(
              //   padding: EdgeInsetsDirectional.only(top: xSmallSize,bottom: xSmallSize,start: xSmallSize,end: xSmallSize),
              //   maxLine: 3,
              //   hint: 'آدرس خود را وارد کنید...',
              //   textEditingController: controller.addressController,
              // ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                        // sheetSelectTime(context);
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.only(start: smallSize),
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius: BorderRadius.circular(xSmallRadius)),
                        width: fullWidth / 2,
                        padding: EdgeInsetsDirectional.all(standardSize / 1.2),
                        child: Text(
                          'تایید',
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.all(smallSize),
                        padding: EdgeInsetsDirectional.all(standardSize / 1.2),
                        decoration: BoxDecoration(
                            border:
                            Border.all(color: theme.primaryColor, width: 1),
                            borderRadius: BorderRadius.circular(xSmallRadius)),
                        width: fullWidth / 3,
                        child: Text(
                          'انصراف',
                          style: theme.textTheme.subtitle2!
                              .copyWith(color: theme.primaryColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
/*
          Align(
            alignment: const Alignment(0, -0.35),
            child: Container(
              padding:
              EdgeInsetsDirectional.only(top: smallSize, bottom: smallSize),
              width: fullWidth / 1.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: -1,
                        blurRadius: 10),
                  ],
                  borderRadius: BorderRadius.circular(smallRadius)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map, color: Colors.blue),
                  SizedBox(width: xxSmallSize),
                  Text(
                    'جزییات آدرس',
                    style: theme.textTheme.subtitle1,
                  )
                ],
              ),
            ),
          ),
*/
        ],
      ),
    );
  }



}
