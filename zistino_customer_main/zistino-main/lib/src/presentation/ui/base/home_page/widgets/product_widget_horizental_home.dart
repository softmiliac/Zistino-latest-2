import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../../domain/entities/inv/basket_item.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';
import '../../../inv/basket_controller/basket_controller.dart';

Widget productListHome(List<ProductSectionEntity> entity) {
  return entity.length == null || entity.isEmpty ? const SizedBox()
      : SizedBox(
    height: fullWidth/1.5,
    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsetsDirectional.only(
          start: standardSize),
      scrollDirection: Axis.horizontal,
      itemCount: entity.length,

      itemBuilder: (context, index) => _productWidget(entity[index]),
    ),
  );
}

Widget _productWidget(ProductSectionEntity entity) {
  final BasketController basketController = Get.find();
  final theme = Get.theme;
  return ValueListenableBuilder(
      valueListenable: Boxes.getBasketBox().listenable(),
      builder: (context, box, widget) {
        return Container(
            width: fullWidth / 2.4,
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
                  entity.productModel?.name ?? '',
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
                        text: formatNumber(entity.productModel?.masterPrice ?? 0),
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
                  ValueListenableBuilder(
                      valueListenable: Boxes.getBasketBox().listenable(),
                      builder: (context, box, widget) {
                        return basketController.checkItemCount(entity.productModel?.id)!= 0  ?
                        GestureDetector(
                          onTap: () {
                            var item = BasketItem(
                                id: entity.productModel?.id ?? '',
                                price: entity.productModel?.masterPrice ?? 0,
                                masterImage: entity.productModel?.masterImage ?? '',
                                name: entity.productModel?.name ?? '',
                                discountPercent: entity.productModel?.discountPercent ?? 0,
                                description: entity.productModel?.description ?? '',
                                itemTotal: 0,
                                quantity: 0
                              // basketController.box.values.toList()[0].quantity
                            );

                            basketController.decrease(item.id);

                            // isAddToCart.value = !isAddToCart.value;
                          },
                          child: SvgPicture.asset(
                            'assets/ic_store.svg',
                            color:
                            theme.primaryColor,
                          ),
                        ):

                        GestureDetector(
                          onTap: () {
                            var item = BasketItem(
                                id: entity.productModel?.id ?? '',
                                price: entity.productModel?.masterPrice ?? 0,
                                masterImage: entity.productModel?.masterImage ?? '',
                                name: entity.productModel?.name ?? '',
                                discountPercent: entity.productModel?.discountPercent ?? 0,
                                description: entity.productModel?.description ?? '',
                                itemTotal: 0,
                                quantity: 0
                              // basketController.box.values.toList()[0].quantity
                            );

                            basketController.addToCart(item);
                            basketController.increase(item.id, false);

                            // isAddToCart.value = !isAddToCart.value;
                          },
                          child: SvgPicture.asset(
                            'assets/ic_store.svg',
                            color:
                            AppColors.borderColor
                            ,
                          ),
                        );
                      })
                ],
              ),
            ]));
      }
  );
}
