import 'package:admin_dashboard/src/domain/entities/pro/product_entity.dart';
import 'package:admin_dashboard/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../../data/providers/remote/api_endpoint.dart';
import '../../../../../domain/entities/inv/basket_item.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';

Widget productsWidget(ProductEntity entity) {
  final BasketController basketController = Get.find();
  var theme = Get.theme;
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
                height: fullHeight / 7.6,
                child: imageWidget(entity.masterImage, fit: BoxFit.contain),
              ),
              SizedBox(height: standardSize),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  entity.name,
                  maxLines: 1,
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
                        text: ' ريال',
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
                            AppColors.borderColor,
                          ),
                        );
                      })
                ],
              ),
            ]));
      });
}

Widget productsDeskWebWidget(ProductEntity entity) {
  final BasketController basketController = Get.find();
  var theme = Get.theme;
  // TextEditingController counterTextController =
  //     TextEditingController(text: '1');
  // RxInt counter = 1.obs;
  var height = MediaQuery.of(Get.context!).size.height;
  var width = MediaQuery.of(Get.context!).size.width;
  return ValueListenableBuilder(
      valueListenable: Boxes.getBasketBox().listenable(),
      builder: (context, box, widget) {
        return Container(
            padding: EdgeInsets.only(
                left: width / 90,
                right: width / 90,
                bottom: width / 90,
                top: width / 90),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(width/95),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: -4,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: imageWebWidget(entity.masterImage, radius: width/100, fit: BoxFit.contain),
              ),
              SizedBox(height: width/70),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  entity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: width/77,
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
                            ?.copyWith(fontWeight: FontWeight.bold,
                          fontSize: width/80
                        ),
                      ),
                      TextSpan(
                        text: ' ريال',
                        style: theme.textTheme.caption?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.captionTextColor,
                          fontSize: width/84,

                        ),
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
                              height: width/55,
                              width: width/55,
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
                            height: width/55,
                            width: width/55,
                            color:
                            AppColors.borderColor,
                          ),
                        );
                      })
                ],
              ),
            ]));
      });
}

Widget productsTabletWebWidget(ProductEntity entity) {
  final BasketController basketController = Get.find();
  var theme = Get.theme;
  // TextEditingController counterTextController =
  //     TextEditingController(text: '1');
  // RxInt counter = 1.obs;
  var height = MediaQuery.of(Get.context!).size.height;
  var width = MediaQuery.of(Get.context!).size.width;
  return ValueListenableBuilder(
      valueListenable: Boxes.getBasketBox().listenable(),
      builder: (context, box, widget) {
        return Container(
            padding: EdgeInsets.only(
                left: width / 82,
                right: width / 82,
                bottom: width / 82,
                top: width / 82),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(width/95),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: -4,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: imageWebWidget(entity.masterImage, radius: width/100, fit: BoxFit.contain),
              ),
              SizedBox(height: width/70),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  entity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: width/67,
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
                            ?.copyWith(fontWeight: FontWeight.bold,
                          fontSize: width/70
                        ),
                      ),
                      TextSpan(
                        text: ' ريال',
                        style: theme.textTheme.caption?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.captionTextColor,
                          fontSize: width/73,

                        ),
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
                              height: width/48,
                              width: width/48,
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
                            height: width/48,
                            width: width/48,
                            color:
                            AppColors.borderColor,
                          ),
                        );
                      })
                ],
              ),
            ]));
      });
}
