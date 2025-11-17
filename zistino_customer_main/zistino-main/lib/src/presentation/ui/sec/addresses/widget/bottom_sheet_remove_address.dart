import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/entities/sec/address_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../controller/address_controller.dart';

void removeAddressSheet(BuildContext context, AddressEntity entity, int index) {
  final AddressesController addressesController =
      Get.find<AddressesController>();
  final theme = Get.theme;
  showModalBottomSheet(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(largeSize),
          topLeft: Radius.circular(largeSize),
        ),
      ),
      context: context,
      isDismissible: false,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(largeSize),
                topLeft: Radius.circular(largeSize),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff10548B).withOpacity(0.16),
                  spreadRadius: 10,
                  blurRadius: 10,
                  // blurStyle: BlurStyle.solid
                )
              ]),
          padding: EdgeInsets.symmetric(vertical: largeSize),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsetsDirectional.only(
                    top: largeSize,
                    bottom: largeSize,
                    start: standardSize,
                    end: standardSize),
                child: Text(
                  'آیا می خواهید آدرس را حذف کنید؟',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Obx(() {
                  return Container(
                    margin: EdgeInsetsDirectional.only(start: standardSize),
                    width: fullWidth / 2.4,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: addressesController.isBusyDelete.value
                                  ? fullWidth / 19.4
                                  : fullWidth / 19),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(mediumRadius),
                              side: const BorderSide(
                                  width: 1, color: AppColors.primaryColor))),
                      onPressed: addressesController.isBusyDelete.value
                          ? null
                          : () {
                              addressesController.deleteAddress(
                                  context: context, addressID: entity.id, index: index);
                              addressesController.update();
                              // Get.back();
                            },
                      child: addressesController.isBusyDelete.value
                          ? CupertinoActivityIndicator()
                          : Text('بله',
                              style: theme.textTheme.subtitle2?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor)),
                    ),
                  );
                }),
                Container(
                  margin: EdgeInsetsDirectional.only(end: standardSize),
                  width: fullWidth / 2.4,
                  // margin: EdgeInsetsDirectional.only(start: xSmallSize),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: fullWidth / 19),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mediumRadius),
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
              ]),
            ],
          ),
        );
      });
}
