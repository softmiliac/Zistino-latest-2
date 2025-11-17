import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/utils/close_keyboard.dart';
import '../../../style/colors.dart';
import '../../../style/dimens.dart';
import '../../../widgets/progress_button.dart';
import '../../../widgets/text_field_widget.dart';
import '../controller/map_controller.dart';
import '../view/map_page.dart';

void addAddressSheet(BuildContext context) {
  /// instances ///
  final MyMapController controller = Get.find();
  final theme = Get.theme;

  final formKey = GlobalKey<FormState>();

  controller.mapController = MapController(
      initPosition: GeoPoint(
          latitude: controller.geoPoint?.latitude ?? 0,
          longitude: controller.geoPoint?.longitude ?? 0),
      initMapWithUserPosition: false);

  showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        Future<bool> onBackClicked(BuildContext context) async {
          closeKeyboard(context);
          Get.offAll(MapPage());
          controller.clearTxtField();
          return Future.value(true);
        }

        // controller.update();
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: WillPopScope(
            onWillPop: () => onBackClicked(context),
            child: GetBuilder(
                init: controller,
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
                                      top: xxSmallSize,
                                      start: smallSize,
                                      end: xxSmallSize),
                                  padding:
                                  EdgeInsetsDirectional.all(smallSize),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Get.offAll(MapPage());
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
                                                  personMarker: const MarkerIcon(
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
                                                  onBackClicked(context);
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsetsDirectional.only(
                                                          top: standardSize,
                                                          start: standardSize,
                                                          end: standardSize,
                                                          bottom: 0),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: xSmallSize,
                                                      horizontal: xSmallSize),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color:
                                                              theme.primaryColor),
                                                      color:
                                                          const Color(0xffF1FCDA),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              smallRadius)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                          margin: EdgeInsetsDirectional
                                                              .only(
                                                                  end: xxSmallSize),
                                                          child: SvgPicture.asset(
                                                            'assets/edit_2.svg',
                                                            color:
                                                                theme.primaryColor,
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
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: smallSize),
                                      Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsetsDirectional.only(
                                                  start: standardSize,
                                                  end: standardSize,
                                                  top: standardSize),
                                              child: TextFormFieldWidget(
                                                validator: (value) {
                                                  if (value?.isEmpty ?? false) {
                                                    return 'لطفا فیلد آدرس را پر کنید'
                                                        .tr;
                                                  }
                                                  return null;
                                                },
                                                onTap: () {
                                                  if(controller.addressController.text.isNotEmpty){
                                                    if (controller.addressController.text.endsWith(' ') == false) {
                                                      controller.addressController.text =
                                                      '${controller.addressController.text.trim()} ';
                                                    }
                                                  }
                                                },
                                                label: "نشانی",
                                                onChange: (value) {
                                                  controller.addressTxt.value =
                                                      value;
                                                },
                                                padding: EdgeInsetsDirectional.only(
                                                    start: standardSize),

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
                                            Container(
                                              margin: EdgeInsetsDirectional.only(
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
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: fullWidth,
                                                    height: fullHeight / 17,
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: smallSize,
                                                        vertical: smallSize),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: AppColors
                                                                .borderColor),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                xSmallRadius)),
                                                    child: Center(
                                                      child: DropdownButton<String>(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                smallRadius),
                                                        elevation: 2,
                                                        value: controller.txtZone,
                                                        icon: const Icon(Icons
                                                            .keyboard_arrow_down),
                                                        isExpanded: true,
                                                        underline: Container(),
                                                        isDense: true,
                                                        menuMaxHeight:
                                                            fullHeight / 3,
                                                        items: controller.pref.zones
                                                            .map((e) {
                                                          return DropdownMenuItem(
                                                            value: e.zone,
                                                            onTap: () {
                                                              controller.idZone =
                                                                  e.id;
                                                              controller.txtZone =
                                                                  e.zone;
                                                              controller.update();
                                                              print(
                                                                  '${controller.idZone} rqe');
                                                            },
                                                            child: Text(e.zone,
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
                                              margin: EdgeInsetsDirectional.only(
                                                  start: standardSize,
                                                  end: standardSize,
                                                  top: standardSize),
                                              child: TextFormFieldWidget(
                                                validator: (value) {
                                                  if (value?.isEmpty ?? false) {
                                                    return 'لطفا فیلد جزئیات را پر کنید';
                                                  }
                                                  return null;
                                                },
                                                onChange: (value) {
                                                  controller.addressInfoTxt.value =
                                                      value;
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType: TextInputType.text,
                                                onTap: () {
                                                  if(controller
                                                      .addressInfoController.text.isNotEmpty){
                                                    if (controller
                                                        .addressInfoController.text.endsWith(' ') == false) {
                                                      controller
                                                          .addressInfoController.text =
                                                      '${controller
                                                          .addressInfoController.text.trim()} ';
                                                    }
                                                  }
                                                },
                                                textEditingController: controller
                                                    .addressInfoController,
                                                label: "جزئیات",
                                                hint: 'مثال: پلاک3، واحد4',
                                                padding: EdgeInsetsDirectional.only(
                                                    start: standardSize),
                                              ),
                                            ),
                                            SizedBox(height: smallSize),
                                            Container(
                                              margin: EdgeInsetsDirectional.only(
                                                  start: standardSize,
                                                  end: standardSize,
                                                  top: standardSize),
                                              child: TextFormFieldWidget(
                                                onChange: (value) {
                                                  controller.addressTypeTxt.value =
                                                      value;
                                                },
                                                label: "عنوان آدرس",
                                                validator: (value) {
                                                  if (value?.isEmpty ?? false) {
                                                    return 'لطفا فیلد عنوان آدرس را پر کنید';
                                                  }
                                                  return null;
                                                },
                                                padding: EdgeInsetsDirectional.only(
                                                    start: standardSize),
                                                textInputAction:
                                                    TextInputAction.next,
                                                onTap: () {
                                                  if(controller.addressTitleController.text.isNotEmpty){
                                                    if (controller.addressTitleController.text.endsWith(' ') == false) {
                                                      controller.addressTitleController.text =
                                                      '${controller.addressTitleController.text.trim()} ';
                                                    }
                                                  }
                                                },
                                                textEditingController: controller.addressTitleController,
                                                hint: 'مثال: خانه',
                                              ),
                                            ),
                                            SizedBox(height: smallSize),
                                            Container(
                                              margin: EdgeInsetsDirectional.only(
                                                  start: standardSize,
                                                  end: standardSize,
                                                  top: standardSize),
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
                                                padding: EdgeInsetsDirectional.only(
                                                    start: standardSize),
                                                label: "شماره تماس",
                                                maxLength: 11,
                                                // title: "شماره تماس(اختیاری)",
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
                              ],
                            ),
                          ),
                          Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Obx(() {
                                return Container(
                                    padding:
                                        EdgeInsetsDirectional.all(standardSize),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: kBottomNavigationBarHeight,
                                      child: progressButton(
                                          text: 'تاییـد آدرس',
                                          onTap: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              controller.addAddress();
                                            }
                                          },
                                          isProgress: controller
                                              .isBusyAdd.value,
                                          hasBorder: false,
                                          isDisable:
                                              controller.addressTxt.value !=
                                                          '' &&
                                                      controller.addressInfoTxt
                                                              .value !=
                                                          '' &&
                                                      controller.addressTypeTxt
                                                              .value !=
                                                          '' &&
                                                      controller.phoneNumberTxt
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
