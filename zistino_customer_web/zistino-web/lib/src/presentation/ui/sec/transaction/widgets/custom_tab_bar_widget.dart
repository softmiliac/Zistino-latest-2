import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

Widget customTabBarWidget({
  required List<String> items,
  required RxInt selectedIndex,
}) {
  final ThemeData theme = Get.theme;
  return SizedBox(
    height: fullWidth/12,
    child: ListView.builder(
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Obx(
          () => Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: AppColors.splashColor,
              onTap: () {
                selectedIndex.value = index;
              },
              borderRadius: BorderRadius.circular(standardRadius),
              child: Container(
                alignment: Alignment.center,
                height: kBottomNavigationBarHeight,
                padding: EdgeInsetsDirectional.only(
                  end: smallSize,
                  start: smallSize,
                ),
                decoration: BoxDecoration(
                  color: selectedIndex.value == index
                      ? theme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(standardRadius),
                ),
                child: Text(
                  items[index],
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: selectedIndex.value == index
                        ? Colors.white
                        : AppColors.textBlackColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
