import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../common/utils/close_keyboard.dart';
import '../../../style/colors.dart';
// import '../../../style/dimens.dart';
import '../../../widgets/progress_button.dart';
import '../../../widgets/text_field_widget.dart';
import '../controller/map_controller.dart';
import '../view/map_page.dart';

void addAddressSheet(BuildContext context) {
  var a = MediaQuery.of(Get.context!).size.width;
  var b = MediaQuery.of(Get.context!).size.height;
  /// instances ///
  final MyMapController controller = Get.find();
  final theme = Get.theme;

  // controller.mapController = MapController(
  //     initPosition: GeoPoint(
  //         latitude: controller.geoPoint?.latitude ?? 0,
  //         longitude: controller.geoPoint?.longitude ?? 0),
  //     initMapWithUserPosition: false);

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
            child:
            // GetBuilder(
            //     init: controller,
            //     builder: (_) {
            //       return
                    GestureDetector(
                    onTap: () {
                      closeKeyboard(context);
                    },
                    child: Container(
                      height: b / 1.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(a/16),
                              topLeft: Radius.circular(a/16)),
                          color: theme.backgroundColor),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            right: 0,
                            left: 0,
                            top: 0,
                            bottom: kBottomNavigationBarHeight + a/20,
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
                                        start: a/70, end: a/100),
                                    padding:
                                        EdgeInsetsDirectional.all(a/70),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Get.offAll(MapPage());
                                          controller.clearTxtField();
                                        },
                                        borderRadius: BorderRadius.circular(
                                            a/16 * 4),
                                        splashColor: AppColors.splashColor,
                                        child: Padding(
                                            padding: EdgeInsets.all(a/80),
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
                   /*                     Positioned.fill(
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
                                        ),*/
                                        PositionedDirectional(
                                          bottom: a/70,
                                          start: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              onBackClicked(context);
                                            },
                                            child: Container(
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
                                                              end: a/100),
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
                                  SizedBox(height: a/70),
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
                                            label: "نشانی",
                                            onChange: (value) {
                                              controller.addressTxt.value =
                                                  value;
                                            },
                                            padding: EdgeInsetsDirectional.only(
                                                start: a/24),

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
                                        SizedBox(height: a/70),
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
                                            onChange: (value) {
                                              controller.addressInfoTxt.value =
                                                  value;
                                            },
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.text,
                                            textEditingController: controller
                                                .addressInfoController,
                                            label: "جزئیات",
                                            hint: 'مثال: پلاک3، واحد4',
                                            padding: EdgeInsetsDirectional.only(
                                                start: a/24),
                                          ),
                                        ),
                                        SizedBox(height: a/70),
                                        Container(
                                          margin: EdgeInsetsDirectional.only(
                                              start: a/24,
                                              end: a/24,
                                              top: a/24),
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
                                                start: a/24),
                                            textInputAction:
                                                TextInputAction.next,
                                            textEditingController: controller
                                                .addressTitleController,
                                            hint: 'مثال: خانه',
                                          ),
                                        ),
                                        SizedBox(height: a/70),
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
                                            padding: EdgeInsetsDirectional.only(
                                                start: a/24),
                                            label: "شماره تماس",

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
                          ),
                          Align(
                              alignment: AlignmentDirectional.bottomCenter,
                              child: Obx(() {
                                return Container(
                                    padding:
                                        EdgeInsetsDirectional.all(a/24),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: kBottomNavigationBarHeight,
                                      child: progressButton(
                                          text: 'تاییـد آدرس',
                                          onTap: () {
                                            if (controller.formKey.currentState!
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
                  )
                ),
          // ),
        );
      });
}
