import 'package:admin_dashboard/src/common/utils/close_keyboard.dart';
import 'package:admin_dashboard/src/presentation/ui/base/home_page/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../data/models/inv/driver_delivery_model.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../request_detail_page/binding/binding.dart';
import '../../request_detail_page/view/request_detail_page.dart';

Widget requestWidget(DriverDeliveryModel model, int index) {
  var slidable = Slidable.of(Get.context!);
  var theme = Get.theme;
  return SlidableAutoCloseBehavior(
    closeWhenTapped: false,
    child: Slidable(
      enabled: true,
      endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: GestureDetector(
            onTap: () {
              _removeRequestSheet(index, model: model);
              slidable?.close();
              // removeAddressSheet(Get.context!, AddressEntity());
            },
            child: Container(
                // width: fullWidth / 5,
                width: MediaQuery.of(Get.context!).size.width / 5,
                margin: const EdgeInsetsDirectional.only(
                  top: 16,
                  start: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.errorColor),
                  borderRadius: BorderRadiusDirectional.circular(16),
                  color: theme.errorColor.withOpacity(0.09),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset('assets/trash.svg',
                          width: 24,
                          height: 24,
                          color: theme.errorColor),
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(top: 12),
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
        onTap: () => Get.to(RequestDetailPage(entity: model),binding: RequestDetailBinding()),
        child: Container(
          margin: const EdgeInsetsDirectional.only(
            top: 16,
          ),
          padding: const EdgeInsetsDirectional.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,
            // spreadRadius: 3
            // )]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _rowItems('assets/ic_frame.svg', model.creator),
              const SizedBox(
                height: 12,
              ),
              _rowItems('assets/ic_location.svg', model.address),
              const SizedBox(
                height: 12,
              ),
              _rowItems('assets/ic_call.svg', model.phoneNumber),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _rowItems(String icon, String name) {
  final theme = Get.theme;

  return Row(
    children: [
      SvgPicture.asset(
        icon,
        color: theme.primaryColor,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          name,
          style: theme.textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      )
    ],
  );
}

void _removeRequestSheet(int index,{required DriverDeliveryModel model}) {
  final HomeController controller = Get.find<HomeController>();
  final theme = Get.theme;
  final descKey = GlobalKey<FormState>();
  showModalBottomSheet(
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: GestureDetector(
            onTap: () => closeKeyboard(context),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff10548B).withOpacity(0.16),
                      spreadRadius: 10,
                      blurRadius: 10,
                      // blurStyle: BlurStyle.solid
                    )
                  ]),
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsetsDirectional.only(
                        top: 24,
                        bottom: 16,
                        start: 16,
                        end: 16),
                    child: Text(
                      'دلیل لغو درخواست خود را بیان کنید؟',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.subtitle1!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: descKey,
                      child: TextFormFieldWidget(
                        hint: 'توضیحـات',
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'لطفا برای ثبت درخواست فیلد توضیحات را پر کنید';
                          }
                          return null;
                        },
                        textEditingController: controller.descriptionController,
                        padding: const EdgeInsetsDirectional.all(8),
                        maxLine: 5,
                        fillColor: AppColors.homeBackgroundColor,
                        border: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(12)),
                        disableBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(12)),
                        enableBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none,borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    Obx(() {
                      return Container(
                        margin: const EdgeInsetsDirectional.only(start: 16),
                        // width: fullWidth / 2.4,
                        width: MediaQuery.of(Get.context!).size.width / 2.4,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical: controller.isBusyDelete.value
                                      ?
                                  // fullWidth / 26.9
                                  MediaQuery.of(Get.context!).size.width / 26.9
                                      // : fullWidth / 26
                                      : MediaQuery.of(Get.context!).size.width / 26
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(
                                      width: 1, color: AppColors.primaryColor))),
                          onPressed: controller.isBusyDelete.value
                              ? null
                              : () {
                            if(descKey.currentState!.validate()){
                                    controller.deleteRequest(model);
                                    // controller.deliveryData?.data.removeAt(index);
                                    Get.back();
                                  }
                                },
                          child: controller.isBusyDelete.value
                              ? const CupertinoActivityIndicator()
                              : Text('تایید',
                              style: theme.textTheme.bodyText2?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor)),
                        ),
                      );
                    }),
                    Container(
                      margin: const EdgeInsetsDirectional.only(end: 16),
                      // width: fullWidth / 2.4,
                      width: MediaQuery.of(Get.context!).size.width/ 2.4,
                      // margin: EdgeInsetsDirectional.only(start: 8),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            padding: EdgeInsets.symmetric(vertical:
                            // fullWidth / 26
                            MediaQuery.of(Get.context!).size.width / 26
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide.none)),
                        onPressed: () {
                          Get.back();
                          controller.descriptionController.clear();
                        },
                        child: Text('لغو',
                            style: theme.textTheme.bodyText2?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.backgroundColor)),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      });
}

/// For Desktop ///
Widget requestWidgetDesktop(DriverDeliveryModel model, int index) {
  return GestureDetector(
    onTap: () => Get.to(RequestDetailPage(entity: model),binding: RequestDetailBinding()),
    child: Container(

      width: 450,
      margin: const EdgeInsetsDirectional.only(
        top: 16,end: 20
      ),
      padding:const EdgeInsetsDirectional.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,
        // spreadRadius: 3
        // )]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              removeRequestDialog(Get.context!,model);
            },
            child: SizedBox(
              width: 25,
              height: 25,
              child: SvgPicture.asset('assets/trash.svg'),
            ),
          ),
          _rowItemsDesktop('assets/ic_frame.svg', model.creator),
          const SizedBox(
            height: 12,
          ),
          _rowItemsDesktop('assets/ic_location.svg', model.address),
          const SizedBox(
            height: 12,
          ),
          _rowItemsDesktop('assets/ic_call.svg', model.phoneNumber),
        ],
      ),
    ),
  );
}
Widget _rowItemsDesktop(String icon, String name) {
  final theme = Get.theme;

  return Row(
    children: [
      SvgPicture.asset(
        icon,
        color: theme.primaryColor,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          name,
          style: theme.textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      )
    ],
  );
}
void removeRequestDialog(
    BuildContext context, DriverDeliveryModel entity) {
  final HomeController homeController =
  Get.find<HomeController>();
  final theme = Get.theme;
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Obx(() {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(xxSmallRadius)),
            actions: [
              Container(
                margin:  EdgeInsetsDirectional.only(
                    start: xSmallSize, end: xxSmallSize, bottom: xxSmallSize),
                // width: fullHeight / 5,
                width: MediaQuery.of(Get.context!).size.height/ 5,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding:  EdgeInsets.symmetric(vertical: xSmallSize / 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(xxSmallRadius / 2),
                          side: const BorderSide(
                              width: 1, color: AppColors.primaryColor))),
                  onPressed: homeController.isBusyDelete.value
                      ? null
                      : () {
                    homeController.deleteRequest(
                    entity

                    );
                    Get.back();
                    homeController.update();
                    // Get.back();
                  },
                  child: homeController.isBusyDelete.value
                      ?const CupertinoActivityIndicator()
                      : Text('بله',
                      style: theme.textTheme.subtitle2?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor)),
                ),
              ),
              Container(
                margin:  EdgeInsetsDirectional.only(
                    end: xSmallSize, bottom: xxSmallSize),
                // width: fullHeight / 5,
                width: MediaQuery.of(Get.context!).size.height / 5,
                // margin: EdgeInsetsDirectional.only(start: 8),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding:  EdgeInsets.symmetric(vertical: xSmallSize / 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(xxSmallRadius / 2),
                          side: BorderSide.none)),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('خیر',
                      style: theme.textTheme.subtitle2?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.backgroundColor)),
                ),
              ),
            ],
            title: Container(
              margin:  EdgeInsetsDirectional.only(
                  top: xSmallSize,
                  bottom: xSmallSize,
                  start: xSmallSize,
                  end: xSmallSize),
              child: Text(
                'آیا می خواهید درخواست خود را حذف کنید؟',
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          );
        }
        );
      });
}