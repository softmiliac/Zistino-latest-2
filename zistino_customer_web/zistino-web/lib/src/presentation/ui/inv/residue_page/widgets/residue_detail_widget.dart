import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/number_format.dart';
import '../../../../../data/models/inv/order_rqm.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';
import '../controller/residue_controller.dart';

Widget residueDetailWidget(OrderItem item, int index) {
  final ThemeData theme = Get.theme;
  final ResidueDeliveryController controller = Get.find();

  CategoryEntity category = controller.getCategoryById(item.description);
  return
      // ValueListenableBuilder(
      //   valueListenable: Boxes.getBasketBox().listenable(),
      //   builder: (context, box, widget) {
      //     return basketController.checkItemCount(item.id) != 0
      //         ?
      Container(
    margin: EdgeInsetsDirectional.only(
        start: standardSize, end: standardSize, top: standardSize),
    width: fullWidth,
    padding: EdgeInsetsDirectional.all(standardSize),
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(standardSize)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: fullWidth / 5.8,
              height: fullWidth / 5.8,
              margin: EdgeInsets.only(top: xSmallSize),
              child: imageWidget(category.imagePath , radius: smallRadius),
            ),
            SizedBox(width: largeSize / 1.3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    category.name,
                    style: theme.textTheme.subtitle1,
                  ),
                  SizedBox(height: xxSmallSize),
                            Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'قیمت پایه هر کیلوگرم',
                                      style: theme.textTheme.subtitle2
                                          ?.copyWith(
                                              color:
                                                  AppColors.captionTextColor),
                                    ),
                                  ),
                                  Text(
                                    // '1000',
                                    '${formatNumber(item.unitPrice)} ريال',
                                    style: theme.textTheme.subtitle2?.copyWith(
                                        color: AppColors.captionTextColor),
                                  ),
                                ],
                              ),
                  SizedBox(height: xxSmallSize),
/*
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'بالا ترین قیمت خریدار',
                                      style: theme.textTheme.subtitle2
                                          ?.copyWith(
                                              color:
                                                  AppColors.captionTextColor),
                                    ),
                                  ),
                                  Text('asd',
                                    // '${formatNumber(item.price)} ريال',
                                    style: theme.textTheme.subtitle2?.copyWith(
                                        color: AppColors.captionTextColor),
                                  ),
                                ],
                              ),
*/
                  SizedBox(height: xxSmallSize),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'جمع قیمت',
                          style: theme.textTheme.subtitle2
                              ?.copyWith(color: AppColors.captionTextColor),
                        ),
                      ),
                      Text(
                        '${formatNumber(controller.totalItemPrice(item))} ريال',
                        style: theme.textTheme.subtitle2
                            ?.copyWith(color: theme.primaryColor),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: standardSize,
        ),
        GestureDetector(
          onTap: () {
            controller.increaseOrderItem(item, index);

            // basketController.increase(item.id);
          },
          child: Container(
            margin:
                EdgeInsetsDirectional.only(start: xSmallSize, end: xSmallSize),
            width: fullWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: xxLargeSize / 1.5,
                  height: xxLargeSize / 1.5,
                  padding: EdgeInsets.all(xSmallSize),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'assets/ic_plus.svg',
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: standardSize),
                Expanded(
                  child: Container(
                      padding: EdgeInsetsDirectional.only(
                          top: xSmallSize, bottom: xSmallSize),
                      decoration: BoxDecoration(
                          color: AppColors.homeBackgroundColor,
                          borderRadius: BorderRadius.circular(xSmallRadius)),
                      child: Text(
                        controller
                            .getOrderItemQuantity("${category.id}")
                            .toString(),
                        // '${basketController.checkItemCount(item.id)} کیلوگرم',
                        // '${controller.productRPM?[index].masterPrice} کیلوگرم',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.subtitle1!
                            .copyWith(color: AppColors.captionTextColor),
                      )),
                ),
                SizedBox(width: standardSize),
                GestureDetector(
                  onTap: () {
                    controller.decreaseOrderItem(item, index);
                    // controller.decreaseOrderItem(item);

                    // basketController.decrease(item.id);
                  },
                  child: Container(
                    width: xxLargeSize / 1.5,
                    height: xxLargeSize / 1.5,
                    padding: EdgeInsets.all(xSmallSize),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: theme.primaryColor, width: 2)),
                    child: SvgPicture.asset(
                      'assets/ic_minus.svg',
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    ),
  );
  // : const SizedBox();
  // }
  // );
}
