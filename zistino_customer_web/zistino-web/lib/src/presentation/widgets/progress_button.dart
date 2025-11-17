import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/colors.dart';
import '../style/dimens.dart';

Widget progressButton(
    {required bool isProgress,
    required VoidCallback onTap,
    bool hasBorder = false,
    bool? isDisable = false,
    bool isDesktop = false,
      String text = ''}) {
  RxBool isTapped = false.obs;
  ThemeData theme = Get.theme;

  return AnimatedScale(
    scale: isTapped.value ? 0.94 : 1,
    curve: Curves.fastLinearToSlowEaseIn,
    duration: const Duration(milliseconds: 600),
    child: InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: BorderRadius.circular(isDesktop ? xxSmallSize/2 : smallRadius),
      onHighlightChanged: (value) {
        isTapped.value = value;
      },
      onTap:
      isDisable ?? false || isProgress ? () {} : onTap,
      child: Container(
        alignment: Alignment.center,
        height: kBottomNavigationBarHeight,
        padding: EdgeInsetsDirectional.only(
            end: standardSize, start: standardSize),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: theme.primaryColor.withOpacity(0.2),
                  offset: const Offset(0.0, 0.0),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
            borderRadius: BorderRadius.circular(isDesktop == true ? xxSmallSize/1.9 : smallRadius/1.9),
            color: hasBorder ? Colors.white : isDisable ?? false || isProgress ? AppColors.disablePrimaryColor : theme.primaryColor,
            border: hasBorder
                ? Border.all(color: theme.primaryColor, width: 0.8)
                : Border.all(color: Colors.transparent, width: 0.8)),
        child: isProgress
            ? const CupertinoActivityIndicator(
                animating: true,
                color: Colors.white,
              )
            : Text(
                text,
                style: theme.textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasBorder
                        ? isDisable ?? false || isProgress ? AppColors.disablePrimaryColor : theme.primaryColor
                        : theme.backgroundColor),
              ),
      ),
    ),
  );
}
