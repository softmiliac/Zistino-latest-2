import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';
import '../controller/products_controller.dart';

Widget categoriesWidget(CategoryEntity entity, int index) {
  var theme = Get.theme;
  final ProductsController productsController = Get.find();

  return Obx(() {
      return GestureDetector(
        onTap: () {
          productsController.categoryIndex.value = index;
          productsController.fetchProducts();
        },
        child: Container(
            padding: EdgeInsets.only(
                bottom: xxSmallSize,
                left: standardSize,
                right: standardSize,
                top: xxSmallSize),
            margin: EdgeInsetsDirectional.only(

                end: standardSize),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(standardRadius),
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
                style: theme.textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.7,
                    color: AppColors.captionTextColor),
              ),
            )),
      );
    }
  );
}
