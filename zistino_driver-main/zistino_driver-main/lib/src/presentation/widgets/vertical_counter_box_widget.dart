import 'package:recycling_machine/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style/colors.dart';
import '../style/dimens.dart';

Widget verticalCounterBoxWidget({
  RxInt? count,
  required TextEditingController textEditingController,
  Widget? prefixWidget,
  Widget? suffixWidget,
  Color? labelEnabledColor,
  Color? labelDisabledColor,
}) {
  var theme = Get.theme;
  return Obx(() {
      return Container(
        height: xxLargeSize/1.3,
        width: xxLargeSize/1.6,
        decoration: BoxDecoration(
          color: AppColors.splashColor,
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(xSmallRadius),
        ),
        // padding: EdgeInsetsDirectional.only(
        //   start: xSmallSize,
        //   end: xSmallSize,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            suffixWidget ??
                GestureDetector(
                  onTap: () {
                    // if (!isDisabled) {
                      if (count != null) {
                        count.value = count.value + 1;
                        textEditingController.text = count.value.toString();
                      // }
                    }
                  },
                  child: Container(
                    height: xxLargeSize/1.6,
                    width: xxLargeSize/1.6,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      border: Border.all(
                        color: AppColors.backgroundColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(xSmallRadius),
                    ),
                    child: Icon(
                      Icons.add,
                      color: theme.backgroundColor,
                    ),
                  ),
                ),
            Expanded(
              child: TextFormField(
                controller: textEditingController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                // enabled: ,
                textInputAction: TextInputAction.done,
                style: theme.textTheme.bodyText1?.copyWith(
                    color: Colors.black),
                onChanged: (value) => count?.value = int.parse(value),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    top: standardSize / 1.2,
                    bottom: standardSize / 1.2,
                    left: xxSmallSize
                  ),
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
            prefixWidget ??
                GestureDetector(
                  onTap: () {
                    // if (!isDisabled) {
                      if (count != null) {
                        if (count.value != 0) {
                          count.value = count.value - 1;
                        }
                        textEditingController.text = count.value.toString();
                      }
                    // }
                  },
                  child: Container(
                    height: xxLargeSize/1.6,
                    width: xxLargeSize/1.6,
                    decoration: BoxDecoration(
                      color: count != null && count.value == 0
                          ? theme.primaryColor.withOpacity(0.4)
                          : theme.primaryColor,
                      border: Border.all(
                        color: AppColors.backgroundColor,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(xSmallRadius),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: theme.backgroundColor,
                    ),
                  ),
                ),
          ],
        ),
      );
    }
  );
}
