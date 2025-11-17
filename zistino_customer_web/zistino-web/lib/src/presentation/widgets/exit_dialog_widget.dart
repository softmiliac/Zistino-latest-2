import 'package:admin_dashboard/src/common/services/get_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../style/colors.dart';
import '../style/dimens.dart';

void removeRequestSheet() {
  LocalStorageService pref = Get.find();
  final theme = Get.theme;
  showModalBottomSheet(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(largeSize),
          topLeft: Radius.circular(largeSize),
        ),
      ),
      context: Get.context!,
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
              SvgPicture.asset('assets/ic_logout.svg', height: fullWidth/6, color: const Color(0xFFE74F55)),
              SizedBox(height: standardSize),
              Container(
                margin: EdgeInsetsDirectional.only(
                    top: largeSize,
                    bottom: largeSize,
                    start: standardSize,
                    end: standardSize),
                child: Text(
                  'آیا می خواهید از حساب کاربری خود خارج شوید؟',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  margin: EdgeInsetsDirectional.only(start: standardSize),
                  width: fullWidth / 2.4,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: fullWidth / 26),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mediumRadius),
                            side: const BorderSide(
                                width: 1, color: AppColors.primaryColor))),
                    onPressed: () {
                      pref.clearPref();
                      pref.logOut();
                      Get.back();
                    },
                    child: Text('بله',
                        style: theme.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryColor)),
                  ),
                ),
                Container(
                  margin: EdgeInsetsDirectional.only(end: standardSize),
                  width: fullWidth / 2.4,
                  // margin: EdgeInsetsDirectional.only(start: xSmallSize),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: fullWidth / 26),
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mediumRadius),
                            side: const BorderSide(
                                width: 1, color: AppColors.primaryColor))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('خیر',
                        style: theme.textTheme.bodyText2?.copyWith(
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
void logOutDialog() {
  LocalStorageService pref = Get.find();

  final theme = Get.theme;
  showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(xxSmallRadius)),
            actions: [
              Container(
                margin: EdgeInsetsDirectional.only(
                    start: xSmallSize, end: xxSmallSize, bottom: xxSmallSize),
                width: fullHeight / 5,
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: xSmallSize / 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(xxSmallRadius / 2),
                          side: const BorderSide(
                              width: 1, color: AppColors.primaryColor))),
                  onPressed:
                 () {
                   pref.clearPref();
                   pref.logOut();
                   Get.back();
                    // Get.back();
                  },
                  child:
                  // addressesController.isBusyDelete.value
                  //     ? CupertinoActivityIndicator()
                  //     :
                  Text('بله',
                      style: theme.textTheme.subtitle2?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor)),
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(
                    end: xSmallSize, bottom: xxSmallSize),
                width: fullHeight / 5,
                // margin: EdgeInsetsDirectional.only(start: xSmallSize),
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: xSmallSize / 1.5),
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
              margin: EdgeInsetsDirectional.only(
                  top: xSmallSize,
                  bottom: xSmallSize,
                  start: xSmallSize,
                  end: xSmallSize),
              child: Text(
                'آیا می خواهید خارج شوید؟',
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle1!
                    .copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          );
        }
        );

}