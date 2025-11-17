import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';
import '../controller/residue_controller.dart';

Widget selectResidueWidget(int index, CategoryEntity entity) {
  final ThemeData theme = Get.theme;

  // BasketController basketController = Get.find();

  ResidueController controller = Get.find();

  return Obx(()=> GestureDetector(
          onTap: () {
            controller.changeCatState(index);
            controller.fetchResidue(entity.id);

          },
          child: Container(
                  margin: EdgeInsets.only(bottom: standardSize),
                  padding: EdgeInsets.symmetric(
                      horizontal: largeSize, vertical: standardSize),
                  decoration: BoxDecoration(
                      color: theme.backgroundColor,
                      border: Border.all(
                          color: controller.isSelectedCategory(index)
                                      // .checkItemCount(entity.id.toString()) !=
                                  // 0
                              ? theme.primaryColor
                              : Colors.transparent,
                          width: 1.3),
                      borderRadius: BorderRadius.circular(mediumRadius),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: -3,
                            blurRadius: 12,
                            offset: Offset(0, 5))
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: xxLargeSize,
                          width: xxLargeSize,
                          child: imageWidget(entity.imagePath,
                              radius: smallRadius)),
                      SizedBox(width: largeSize),
                      Expanded(
                        child:
                            Text(entity.name, style: theme.textTheme.subtitle1),
                      ),
                      Container(
                        width: largeSize / 1.05,
                        height: largeSize / 1.05,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                width:controller.isSelectedCategory(index)
                                    ? 0
                                    : 1.3,
                                color: controller.isSelectedCategory(index)
                                    ? Colors.transparent
                                    : AppColors.borderColor)),
                        child: controller.isSelectedCategory(index)
                            ? SizedBox(
                                width: largeSize / 1.05,
                                height: largeSize / 1.05,
                                child: SvgPicture.asset('assets/ic_tick.svg'),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
  )    );

}
