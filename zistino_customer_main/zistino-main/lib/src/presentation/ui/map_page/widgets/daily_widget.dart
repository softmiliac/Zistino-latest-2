import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../style/dimens.dart';
import '../../inv/residue_page/controller/residue_controller.dart';

Widget dailyWidget(int index) {
  final ResidueDeliveryController controller = Get.find();
  final theme = Get.theme;
  return GestureDetector(
    onTap: () {
      if (controller.selectedDay.value != controller.days.value[index]) {
        controller.selectedHour.value = null;
        controller.update();
      }
      controller.selectedDay.value = controller.days.value[index];
      controller.update();
    },
    child: Container(
      width: fullWidth / 3,
      margin: EdgeInsetsDirectional.only(end: xSmallSize),
      padding: EdgeInsetsDirectional.all(smallSize),
      decoration: BoxDecoration(
        color: controller.selectedDay.value == controller.days.value[index]
            ? theme.primaryColor
            : Colors.white,
        borderRadius: BorderRadius.circular(xSmallRadius),
      ),
      child: Text(
        controller.days.value[index].text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.subtitle1!.copyWith(
            color: controller.selectedDay.value == controller.days.value[index]
                ? Colors.white
                : Colors.black.withOpacity(0.8)),
      ),
    ),
  );
}
