import 'package:recycling_machine/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:recycling_machine/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/text_field_edit_profile_widget.dart';
import '../../../inv/checkout_page/page/checkout_page.dart';
import '../../home_page/widgets/product_widget.dart';
import '../binding/search_binding.dart';
import '../controller/shop_controller.dart';

class ShopPage extends ResponsiveLayoutBaseGetView<ShopController> {
  ShopPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;

  final BasketController basketController = Get.find();

  @override
  Widget build(BuildContext context) {
    ShopBinding().dependencies();
    return responsiveWidget(context);
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
  }

  @override
  Widget mobile(BuildContext context) {
    // Future<bool> onBackClicked() {
    //   controller.searchTextController.clear();
    //   return Future.value(false);
    // }
    return GetBuilder<ShopController>(
        init: controller,
        initState: (state) => controller.fetchProductsData(),
        builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              onTap: () => closeKeyboard(context),
              child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  actions: [
                    IconButton(
                        splashColor: AppColors.splashColor,
                        splashRadius: standardRadius,
                        onPressed: () {
                          Get.to(CheckoutPage(
                            id: '',
                          ));
                        },
                        icon: SvgPicture.asset('assets/ic_store.svg',
                            color: AppColors.primaryColor))
                  ],
                  automaticallyImplyLeading: false,
                  elevation: 0.3,
                  toolbarHeight: fullWidth / 5.5,
                  shadowColor: AppColors.shadowColor,
                  centerTitle: true,
                  title: Text('فـروشگـاه',
                      style: theme.textTheme.subtitle1
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  backgroundColor: theme.backgroundColor,
                ),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: largeSize),
                      Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: standardSize),
                          child: TextFormFieldEditProfileWidget(
                            textEditingController: controller
                                .mainPageController.searchTextController,
                            hint: "جستجــو...",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(xSmallRadius),
                                borderSide: BorderSide.none),
                            disableBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(xSmallRadius),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(xSmallRadius),
                                borderSide: BorderSide.none),
                            enableBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(xSmallRadius),
                                borderSide: BorderSide.none),
                            padding:
                                EdgeInsetsDirectional.only(start: standardSize),
                            onTap: () {
                              '${controller.mainPageController.searchTextController.text} ';
                              debugPrint('asd');
                            },
                            onFieldSubmitted: (value) {
                              controller.fetchProductsDataWithSearch();
                            },
                          )),
                      SizedBox(height: standardSize),
                      controller.obx(
                          (state) => GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 9 / 14,
                                      mainAxisSpacing: standardSize,
                                      crossAxisSpacing: standardSize),
                              itemCount: controller.rpm?.data.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: standardSize),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return productWidget(
                                    controller.rpm?.data[index] ?? ProductEntity());
                              }),
                          onLoading: SizedBox(
                              width: fullWidth,
                              height: fullHeight / 1.5,
                              child: const CupertinoActivityIndicator())),
                      const SizedBox(
                          height: kBottomNavigationBarHeight +
                              kBottomNavigationBarHeight)
                    ],
                  ),
                ),
                // ;
                // }),
              ),
            ),
          );
        });
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }
}
