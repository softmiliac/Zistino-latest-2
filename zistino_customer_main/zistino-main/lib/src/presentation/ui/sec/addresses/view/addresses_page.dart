// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../../domain/entities/sec/address_entity.dart';
import '../../../../../domain/entities/sec/zone_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/animations/slide_transtion.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../controller/address_controller.dart';
import '../widget/bottom_sheet_remove_address.dart';

class AddressesPage extends GetView<AddressesController> {
  AddressesPage({Key? key}) : super(key: key);
  var theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        initState: (state) {
          controller.fetchData(isFromLocal: true);
        },
        builder: (_) {
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
                  margin: EdgeInsetsDirectional.only(top: smallSize),
                  child: Text(
                    'آدرس',
                    style: theme.textTheme.subtitle1!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: standardSize),
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
                                width: fullWidth,
                                height: fullWidth / 7,
                                // padding: EdgeInsetsDirectional.all(standardSize),
                                margin: EdgeInsetsDirectional.only(
                                    top: standardSize,
                                    start: standardSize,
                                    end: standardSize,
                                    bottom: 0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: theme.primaryColor),
                                    color: theme.primaryColor.withOpacity(0.11),
                                    borderRadius:
                                        BorderRadius.circular(smallRadius)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        margin: EdgeInsetsDirectional.only(
                                            end: xxSmallSize),
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
                                  top: largeSize,
                                  start: standardSize,
                                  end: standardSize,
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
                            height: standardSize,
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  Widget _addressCard(BuildContext context, int index) {
    return SlideFadeTranstion(
        direction: Direction.horizontal,
        animationDuration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        child: _fromCart(context, index));
  }

  Widget _fromCart(BuildContext context, int index) {
    return Slidable(
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: GestureDetector(
            onTap: () {
              removeAddressSheet(
                  context, controller.pref.addresses[index], index);
            },
            child: Container(
                width: fullWidth / 5,
                margin: EdgeInsetsDirectional.only(
                  top: standardSize / 2,
                  bottom: standardSize / 2,
                  start: standardSize,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.errorColor),
                  borderRadius: BorderRadiusDirectional.circular(standardSize),
                  color: theme.errorColor.withOpacity(0.09),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset('assets/trash.svg',
                          width: iconSizeMedium,
                          height: iconSizeMedium,
                          color: theme.errorColor),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(top: smallSize),
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
      child: GestureDetector(
        onTap: () {
          addAddressSheet(context, true,
              entity: controller.pref.addresses[index]);
        },
        child: Container(
            width: fullWidth,
            margin: EdgeInsetsDirectional.only(
              bottom: standardSize / 2,
              top: standardSize / 2,
            ),
            padding: EdgeInsetsDirectional.only(
                start: standardSize * 1.4,
                end: standardSize,
                top: standardSize,
                bottom: standardSize),
            // decoration: BoxDecoration(
            //     border: Border.all(
            //         width: 1, color: theme.primaryColor),
            //     color:
            //     theme.primaryColor.withOpacity(0.11),
            //     borderRadius:
            //     BorderRadius.circular(standardSize)),
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
                borderRadius: BorderRadiusDirectional.circular(standardSize)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'آدرس:',
                      style: theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${controller.pref.addresses[index].address} - ${controller.pref.addresses[index].description}',
                      style: theme.textTheme.bodyText2!.copyWith(
                          color: AppColors.captionTextColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(top: smallSize),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(end: xSmallSize),
                        child: SvgPicture.asset(
                          'assets/edit_2.svg',
                          width: iconSizeXSmall,
                          height: iconSizeXSmall,
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
              ],
            )),
      ),
    );
  }

  void sheetMap(BuildContext context, bool isEdit, {AddressEntity? entity}) {
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
            child: GetBuilder(
                init: controller,
                builder: (_) {
                  controller.controller = PickerMapController(
                    // initPosition:GeoPoint(latitude: 34,longitude: 36),
                    initMapWithUserPosition: true,
                  );
                  // lat = double.parse(pref.lawyer.profile!.lat);
                  // long = double.parse(pref.lawyer.profile!.long?? '');
                  // debugPrint('${lat} asda');
                  // controller.pickerController = PickerMapController();
                  // controller.mapController = MapController(
                  //     initPosition: controller.geoPoint,
                  //     initMapWithUserPosition: true
                  //     );
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(largeRadius),
                            topLeft: Radius.circular(largeRadius)),
                        color: theme.backgroundColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: xxSmallSize),
                        Container(
                          margin: EdgeInsetsDirectional.only(
                              start: smallSize, end: xxSmallSize),
                          padding: EdgeInsetsDirectional.all(smallSize),
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
                                      BorderRadius.circular(xxLargeSize * 4),
                                  splashColor: AppColors.splashColor,
                                  child: Padding(
                                      padding: EdgeInsets.all(xSmallSize),
                                      child: SvgPicture.asset(
                                          'assets/ic_cancel.svg')),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: standardSize),
                        SizedBox(
                          height: fullHeight / 2,
                          child: CustomPickerLocation(
                            bottomWidgetPicker: PositionedDirectional(
                              bottom: standardSize,
                              start: smallSize,
                              child: Container(
                                margin: EdgeInsetsDirectional.only(
                                    start: standardSize),
                                child: FloatingActionButton(
                                  mini: true,
                                  child: const Icon(Icons.location_on),
                                  onPressed: () async {
                                    // =    PickerMapController(
                                    //   initPosition: lawyerLicenseInfoController.geoPoint,
                                    //   initMapWithUserPosition: true,
                                    // );
                                    GeoPoint geoPoint = await controller
                                        .controller.osmBaseController
                                        .myLocation();
                                    debugPrint(
                                        '${controller.controller.osmBaseController.myLocation()} asda');
                                    controller.controller
                                        .goToLocation(geoPoint);

                                    await controller
                                        .controller.osmBaseController
                                        .changeLocation(geoPoint);
                                    await controller
                                        .controller.osmBaseController
                                        .setZoom(stepZoom: 3);
                                  },
                                ),
                              ),
                            ),
                            controller: controller.controller,
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
                        SizedBox(height: standardSize),
                        Container(
                            padding: EdgeInsetsDirectional.all(standardSize),
                            child: Container(
                              alignment: Alignment.center,
                              height: kBottomNavigationBarHeight,
                              child: progressButton(
                                  text: 'انتخاب',
                                  onTap: () async {
                                    Get.back();
                                    GeoPoint a = await controller.controller
                                        .getCurrentPositionAdvancedPositionPicker();
                                    controller.geoPoint = a;
                                    if (isEdit == true) {
                                      entity?.latitude = a.latitude;
                                      entity?.longitude = a.longitude;
                                    }
                                    addAddressSheet(context, isEdit,
                                        entity: entity);
                                  },
                                  isProgress: false,
                                  hasBorder: false,
                                  isDisable: false),
                            )),
                        // progressButton(
                        //   text: 'ثبت درخواست',
                        //   isProgress: false.obs,
                        //   onTap: () {
                        //     Get.back();
                        //   },
                        // ),
                      ],
                    ),
                  );
                }),
          );
        });
  }

  void addAddressSheet(BuildContext context, bool isEdit,
      {AddressEntity? entity}) {
    controller.mapController = MapController(
        initPosition: GeoPoint(
            latitude: entity?.latitude ?? controller.geoPoint?.latitude ?? 0,
            longitude:
                entity?.longitude ?? controller.geoPoint?.longitude ?? 0),
        initMapWithUserPosition: false);
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

          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: WillPopScope(
              onWillPop: () => onBackClicked(context),
              child: GetBuilder(
                  init: controller,
                  initState: (state) {
                    controller.pref.zones;
                    if (isEdit && isFirstLunch) {
                      if (entity != null && entity.email.isNotEmpty) {
                        if (controller.pref.zones.isNotEmpty) {
                          controller.idZone = int.parse(entity.email); //todo
                        }
                      }
                      if (controller.pref.zones.isNotEmpty) {
                        ZoneEntity zoneEntity = controller.pref.zones //todo
                            .singleWhere((element) =>
                                element.id == controller.idZone); //todo
                        controller.txtZone = zoneEntity.zone; //todo
                      }
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
                        height: fullHeight / 1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(largeRadius),
                                topLeft: Radius.circular(largeRadius)),
                            color: theme.backgroundColor),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              right: 0,
                              left: 0,
                              top: 0,
                              bottom: kBottomNavigationBarHeight + xLargeSize,
                              child: Column(
                                children: [
                                  Container(
                                    alignment: AlignmentDirectional.centerEnd,
                                    margin: EdgeInsetsDirectional.only(
                                        start: smallSize,
                                        end: xxSmallSize,
                                        top: xxSmallSize),
                                    padding:
                                        EdgeInsetsDirectional.all(smallSize),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Get.back();
                                          controller.clearTxtField();
                                        },
                                        borderRadius: BorderRadius.circular(
                                            xxLargeSize * 4),
                                        splashColor: AppColors.splashColor,
                                        child: Padding(
                                            padding: EdgeInsets.all(xSmallSize),
                                            child: SvgPicture.asset(
                                                'assets/ic_cancel.svg')),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        // SizedBox(height: standardSize),
                                        SizedBox(
                                          height: fullHeight / 4.5,
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: OSMFlutter(
                                                  controller:
                                                      controller.mapController,
                                                  trackMyPosition: false,
                                                  initZoom: 16,
                                                  minZoomLevel: 16,
                                                  isPicker: true,
                                                  maxZoomLevel: 16,
                                                  stepZoom: 1.0,
                                                  onMapIsReady: (p0) {
                                                    controller.mapController
                                                        .addMarker(GeoPoint(
                                                            latitude: controller
                                                                    .geoPoint
                                                                    ?.latitude ??
                                                                0,
                                                            longitude: controller
                                                                    .geoPoint
                                                                    ?.longitude ??
                                                                0));
                                                  },
                                                  userLocationMarker:
                                                      UserLocationMaker(
                                                    personMarker:
                                                        const MarkerIcon(
                                                      icon: Icon(
                                                        Icons.location_on,
                                                        color: Colors.red,
                                                        size: 55,
                                                      ),
                                                    ),
                                                    directionArrowMarker:
                                                        const MarkerIcon(
                                                      icon: Icon(
                                                        Icons.double_arrow,
                                                        size: 48,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              PositionedDirectional(
                                                bottom: smallSize,
                                                start: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Get.back();
                                                    sheetMap(context, true,
                                                        entity: entity);
                                                  },
                                                  child: Container(
                                                    // padding: EdgeInsetsDirectional.all(standardSize),
                                                    margin: EdgeInsetsDirectional
                                                        .only(
                                                            top: standardSize,
                                                            start: standardSize,
                                                            end: standardSize,
                                                            bottom: 0),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                xSmallSize,
                                                            horizontal:
                                                                xSmallSize),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: theme
                                                                .primaryColor),
                                                        color: const Color(
                                                            0xffF1FCDA),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                smallRadius)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsetsDirectional
                                                                .only(
                                                                    end:
                                                                        xxSmallSize),
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/edit_2.svg',
                                                              color: theme
                                                                  .primaryColor,
                                                            )),
                                                        Text(
                                                          'ویرایش موقعیت',
                                                          style: theme.textTheme
                                                              .subtitle2!
                                                              .copyWith(
                                                                  color: theme
                                                                      .primaryColor),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: smallSize),
                                        Form(
                                          key: controller.formKey,
                                          child: Column(
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        start: standardSize,
                                                        end: standardSize,
                                                        top: standardSize),
                                                child: TextFormFieldWidget(
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'لطفا فیلد آدرس را پر کنید'
                                                          .tr;
                                                    }
                                                    return null;
                                                  },
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          smallSize),
                                                  label: "نشانی",
                                                  onChange: (value) {
                                                    controller.addressTxt
                                                        .value = value;
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onTap: () {
                                                    if (controller
                                                        .addressController
                                                        .text
                                                        .isNotEmpty) {
                                                      if (controller
                                                              .addressController
                                                              .text
                                                              .endsWith(' ') ==
                                                          false) {
                                                        controller
                                                                .addressController
                                                                .text =
                                                            '${controller.addressController.text.trim()} ';
                                                      }
                                                    }
                                                  },
                                                  textEditingController:
                                                      controller
                                                          .addressController,
                                                  hint: 'مثال: مشهد، قاسم آباد',
                                                  // onTap: () {
                                                  //   '${controller.addressController.text.trim()} ';
                                                  //   debugPrint('sadasd');
                                                  // },
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        start: standardSize,
                                                        end: standardSize,
                                                        top: standardSize),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: xSmallSize),
                                                      // alignment: Alignment.c,
                                                      child: Text(
                                                        "منطقه",
                                                        style: theme
                                                            .textTheme.caption!
                                                            .copyWith(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: fullWidth,
                                                      height: fullHeight / 17,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  smallSize,
                                                              vertical:
                                                                  smallSize),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .borderColor),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  xSmallRadius)),
                                                      child: Center(
                                                        child: DropdownButton<
                                                            String>(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      smallRadius),
                                                          elevation: 2,
                                                          value: controller
                                                              .txtZone,
                                                          icon: const Icon(Icons
                                                              .keyboard_arrow_down),
                                                          isExpanded: true,
                                                          underline:
                                                              Container(),
                                                          isDense: true,
                                                          menuMaxHeight:
                                                              fullHeight / 3,
                                                          items: controller
                                                              .pref.zones
                                                              .map((e) {
                                                            return DropdownMenuItem(
                                                              value: e.zone,
                                                              onTap: () {
                                                                controller
                                                                        .idZone =
                                                                    e.id;
                                                                controller
                                                                        .txtZone =
                                                                    e.zone;
                                                                controller
                                                                    .update();
                                                                print(
                                                                    '${controller.idZone} rqe');
                                                              },
                                                              child: Text(
                                                                  e.zone,
                                                                  maxLines: 3,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: theme
                                                                      .textTheme
                                                                      .bodyText2),
                                                            );
                                                          }).toList(),
                                                          onChanged: (_) {},
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: smallSize),
                                              Container(
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        start: standardSize,
                                                        end: standardSize,
                                                        top: standardSize),
                                                child: TextFormFieldWidget(
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'لطفا فیلد جزئیات را پر کنید';
                                                    }
                                                    return null;
                                                  },
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          smallSize),
                                                  label: "جزئیات",
                                                  onChange: (value) {
                                                    controller.addressInfoTxt
                                                        .value = value;
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  onTap: () {
                                                    if (controller
                                                        .addressInfoController
                                                        .text
                                                        .isNotEmpty) {
                                                      if (controller
                                                              .addressInfoController
                                                              .text
                                                              .endsWith(' ') ==
                                                          false) {
                                                        controller
                                                                .addressInfoController
                                                                .text =
                                                            '${controller.addressInfoController.text.trim()} ';
                                                      }
                                                    }
                                                  },
                                                  textEditingController:
                                                      controller
                                                          .addressInfoController,
                                                  hint: 'مثال: پلاک3، واحد4',
                                                ),
                                              ),
                                              SizedBox(height: smallSize),
                                              Container(
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        start: standardSize,
                                                        end: standardSize,
                                                        top: standardSize),
                                                child: TextFormFieldWidget(
                                                  onChange: (value) {
                                                    controller.addressTypeTxt
                                                        .value = value;
                                                  },
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          smallSize),
                                                  label: "عنوان آدرس",
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'لطفا فیلد عنوان آدرس را پر کنید';
                                                    }
                                                    return null;
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onTap: () {
                                                    if (controller
                                                        .addressTitleController
                                                        .text
                                                        .isNotEmpty) {
                                                      if (controller
                                                              .addressTitleController
                                                              .text
                                                              .endsWith(' ') ==
                                                          false) {
                                                        controller
                                                                .addressTitleController
                                                                .text =
                                                            '${controller.addressTitleController.text.trim()} ';
                                                      }
                                                    }
                                                  },
                                                  textEditingController:
                                                      controller
                                                          .addressTitleController,
                                                  hint: 'مثال: خانه',
                                                ),
                                              ),
                                              SizedBox(height: smallSize),
                                              Container(
                                                margin:
                                                    EdgeInsetsDirectional.only(
                                                        start: standardSize,
                                                        end: standardSize,
                                                        top: standardSize),
                                                child: TextFormFieldWidget(
                                                  // onFieldSubmitted: (value) =>
                                                  //     FocusScope.of(context).nextFocus(),
                                                  onTap: () {
                                                    if (controller
                                                        .phoneController
                                                        .text
                                                        .isNotEmpty) {
                                                      if (controller
                                                              .phoneController
                                                              .text
                                                              .endsWith(' ') ==
                                                          false) {
                                                        controller
                                                                .phoneController
                                                                .text =
                                                            '${controller.phoneController.text.trim()} ';
                                                      }
                                                    }
                                                  },
                                                  maxLength: 11,
                                                  validator: (value) {
                                                    if (value?.isEmpty ??
                                                        false) {
                                                      return 'لطفا فیلد شماره تلفن را پر کنید';
                                                    } else if (value!.length <
                                                            10 &&
                                                        !value
                                                            .startsWith('09')) {
                                                      return 'شماره تلفن مجاز نیست';
                                                    }
                                                    return null;
                                                  },
                                                  onChange: (value) =>
                                                      controller.phoneNumberTxt
                                                          .value = value,
                                                  padding:
                                                      EdgeInsetsDirectional.all(
                                                          smallSize),
                                                  label: "شماره تماس",
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  textEditingController:
                                                      controller
                                                          .phoneController,
                                                  hint: 'مثال: ۰۹۱۲۳۴۵۶۷۸۹',
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: Obx(() {
                                  return Container(
                                      padding: EdgeInsetsDirectional.all(
                                          standardSize),
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
