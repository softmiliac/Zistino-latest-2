import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../domain/entities/base/home_entity.dart';
import '../../../../../domain/entities/inv/basket_item.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/image_widget.dart';
import '../../../inv/basket_controller/basket_controller.dart';

Widget productListHomePhone(List<ProductSectionEntity> entity) {
  return entity.length == null ? const SizedBox() : SizedBox(
    // height: fullWidth/1.5,
    height: MediaQuery.of(Get.context!).size.width/1.5,

    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsetsDirectional.only(
          start: 16),
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
            width: MediaQuery.of(Get.context!).size.width / 2.3,
            height: MediaQuery.of(Get.context!).size.height / 3.4,
            padding: EdgeInsets.only(
              right: 16,
              left: 16,
              bottom: 16,
              top: 16,
            ),
            margin: EdgeInsetsDirectional.only(
              end: 16,
              // left: standardSize,
              bottom: 16,
            ),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: -4,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: MediaQuery.of(Get.context!).size.height / 7.2,
                child: imageWidget(entity.productModel?.masterImage ?? '', fit: BoxFit.contain),
              ),
              SizedBox(height: 16),
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
                        text: formatNumber(entity.productModel?.masterPrice ?? 0),
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
      }
  );
}

Widget productListHomeDesktop(List<ProductSectionEntity> entity) {
  return entity.length == null ? const SizedBox() : SizedBox(
    height: 100,

    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding:const EdgeInsetsDirectional.only(
          start: 20),
      scrollDirection: Axis.horizontal,
      itemCount: entity.length,

      itemBuilder: (context, index) => _productsDesktopWidget(entity[index]),
    ),
  );
}

Widget _productsDesktopWidget(ProductSectionEntity entity) {
  final BasketController basketController = Get.find();
  var a = MediaQuery.of(Get.context!).size.width;
  var theme = Get.theme;
  // TextEditingController counterTextController =
  //     TextEditingController(text: '1');
  // RxInt counter = 1.obs;
  return ValueListenableBuilder(
      valueListenable: Boxes.getBasketBox().listenable(),
      builder: (context, box, widget) {
        return Container(
          margin: EdgeInsetsDirectional.only(end: a/90),
          width: a/8,
            padding: EdgeInsets.all(
                a/90
            ),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(a/150),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: -4,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              imageWebWidget(entity.productModel?.masterImage?? '', radius: a/150, fit: BoxFit.contain,
              width: a/8.5,
                height: a/8.5

              ),
              SizedBox(height: a/100),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  entity.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText1?.copyWith(
                    fontSize: a/100,
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
                            ?.copyWith(
                            fontSize: a/100,

                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ريال',
                        style: theme.textTheme.caption?.copyWith(
                            fontSize: a/100,
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
                                masterImage: entity.productModel?.masterImage?? '',
                                name: entity.name,
                                discountPercent: entity.productModel?.discountPercent ??0,
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
                            width: a/60,
                            height: a/60,
                          ),
                        ):

                        GestureDetector(
                          onTap: () {
                            var item = BasketItem(
                                id: entity.productModel?.id ?? '',
                                price: entity.productModel?.masterPrice ?? 0,
                                masterImage: entity.productModel?.masterImage ?? '',
                                name: entity.name,
                                discountPercent: entity.productModel?.discountPercent ?? 0,
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
                            width: a/60,
                            height: a/60,
                          ),
                        );
                      })
                ],
              ),
            ]));
      });
}
Widget productListHomeTablet(List<ProductSectionEntity> entity) {
  return entity.length == null ? const SizedBox() : SizedBox(
    height: 100,

    child: ListView.builder(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      padding:const EdgeInsetsDirectional.only(
          start: 20),
      scrollDirection: Axis.horizontal,
      itemCount: entity.length,

      itemBuilder: (context, index) => _productsTabletWidget(entity[index]),
    ),
  );
}

Widget _productsTabletWidget(ProductSectionEntity entity) {
  final BasketController basketController = Get.find();
  var a = MediaQuery.of(Get.context!).size.width;
  var theme = Get.theme;
  // TextEditingController counterTextController =
  //     TextEditingController(text: '1');
  // RxInt counter = 1.obs;
  return ValueListenableBuilder(
      valueListenable: Boxes.getBasketBox().listenable(),
      builder: (context, box, widget) {
        return Container(
            margin: EdgeInsetsDirectional.only(end: a/90),
            width: a/4,
            padding: EdgeInsets.all(
                a/90
            ),
            decoration: BoxDecoration(
                color: theme.backgroundColor,
                borderRadius: BorderRadius.circular(a/120),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      spreadRadius: -4,
                      blurRadius: 10,
                      offset: Offset(0, 3))
                ]),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              imageWebWidget(entity.productModel?.masterImage?? '', radius: a/120, fit: BoxFit.contain,
                  width: a/4.5,
                  height: a/4.5

              ),
              SizedBox(height: a/100),
              Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  entity.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyText1?.copyWith(
                      fontSize: a/60,
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
                            ?.copyWith(
                            fontSize: a/60,

                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ريال',
                        style: theme.textTheme.caption?.copyWith(
                            fontSize: a/60,
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
                                masterImage: entity.productModel?.masterImage?? '',
                                name: entity.name,
                                discountPercent: entity.productModel?.discountPercent ??0,
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
                            width: a/40,
                            height: a/40,
                          ),
                        ):

                        GestureDetector(
                          onTap: () {
                            var item = BasketItem(
                                id: entity.productModel?.id ?? '',
                                price: entity.productModel?.masterPrice ?? 0,
                                masterImage: entity.productModel?.masterImage ?? '',
                                name: entity.name,
                                discountPercent: entity.productModel?.discountPercent ?? 0,
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
                            width: a/35,
                            height: a/35,
                          ),
                        );
                      })
                ],
              ),
            ]));
      });
}