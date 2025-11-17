import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/common/utils/number_format.dart';
import 'package:recycling_machine/src/domain/entities/pro/category_entity.dart';
import 'package:recycling_machine/src/presentation/style/colors.dart';
import 'package:recycling_machine/src/presentation/style/dimens.dart';
import 'package:recycling_machine/src/presentation/ui/inv/residue_page/controller/residue_controller.dart';
import '../../../../../data/models/pro/order_rqm.dart';
import '../../../../widgets/image_widget.dart';

Widget residueDetailWidget(OrderItem item, int index) {
  final ThemeData theme = Get.theme;
  final ResidueController controller = Get.find();

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
              child: imageWidget(category.imagePath, radius: smallRadius),
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
                                    '${formatNumber(item.unitPrice)} ریال',
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
                                    // '${formatNumber(item.price)} تومان',
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
                        '${formatNumber(controller.totalItemPrice(item,index: index))} ریال',
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
                    height: xxLargeSize / 1.1,
                    decoration: BoxDecoration(
                        color: AppColors.homeBackgroundColor,
                        borderRadius: BorderRadius.circular(xSmallRadius)),
                    child: Container(
                      margin: EdgeInsets.only(top: smallSize),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: controller.orderQuantity[index],
                        onChanged: (value) {
                          if (value.isEmpty) {
                            var a = int.parse('0');
                            item.itemCount = a;
                          } else {
                            var a = int.parse(value);
                            item.itemCount = a;
                          }
                          controller.updateTextField(item, index);
                        },

                        maxLines: 1,
                        maxLength: 3,
                        keyboardType: TextInputType.phone,
                        cursorColor: theme.primaryColor,
                        style: theme.textTheme.subtitle1!
                            .copyWith(color: AppColors.captionTextColor),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsetsDirectional.only(
                                top: xxSmallSize / 2, bottom: 0),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.circular(xSmallRadius)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.circular(xSmallRadius)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.circular(xSmallRadius)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.circular(xSmallRadius)),
                            filled: true,
                            fillColor: Colors.transparent),
                      ),
                    ),
                  ),
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
