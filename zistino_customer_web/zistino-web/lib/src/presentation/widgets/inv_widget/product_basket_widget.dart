import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/utils/number_format.dart';
import '../../../domain/entities/inv/basket_item.dart';
import '../../style/colors.dart';
// import '../../style/dimens.dart';
import '../counter_box_widget.dart';
import '../image_widget.dart';

Widget verticalProductWidgetPhone(BasketItem entity,TextEditingController textEditingController) {
   var a = MediaQuery.of(Get.context!).size.width;
  var b = MediaQuery.of(Get.context!).size.height;
  var theme = Get.theme;
  RxInt orderingCount = 1.obs;
  return Container(
      width: a / 4,
      height: a / 2,
      padding: EdgeInsets.only(
        right: a/36,
        left: a/36,
        bottom: a/36,
        top: a/36,
      ),
      margin: EdgeInsets.only(
        bottom: a/24,
        right: a/24,
        left: a/24,
      ),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(a/24),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: -2,
                blurRadius: 15,
                offset: Offset(0, 2))
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: b / 7.2,
          child: imageWidget(entity.masterImage, fit: BoxFit.contain),
        ),
        SizedBox(height: a/24),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            entity.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.7,
                color: AppColors.captionTextColor),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: formatNumber(entity.price),
                  style: theme.textTheme.subtitle2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ريال',
                  style: theme.textTheme.caption?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.captionTextColor),
                ),
              ]),
            ),
            SizedBox(
                width: a / 3.2,
                child: counterBoxWidgetPhone(

                  isDisabled: true,
                    textEditingController: textEditingController,
                    count: orderingCount, item: entity),)
          ],
        ),
      ]));
}
Widget verticalProductWidgetTablet(BasketItem entity,TextEditingController textEditingController) {
  var a = MediaQuery.of(Get.context!).size.width;
  var b = MediaQuery.of(Get.context!).size.height;
  var theme = Get.theme;
  RxInt orderingCount = 1.obs;
  return Container(
      width: a / 2,
      height: b / 3.4,
      padding: EdgeInsets.only(
        right: a/24,
        left: a/24,
        bottom: a/24,
        top: a/16,
      ),
      margin: EdgeInsets.only(
        bottom: a/24,
        right: a/24,
        left: a/24,
      ),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(a/24),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: -2,
                blurRadius: 15,
                offset: Offset(0, 2))
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: b / 7.2,
          child: imageWidget(entity.masterImage, fit: BoxFit.contain),
        ),
        SizedBox(height: a/24),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            entity.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.7,
                color: AppColors.captionTextColor),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: formatNumber(entity.price),
                  style: theme.textTheme.subtitle2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ريال',
                  style: theme.textTheme.caption?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.captionTextColor),
                ),
              ]),
            ),
            SizedBox(
              width: a / 3.2,
              child: counterBoxWidgetTablet(

                  isDisabled: true,
                  textEditingController: textEditingController,
                  count: orderingCount, item: entity),)
          ],
        ),
      ]));
}
Widget verticalProductWidgetDesktop(BasketItem entity,TextEditingController textEditingController) {
  var a = MediaQuery.of(Get.context!).size.width;
  var b = MediaQuery.of(Get.context!).size.height;
  var theme = Get.theme;
  RxInt orderingCount = 1.obs;
  return Container(
      // width: a / 6,
      // height: a / 3.4,
      padding: EdgeInsets.only(
        right: a/64,
        left: a/64,
        bottom: a/64,
        top: a/64,
      ),
      margin: EdgeInsets.only(
        bottom: a/36,
        right: a/36,
        left: a/36,
      ),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(a/48),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: -2,
                blurRadius: 15,
                offset: Offset(0, 2))
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: b / 7.2,
          child: imageWidget(entity.masterImage, fit: BoxFit.contain),
        ),
        SizedBox(height: a/20),
        Container(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            entity.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyText1?.copyWith(
                fontWeight: FontWeight.w600,
                height: 1.7,
                color: AppColors.captionTextColor),
          ),
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: formatNumber(entity.price),
                  style: theme.textTheme.subtitle2
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' ريال',
                  style: theme.textTheme.caption?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.captionTextColor),
                ),
              ]),
            ),

            SizedBox(
              width: a / 10,
              child: counterBoxWidgetDesktop(

                  isDisabled: true,
                  textEditingController: textEditingController,
                  count: orderingCount, item: entity),)
          ],
        ),
      ]));
}
