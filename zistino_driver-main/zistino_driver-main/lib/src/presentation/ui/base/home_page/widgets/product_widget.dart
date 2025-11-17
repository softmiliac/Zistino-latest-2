import 'package:recycling_machine/src/domain/entities/pro/product_entity.dart';
import 'package:recycling_machine/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../../domain/entities/inv/basket_item.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';

Widget productWidget(ProductEntity entity) {
  final BasketController basketController = Get.find();
  var theme = Get.theme;

  // RxBool isAddToCart = false.obs;
  // TextEditingController counterTextController =
  //     TextEditingController(text: '1');
  // RxInt counter = 1.obs;
  return ValueListenableBuilder(
      valueListenable: Boxes.getBasketBox().listenable(),
      builder: (context, box, widget) {
        return Container(
            width: fullWidth / 2,
            padding: EdgeInsets.only(
                bottom: standardSize,
                left: standardSize,
                right: standardSize,
                top: largeSize),
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                        text: entity.masterPrice.toString(),
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
                        return basketController.checkItemCount(entity.id)!= 0  ?
                          GestureDetector(
                            onTap: () {
                              var item = BasketItem(
                                  id: entity.id,
                                  price: entity.masterPrice ?? 0,
                                  masterImage: entity.masterImage,
                                  name: entity.name,
                                  discountPercent: entity.discountPercent,
                                  description: entity.description,
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
                                id: entity.id,
                                price: entity.masterPrice ?? 0,
                                masterImage: entity.masterImage,
                                name: entity.name,
                                discountPercent: entity.discountPercent,
                                description: entity.description,
                                itemTotal: 0,
                                quantity: 0
                              // basketController.box.values.toList()[0].quantity
                            );

                           basketController.addToCart(item);
                           basketController.increase(item.id);

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
      });
}
