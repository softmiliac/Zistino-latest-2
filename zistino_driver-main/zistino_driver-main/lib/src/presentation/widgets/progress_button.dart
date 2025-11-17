import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/dimens.dart';

Widget progressButton(
    {required bool isProgress,
      required VoidCallback onTap,
      bool hasBorder = false,
      bool? isDisable = true,
      String text = ''}) {
  RxBool isTapped = false.obs;
  ThemeData theme = Get.theme;

  return AnimatedOpacity(
    duration: const Duration(milliseconds: 200),
    opacity: isDisable ?? false || isProgress ? 0.3 : 1,
    curve: Curves.fastLinearToSlowEaseIn,
    child: AnimatedScale(
      scale: isTapped.value ? 0.94 : 1,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 600),
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onHighlightChanged: (value) {
          isTapped.value = value;
        },
        onTap:
        // isDisable?.value ?? false ||
        isProgress ? () {} : onTap,
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
              borderRadius: BorderRadius.circular(smallRadius),
              color: hasBorder ? Colors.white : theme.primaryColor,
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
                    ? theme.primaryColor
                    : theme.backgroundColor),
          ),
        ),
      ),
    ),
  );
}
