// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../../domain/entities/sec/address_entity.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/animations/slide_transtion.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../controller/address_controller.dart';
import '../widget/bottom_sheet_remove_address.dart';

class AddressesPage extends GetResponsiveView<AddressesController> {
  AddressesPage({Key? key}) : super(key: key);
  var theme = Get.theme;
  var context = Get.context!;

  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchData(isFromLocal: true);
    //     },
    //     builder: (_) {
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                centerTitle: false,
                title: Text(
                  'آدرس های منتخب',
                  style: theme.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: a/80),
                  Expanded(
                    child: NotificationListener(
                      onNotification:
                          (OverscrollIndicatorNotification overScroll) {
                        overScroll.disallowIndicator();
                        return true;
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          GestureDetector(
                            // onTap: () {
                            //   sheetMap(context, false);
                            // },
                            child: Container(
                              width: a,
                              height: b / 8,
                              // padding: EdgeInsetsDirectional.all(a/24),
                              margin: EdgeInsetsDirectional.only(
                                  top: a/100 / 1.4,
                                  start: a/100,
                                  end: a/100),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: theme.primaryColor),
                                  color: theme.primaryColor.withOpacity(0.11),
                                  borderRadius:
                                      BorderRadius.circular(a/100 / 2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: EdgeInsetsDirectional.only(
                                          end: a/100 / 1.5),
                                      child: Icon(
                                        Icons.add,
                                        color: theme.primaryColor,
                                        size: a/100 / 2.1,
                                      )),
                                  Text(
                                    'اضافه کردن آدرس جدید',
                                    style: theme.textTheme.bodyText1!
                                        .copyWith(color: theme.primaryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          controller.obx(
                            (state) => ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.only(
                                  top: a/100,
                                  start: a/100,
                                  end: a/100,
                                ),
                                itemCount: controller.pref.addresses.length,
                                itemBuilder: (context, index) =>
                                    _fromCartWeb(context, index)),
                            onEmpty: Container(margin: EdgeInsets.only(top: a/24),child: emptyWidget('آدرسی وجـود نـدارد',isDesktop: true)),
                            onLoading: loadingWidget(),
                            onError: (error) => errorWidget(error.toString(),
                                onTap: () => controller.fetchData()),
                          ),
                          SizedBox(
                            height: a/24,
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ));
        // });
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchData(isFromLocal: true);
    //     },
    //     builder: (_) {
          return Scaffold(
              backgroundColor: AppColors.homeBackgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                shadowColor: AppColors.shadowColor.withOpacity(0.2),
                elevation: 15,
                centerTitle: true,
                leading: backIcon(iconColor: Colors.black),
                // toolbarHeight: kToolbarHeight * 1.5,
                title: Container(
                  margin: EdgeInsetsDirectional.only(top: a/60),
                  child: Text(
                    'آدرس',
                    style: theme.textTheme.subtitle1!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: a/24),
                  Expanded(
                    child: NotificationListener(
                      onNotification:
                          (OverscrollIndicatorNotification overScroll) {
                        overScroll.disallowIndicator();
                        return true;
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          SlideFadeTranstion(
                            direction: Direction.horizontal,
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: GestureDetector(
                              onTap: () {
                                sheetMap(context, false);
                                // String? result = await
                                // Get.to(AddAddressPage());
                                // if (result != null) {
                                //   controller.fetchData();
                                // }
                              },
                              child: Container(
                                width: a,
                                height: a / 7,
                                // padding: EdgeInsetsDirectional.all(a/24),
                                margin: EdgeInsetsDirectional.only(
                                    top: a/24,
                                    start: a/24,
                                    end: a/24,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: theme.primaryColor),
                                    color: theme.primaryColor.withOpacity(0.11),
                                    borderRadius:
                                        BorderRadius.circular(a/60)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: EdgeInsetsDirectional.only(
                                            end: a/100),
                                        child: Icon(
                                          Icons.add,
                                          color: theme.primaryColor,
                                        )),
                                    Text(
                                      'اضافه کردن آدرس جدید',
                                      style: theme.textTheme.subtitle1!
                                          .copyWith(color: theme.primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          controller.obx(
                            (state) => ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.only(
                                  top: a/20,
                                  start: a/24,
                                  end: a/24,
                                ),
                                itemCount: controller.pref.addresses.length,
                                itemBuilder: (context, index) =>
                                    _addressCard(context, index)),
                            onEmpty: emptyWidget('آدرسی وجـود نـدارد'),
                            onLoading: loadingWidget(),
                            onError: (error) => errorWidget(error.toString(),
                                onTap: () => controller.fetchData()),
                          ),
                          SizedBox(
                            height: a/24,
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ));
        // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchData(isFromLocal: true);
    //     },
    //     builder: (_) {
          return Scaffold(
              backgroundColor: AppColors.homeBackgroundColor,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                shadowColor: AppColors.shadowColor.withOpacity(0.2),
                elevation: 15,
                centerTitle: true,
                leading: backIcon(iconColor: Colors.black),
                // toolbarHeight: kToolbarHeight * 1.5,
                title: Container(
                  margin: EdgeInsetsDirectional.only(top: a/60),
                  child: Text(
                    'آدرس',
                    style: theme.textTheme.subtitle1!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: a/24),
                  Expanded(
                    child: NotificationListener(
                      onNotification:
                          (OverscrollIndicatorNotification overScroll) {
                        overScroll.disallowIndicator();
                        return true;
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          SlideFadeTranstion(
                            direction: Direction.horizontal,
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: GestureDetector(
                              onTap: () {
                                sheetMap(context, false);
                                // String? result = await
                                // Get.to(AddAddressPage());
                                // if (result != null) {
                                //   controller.fetchData();
                                // }
                              },
                              child: Container(
                                width: a,
                                height: a / 7,
                                // padding: EdgeInsetsDirectional.all(a/24),
                                margin: EdgeInsetsDirectional.only(
                                    top: a/24,
                                    start: a/24,
                                    end: a/24,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: theme.primaryColor),
                                    color: theme.primaryColor.withOpacity(0.11),
                                    borderRadius:
                                        BorderRadius.circular(a/60)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: EdgeInsetsDirectional.only(
                                            end: a/100),
                                        child: Icon(
                                          Icons.add,
                                          color: theme.primaryColor,
                                        )),
                                    Text(
                                      'اضافه کردن آدرس جدید',
                                      style: theme.textTheme.subtitle1!
                                          .copyWith(color: theme.primaryColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          controller.obx(
                            (state) => ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.only(
                                  top: a/20,
                                  start: a/24,
                                  end: a/24,
                                ),
                                itemCount: controller.pref.addresses.length,
                                itemBuilder: (context, index) =>
                                    _addressCard(context, index)),
                            onEmpty: emptyWidget('آدرسی وجـود نـدارد'),
                            onLoading: loadingWidget(),
                            onError: (error) => errorWidget(error.toString(),
                                onTap: () => controller.fetchData()),
                          ),
                          SizedBox(
                            height: a/24,
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ));
        // });
  }

  Widget _addressCard(BuildContext context, int index) {
    return SlideFadeTranstion(
        direction: Direction.horizontal,
        animationDuration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        child: _fromCart(context, index));
  }

  Widget _fromCart(BuildContext context, int index) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: GestureDetector(
            onTap: () {
              removeAddressSheet(
                  context, controller.pref.addresses[index], index);
            },
            child: Container(
                width: a / 5,
                margin: EdgeInsetsDirectional.only(
                  top: a/24 / 2,
                  bottom: a/24 / 2,
                  start: a/24,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.errorColor),
                  borderRadius: BorderRadiusDirectional.circular(a/24),
                  color: theme.errorColor.withOpacity(0.09),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset('assets/trash.svg',
                          width: a/40,
                          height: a/40,
                          color: theme.errorColor),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: a/60),
                      child: Text(
                        'حذف',
                        style: theme.textTheme.caption!.copyWith(
                            color: theme.errorColor,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )),
          ),
          children: const []),
      child: Container(
          width: a,
          margin: EdgeInsetsDirectional.only(
            bottom: a/24 / 2,
            top: a/24 / 2,
          ),
          padding: EdgeInsetsDirectional.only(
              start: a/24 * 1.4,
              end: a/24,
              top: a/24,
              bottom: a/24),
          // decoration: BoxDecoration(
          //     border: Border.all(
          //         width: 1, color: theme.primaryColor),
          //     color:
          //     theme.primaryColor.withOpacity(0.11),
          //     borderRadius:
          //     BorderRadius.circular(a/24)),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 2),
                    color: const Color(0xff10548B).withOpacity(0.04),
                    blurRadius: 5,
                    blurStyle: BlurStyle.normal,
                    spreadRadius: 4)
              ],
              borderRadius: BorderRadiusDirectional.circular(a/24)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'آدرس:',
                    style: theme.textTheme.bodyText1!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  Container(
                    margin: EdgeInsetsDirectional.only(top: a/60),
                    child: Row(
                      children: [
                        SizedBox(
                          width: a / 1.6,
                          child: Text(
                            '${controller.pref.addresses[index].address}، ${controller.pref.addresses[index].description}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: theme.textTheme.bodyText2!.copyWith(
                                color: AppColors.captionTextColor,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      addAddressSheet(context, true,
                          entity: controller.pref.addresses[index]);
                    },
                    child: Container(
                      margin: EdgeInsetsDirectional.only(top: a/60),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsetsDirectional.only(end: a/80),
                            child: SvgPicture.asset(
                              'assets/edit_2.svg',
                              width: a/80,
                              height: a/80,
                              color: theme.primaryColor,
                            ),
                          ),
                          Text(
                            'تغییر آدرس',
                            style: theme.textTheme.subtitle2!.copyWith(
                              color: theme.primaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _fromCartWeb(BuildContext context, int index) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    return Container(
        width: a,
        margin: EdgeInsetsDirectional.only(
          bottom: a/80 / 2.5,
          top: a/80 / 3,
        ),
        padding: EdgeInsetsDirectional.only(
            start: a/80/1.5,
            end: a/80/1.5,
            top: a/80/1.7,
            bottom: a/80/1.7),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 2),
                  color: const Color(0xff10548B).withOpacity(0.04),
                  blurRadius: 5,
                  blurStyle: BlurStyle.normal,
                  spreadRadius: 4)
            ],
            borderRadius:
              BorderRadiusDirectional.circular(a/100/2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آدرس:',
              style: theme.textTheme.bodyText1!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: a/100/1.6),
            Text(
              '${controller.pref.addresses[index].address}، ${controller.pref.addresses[index].description}',
              style: theme.textTheme.bodyText2!.copyWith(
                  color: AppColors.captionTextColor,
                  fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              onTap: () async {
                // addAddressSheet(context, true,
                //     entity: controller.pref.addresses[index]);
              },
              child: Container(
                margin: EdgeInsetsDirectional.only(top: a/100),
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsetsDirectional.only(end: a/100/1.3),
                          child: SvgPicture.asset(
                            'assets/edit_2.svg',
                            width: a/100/2.3,
                            height: a/100/2.3,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          'تغییر آدرس',
                          style: theme.textTheme.subtitle2!.copyWith(
                            color: theme.primaryColor,
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(start: a/80/1.8),
                      child: GestureDetector(
                        onTap: () => removeAddressDialog(
                            context, controller.pref.addresses[index], index),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsetsDirectional.only(end: a/100/1.3),
                              child: Center(
                                child: SvgPicture.asset('assets/trash.svg',
                                    width: a/100/2.3,
                                    height: a/100/2.3,
                                    color: theme.errorColor),
                              ),
                            ),
                            Text(
                              'حذف',
                              style: theme.textTheme.caption!.copyWith(
                                  color: theme.errorColor,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  void sheetMap(BuildContext context, bool isEdit, {AddressEntity? entity}) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (context) {
          Future<bool> onBackClicked(BuildContext context) async {
            closeKeyboard(context);
            controller.clearTxtField();
            Get.back();
            return Future.value(true);
          }

          // controller.update();
          return WillPopScope(
            onWillPop: () => onBackClicked(context),
            child:
            // GetBuilder(
            //     init: controller,
            //     builder: (_) {
                  // controller.controller = PickerMapController(
                  //   // initPosition:GeoPoint(latitude: 34,longitude: 36),
                  //   initMapWithUserPosition: true,
                  // );
                  // lat = double.parse(pref.lawyer.profile!.lat);
                  // long = double.parse(pref.lawyer.profile!.long?? '');
                  // debugPrint('${lat} asda');
                  // controller.pickerController = PickerMapController();
                  // controller.mapController = MapController(
                  //     initPosition: controller.geoPoint,
                  //     initMapWithUserPosition: true
                  //     );
                   Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(a/20),
                            topLeft: Radius.circular(a/20)),
                        color: theme.backgroundColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: a/100),
                        Container(
                          margin: EdgeInsetsDirectional.only(
                              start: a/60, end: a/100),
                          padding: EdgeInsetsDirectional.all(a/60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ایجاد آدرس',
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Get.back();
                                    controller.clearTxtField();
                                  },
                                  borderRadius:
                                      BorderRadius.circular(a/12 * 4),
                                  splashColor: AppColors.splashColor,
                                  child: Padding(
                                      padding: EdgeInsets.all(a/80),
                                      child: SvgPicture.asset(
                                          'assets/ic_cancel.svg')),
                                ),
                              )
                            ],
                          ),
                        ),
                        // SizedBox(height: a/24),
                        // SizedBox(
                        //   height: b / 2,
                        //   child: CustomPickerLocation(
                        //     bottomWidgetPicker: PositionedDirectional(
                        //       bottom: a/24,
                        //       start: a/60,
                        //       child: Container(
                        //         margin: EdgeInsetsDirectional.only(
                        //             start: a/24),
                        //         child: FloatingActionButton(
                        //           mini: true,
                        //           child: const Icon(Icons.location_on),
                        //           onPressed: () async {
                        //             // =    PickerMapController(
                        //             //   initPosition: lawyerLicenseInfoController.geoPoint,
                        //             //   initMapWithUserPosition: true,
                        //             // );
                        //             GeoPoint geoPoint = await controller
                        //                 .controller.osmBaseController
                        //                 .myLocation();
                        //             debugPrint(
                        //                 '${controller.controller.osmBaseController.myLocation()} asda');
                        //             controller.controller
                        //                 .goToLocation(geoPoint);
                        //
                        //             await controller
                        //                 .controller.osmBaseController
                        //                 .changeLocation(geoPoint);
                        //             await controller
                        //                 .controller.osmBaseController
                        //                 .setZoom(stepZoom: 3);
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //     controller: controller.controller,
                        //     pickerConfig: CustomPickerLocationConfig(
                        //       initZoom: 16,
                        //       minZoomLevel: 6,
                        //       maxZoomLevel: 18,
                        //       stepZoom: 1.0,
                        //       advancedMarkerPicker: MarkerIcon(
                        //         iconWidget: Icon(
                        //           Icons.location_on,
                        //           color: Colors.red,
                        //           size: iconSizeLarge * 4,
                        //         ),
                        //         // icon:Icon(Icons.access_alarm) ,
                        //         // assetMarker: AssetMarker(scaleAssetImage: 12,
                        //         // image: AssetImage('assets/avatar.JPG')),
                        //         // SvgPicture.asset("assets/ic_location_bold.svg",
                        //         //     width: a/4, height: a/4),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: a/24),
                        // Container(
                        //     padding: EdgeInsetsDirectional.all(a/24),
                        //     child: Container(
                        //       alignment: Alignment.center,
                        //       height: kBottomNavigationBarHeight,
                        //       child: progressButton(
                        //           text: 'انتخاب',
                        //           onTap: () async {
                        //             Get.back();
                        //             GeoPoint a = await controller.controller
                        //                 .getCurrentPositionAdvancedPositionPicker();
                        //             controller.geoPoint = a;
                        //             if (isEdit == true) {
                        //               entity?.latitude = a.latitude;
                        //               entity?.longitude = a.longitude;
                        //             }
                        //             addAddressSheet(context, isEdit,
                        //                 entity: entity);
                        //           },
                        //           isProgress: false,
                        //           hasBorder: false,
                        //           isDisable: false),
                        //     ))
                        // progressButton(
                        //   text: 'ثبت درخواست',
                        //   isProgress: false.obs,
                        //   onTap: () {
                        //     Get.back();
                        //   },
                        // ),
                      ],
                    ),
                  )
                // }),
          );
        });
  }

  void addAddressSheet(BuildContext context, bool isEdit,
      {AddressEntity? entity}) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // controller.mapController = MapController(
    //     initPosition: GeoPoint(
    //         latitude: entity?.latitude ?? controller.geoPoint?.latitude ?? 0,
    //         longitude:
    //             entity?.longitude ?? controller.geoPoint?.longitude ?? 0),
    //     initMapWithUserPosition: false);
    bool isFirstLunch = true;
    controller.addressTxt.value =
        entity?.address.isNotEmpty ?? false ? '${entity?.address.trim()} ' : '';
    controller.addressInfoTxt.value = entity?.description.isNotEmpty ?? false
        ? '${entity?.description.trim()} '
        : '';
    controller.addressTypeTxt.value =
        entity?.title?.isNotEmpty ?? false ? '${entity?.title?.trim()} ' : '';
    controller.phoneNumberTxt.value = entity?.phoneNumber.isNotEmpty ?? false
        ? '${entity?.phoneNumber.trim()} '
        : '';
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          Future<bool> onBackClicked(BuildContext context) async {
            closeKeyboard(context);
            controller.clearTxtField();
            Get.back();
            return Future.value(true);
          }

          // controller.update();
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: WillPopScope(
              onWillPop: () => onBackClicked(context),
              child: GetBuilder(
                  init: controller,
                  initState: (state) {
                    if (isEdit && isFirstLunch) {
                      controller.addressController.text =
                          entity?.address.trim() ?? '';
                      controller.phoneController.text =
                          entity?.phoneNumber.trim() ?? '';
                      controller.addressInfoController.text =
                          entity?.description.trim() ?? '';
                      controller.addressTitleController.text =
                          entity?.title?.trim() ?? '';
                      // controller.isDisable.value = false;

                      isFirstLunch = false;
                    }
                  },
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {
                        closeKeyboard(context);
                      },
                      child: Container(
                        height: b / 1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(a/20),
                                topLeft: Radius.circular(a/20)),
                            color: theme.backgroundColor),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              right: 0,
                              left: 0,
                              top: 0,
                              bottom: kBottomNavigationBarHeight + a/16,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: a/100),
                                    Container(
                                      alignment: AlignmentDirectional.centerEnd,
                                      margin: EdgeInsetsDirectional.only(
                                          start: a/60, end: a/100),
                                      padding:
                                          EdgeInsetsDirectional.all(a/60),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Get.back();
                                            controller.clearTxtField();
                                          },
                                          borderRadius: BorderRadius.circular(
                                              a/12 * 4),
                                          splashColor: AppColors.splashColor,
                                          child: Padding(
                                              padding:
                                                  EdgeInsets.all(a/80),
                                              child: SvgPicture.asset(
                                                  'assets/ic_cancel.svg')),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(height: a/24),
                                    SizedBox(
                                      height: b / 4.5,
                                      child: Stack(
                                        children: [
                                          // Positioned.fill(
                                          //   child: OSMFlutter(
                                          //     controller:
                                          //         controller.mapController,
                                          //     trackMyPosition: false,
                                          //     initZoom: 16,
                                          //     minZoomLevel: 16,
                                          //     isPicker: true,
                                          //     maxZoomLevel: 16,
                                          //     stepZoom: 1.0,
                                          //     onMapIsReady: (p0) {
                                          //       controller.mapController
                                          //           .addMarker(GeoPoint(
                                          //               latitude: controller
                                          //                       .geoPoint
                                          //                       ?.latitude ??
                                          //                   0,
                                          //               longitude: controller
                                          //                       .geoPoint
                                          //                       ?.longitude ??
                                          //                   0));
                                          //     },
                                          //     userLocationMarker:
                                          //         UserLocationMaker(
                                          //       personMarker: const MarkerIcon(
                                          //         icon: Icon(
                                          //           Icons.location_on,
                                          //           color: Colors.red,
                                          //           size: 55,
                                          //         ),
                                          //       ),
                                          //       directionArrowMarker:
                                          //           const MarkerIcon(
                                          //         icon: Icon(
                                          //           Icons.double_arrow,
                                          //           size: 48,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          PositionedDirectional(
                                            bottom: a/60,
                                            start: 0,
                                            child: Container(
                                                child: GestureDetector(
                                              onTap: () {
                                                Get.back();
                                                sheetMap(context, true,
                                                    entity: entity);
                                              },
                                              child: Container(
                                                // padding: EdgeInsetsDirectional.all(a/24),
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        top: a/24,
                                                        start: a/24,
                                                        end: a/24,
                                                        bottom: 0),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: a/80,
                                                    horizontal: a/80),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color:
                                                            theme.primaryColor),
                                                    color:
                                                        const Color(0xffF1FCDA),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            a/60)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsetsDirectional
                                                            .only(
                                                                end:
                                                                    a/100),
                                                        child: SvgPicture.asset(
                                                          'assets/edit_2.svg',
                                                          color: theme
                                                              .primaryColor,
                                                        )),
                                                    Text(
                                                      'ویرایش موقعیت',
                                                      style: theme
                                                          .textTheme.subtitle2!
                                                          .copyWith(
                                                              color: theme
                                                                  .primaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: a/60),
                                    Form(
                                      key: controller.formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsetsDirectional.only(
                                                start: a/24,
                                                end: a/24,
                                                top: a/24),
                                            child: TextFormFieldWidget(
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'لطفا فیلد آدرس را پر کنید'
                                                      .tr;
                                                }
                                                return null;
                                              },
                                              padding:
                                                  EdgeInsetsDirectional.all(
                                                      a/60),
                                              label: "نشانی",
                                              onChange: (value) {
                                                controller.addressTxt.value =
                                                    value;
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              textEditingController:
                                                  controller.addressController,
                                              hint: 'مثال: مشهد، قاسم آباد',
                                              // onTap: () {
                                              //   '${controller.addressController.text.trim()} ';
                                              //   debugPrint('sadasd');
                                              // },
                                            ),
                                          ),
                                          SizedBox(height: a/60),
                                          Container(
                                            margin: EdgeInsetsDirectional.only(
                                                start: a/24,
                                                end: a/24,
                                                top: a/24),
                                            child: TextFormFieldWidget(
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'لطفا فیلد جزئیات را پر کنید';
                                                }
                                                return null;
                                              },
                                              padding:
                                                  EdgeInsetsDirectional.all(
                                                      a/60),
                                              label: "جزئیات",
                                              onChange: (value) {
                                                controller.addressInfoTxt
                                                    .value = value;
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.text,
                                              textEditingController: controller
                                                  .addressInfoController,
                                              hint: 'مثال: پلاک3، واحد4',
                                            ),
                                          ),
                                          SizedBox(height: a/60),
                                          Container(
                                            margin: EdgeInsetsDirectional.only(
                                                start: a/24,
                                                end: a/24,
                                                top: a/24),
                                            child: TextFormFieldWidget(
                                              onChange: (value) {
                                                controller.addressTypeTxt
                                                    .value = value;
                                              },
                                              padding:
                                                  EdgeInsetsDirectional.all(
                                                      a/60),
                                              label: "عنوان آدرس",
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'لطفا فیلد عنوان آدرس را پر کنید';
                                                }
                                                return null;
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              textEditingController: controller
                                                  .addressTitleController,
                                              hint: 'مثال: خانه',
                                            ),
                                          ),
                                          SizedBox(height: a/60),
                                          Container(
                                            margin: EdgeInsetsDirectional.only(
                                                start: a/24,
                                                end: a/24,
                                                top: a/24),
                                            child: TextFormFieldWidget(
                                              // onFieldSubmitted: (value) =>
                                              //     FocusScope.of(context).nextFocus(),
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return 'لطفا فیلد شماره تلفن را پر کنید';
                                                } else if (value!.length < 10 &&
                                                    !value.startsWith('09')) {
                                                  return 'شماره تلفن مجاز نیست';
                                                }
                                                return null;
                                              },
                                              onChange: (value) => controller
                                                  .phoneNumberTxt.value = value,
                                              padding:
                                                  EdgeInsetsDirectional.all(
                                                      a/60),
                                              label: "شماره تماس",
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: TextInputType.phone,
                                              textEditingController:
                                                  controller.phoneController,
                                              hint: 'مثال: ۰۹۱۲۳۴۵۶۷۸۹',
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: Obx(() {
                                  return Container(
                                      padding: EdgeInsetsDirectional.all(
                                          a/24),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: kBottomNavigationBarHeight,
                                        child: progressButton(
                                            text: 'تاییـد آدرس',
                                            onTap: () {
                                              if (controller
                                                  .formKey.currentState!
                                                  .validate()) {
                                                if (isEdit) {
                                                  controller.updateAddress(
                                                      context: context,
                                                      id: entity?.id ?? 0);
                                                } else {
                                                  controller.addAddress(
                                                      context: context);
                                                }
                                                controller.update();
                                              }
                                            },
                                            isProgress:
                                                controller.isBusyAdd.value,
                                            hasBorder: false,
                                            isDisable:
                                                controller.addressTxt.value !=
                                                            '' &&
                                                        controller
                                                                .addressInfoTxt
                                                                .value !=
                                                            '' &&
                                                        controller
                                                                .addressTypeTxt
                                                                .value !=
                                                            '' &&
                                                        controller
                                                                .phoneNumberTxt
                                                                .value !=
                                                            ''
                                                    ? false
                                                    : true),
                                      ));
                                }))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
