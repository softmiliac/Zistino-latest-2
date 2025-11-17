import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';

Widget productListHome(List<ProductSectionEntity> entity) {
  return SizedBox(
    height: fullWidth/1.5,

    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding:const EdgeInsetsDirectional.all(0),
      scrollDirection: Axis.horizontal,
      itemCount: entity.length,

      itemBuilder: (context, index) => _productWidget(entity[index]),
    ),
  );
}

Widget _productWidget(ProductSectionEntity entity) {
  final theme = Get.theme;
  return Container(
      width: fullWidth / 2,
      height: fullHeight / 3.4,
      padding: EdgeInsets.only(
        right: standardSize,
        left: standardSize,
        bottom: standardSize,
        top: largeSize,
      ),
      margin: EdgeInsetsDirectional.only(
        end: standardSize,
        // left: standardSize,
        bottom: standardSize,
      ),
      decoration: BoxDecoration(
          color: theme.backgroundColor,
          borderRadius: BorderRadius.circular(standardRadius),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: -4,
                blurRadius: 10,
                offset: Offset(0, 3))
          ]),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: fullHeight / 7.2,
          child: imageWidget(entity.productModel?.masterImage ?? '', fit: BoxFit.contain),
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
                  text: entity.productModel?.masterPrice.toString(),
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
            // Container(
            //     width: fullWidth / 3.2,
            //     child: counterBoxWidget(
            //         isDisabled: true,
            //         textEditingController: textEditingController,
            //         count: orderingCount))
          ],
        ),
      ]));
}
