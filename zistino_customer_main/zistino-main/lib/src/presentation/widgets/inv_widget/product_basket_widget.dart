import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/utils/number_format.dart';
import '../../../domain/entities/inv/basket_item.dart';
import '../../style/colors.dart';
import '../../style/dimens.dart';
import '../counter_box_widget.dart';
import '../image_widget.dart';

Widget verticalProductWidget(BasketItem entity,TextEditingController textEditingController) {
  var theme = Get.theme;
  RxInt orderingCount = 1.obs;
  return Container(
      width: fullWidth / 2,
      height: fullHeight / 3.4,
      padding: EdgeInsets.only(
        right: standardSize,
        left: standardSize,
        bottom: standardSize,
        top: largeSize,
      ),
      margin: EdgeInsets.only(
        bottom: standardSize,
        right: standardSize,
        left: standardSize,
      ),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(standardRadius),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: -2,
                blurRadius: 15,
                offset: Offset(0, 2))
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: fullHeight / 7.2,
          child: imageWidget(entity.masterImage, fit: BoxFit.contain),
        ),
        SizedBox(height: standardSize),
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
                  text: ' ریال',
                  style: theme.textTheme.caption?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.captionTextColor),
                ),
              ]),
            ),
            SizedBox(
                width: fullWidth / 3.2,
                child: counterBoxWidget(

                  isDisabled: true,
                    textEditingController: textEditingController,
                    count: orderingCount, item: entity),)
          ],
        ),
      ]));
}
