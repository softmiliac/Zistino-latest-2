import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';
import '../controller/products_controller.dart';

Widget categoriesWidget(CategoryEntity entity, int index, {bool isDesktop = false}) {
  var theme = Get.theme;
  final ProductsController productsController = Get.find();
  var width = MediaQuery.of(Get.context!).size.width;
  return Obx(() {
      return GestureDetector(
        onTap: () {
          productsController.categoryIndex.value = index;
          productsController.fetchProducts();
        },
        child: Container(
            padding: isDesktop ? EdgeInsets.only(
                bottom: width/130,
                left: width/95,
                right: width/95,
                top: width/130) : EdgeInsets.only(
                bottom: xxSmallSize,
                left: standardSize,
                right: standardSize,
                top: xxSmallSize),
            margin: EdgeInsetsDirectional.only(
                end: isDesktop ? width/115 : standardSize),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(isDesktop ? width/130 : standardRadius),
                border: Border.all(
                  color: productsController.categoryIndex.value == index ? theme.primaryColor : Colors.transparent,
                  width: 1
                )),
            child:
            Container(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                entity.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isDesktop ? theme.textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: width/96,
                    height: 1.7,
                    color: AppColors.captionTextColor) : theme.textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                    color: AppColors.captionTextColor),
              ),
            )),
      );
    }
  );
}
