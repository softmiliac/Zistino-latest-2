import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';

Widget customRadioItem({
  String? name,
  int? index,
  VoidCallback? onTap,
  RxDouble? bottomSheetItemHeight,
  RxDouble? bottomSheetItemWidth,
  required RxInt selected,
  RxDouble? editBoxPaddingH,
  RxDouble? editBoxPaddingV,
  bool hasBackSelect = false,
  Widget? suffixWidget,
  String iconUrl = '',
  Widget? iconWidget,
  RxBool? isEdit,
  String flagUrl = '',
}) {
  final theme = Get.theme;
  var a = MediaQuery.of(Get.context!).size.width;
  var b = MediaQuery.of(Get.context!).size.height;
  return Obx(
    () {
      return GestureDetector(
        onTap: onTap ??
            () {
              if (hasBackSelect) {
                Get.back();
              }
              selected.value = index ?? 0;
            },
        child: Container(
          height: b/11,
          margin: EdgeInsetsDirectional.only(bottom: a/24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(a/30),
            color: AppColors.formFieldColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                  blurRadius: 7)
            ],
            border: Border.all(
              width: 1,
              color: selected.value == index
                  ? theme.primaryColor
                  : AppColors.formFieldColor,
            ),
          ),
          padding: EdgeInsets.symmetric(
            vertical: a/30,
            horizontal: a/24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: bottomSheetItemHeight?.value.h ?? 0,
                width: bottomSheetItemWidth?.value.h ?? 0,
                child: SvgPicture.asset(
                  'assets/ic_drag.svg',
                  height: bottomSheetItemHeight?.value.h ?? 0,
                  width: bottomSheetItemWidth?.value.h ?? 0,
                  color: Colors.grey.shade400,
                ),
              ),
              if (isEdit?.value ?? false)
                AnimatedSize(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: SizedBox(width: a/30),
                ),
              iconWidget ?? const SizedBox(),
              flagUrl.isNotEmpty
                  ? SizedBox(
                      width: a/24,
                      height: a/30,
                      child: imageWidget(flagUrl),
                    )
                  : iconUrl.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            shape: BoxShape.circle,
                          ),
                          width: a/20,
                          height: a/20,
                          margin: EdgeInsetsDirectional.only(end: a/30),
                          padding: EdgeInsetsDirectional.all(a/30),
                          child: SvgPicture.asset(iconUrl, color: Colors.black),
                        )
                      : const SizedBox(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: flagUrl.isNotEmpty || iconUrl.isNotEmpty
                        ? a/24
                        : 0,
                  ),
                  child: Text(
                    name ?? "",
                    style: theme.textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              suffixWidget ?? const SizedBox(),
              Visibility(
                visible: false,
                child: Radio(
                  value: selected.value,
                  groupValue: index,
                  onChanged: (val) {
                    selected.value == val;
                  },
                ),
              ),
              // SvgPicture.asset(
              //   selected.value == index
              //       ? 'assets/ic_selected.svg'
              //       : 'assets/ic_unselected.svg',
              //   height: iconSizeSmall,
              //   width: iconSizeSmall,
              // ),
            ],
          ),
        ),
      );
    },
  );
}
