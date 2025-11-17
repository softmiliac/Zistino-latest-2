import 'package:admin_dashboard/src/domain/entities/pro/product_entity.dart';
import 'package:admin_dashboard/src/presentation/ui/base/responsive_layout_base/responsive_layout_base.dart';
import 'package:admin_dashboard/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../binding/products_binding.dart';
import '../controller/products_controller.dart';
import '../widgets/categories_widget.dart';
import '../widgets/products_widget.dart';

class ProductsPage extends GetResponsiveView<ProductsController> {
  ProductsPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;
  var context = Get.context!;
  final BasketController basketController = Get.find();

  @override
  Widget desktop() {
    // ProductsBinding().dependencies();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // return GetBuilder<ProductsController>(
    //     init: controller,
    //     initState: (state) => controller.fetchProducts(),
    //     builder: (_) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => closeKeyboard(context),
        child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width/90),
                Container(
                  // alignment: AlignmentDirectional.centerStart,
                  // width: fullWidth/3.3,
                    margin:
                    EdgeInsets.symmetric(horizontal: width / 39),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: SizedBox(
                            height: width / 29,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(
                                  end: xSmallSize),
                              itemCount:
                              controller.pref.getCategory.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  categoriesWidget(
                                      controller.pref.getCategory[index],
                                      index,
                                      isDesktop: true),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: width / 31,
                            child: SearchWidget(
                                isDesktop: true,
                                onFieldSubmitted: (value) {
                                  controller.fetchProducts();
                                },
                                textEditingController: controller
                                    .mainPageController
                                    .searchTextController,
                                onTapClear: () {
                                  controller.mainPageController
                                      .searchTextController
                                      .clear();
                                  controller.fetchProducts();
                                  controller.update();
                                }),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: width/60),
                controller.obx(
                        (state) => GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:5,
                            childAspectRatio: 12 / 18,
                            mainAxisSpacing: width/43,
                            crossAxisSpacing: width/43),
                        itemCount: controller.rpm?.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 39),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return productsDeskWebWidget(
                              controller.rpm?[index] ?? ProductEntity());
                        }),
                    onEmpty:
                    emptyWidget('محصولی وجود ندارد', isDesktop: true),
                    onError: (error) => errorWidget(error.toString(),
                        onTap: () => controller.mainPageController
                            .searchTextController.text.isEmpty
                            ? controller.fetchProducts()
                            : controller.fetchProducts()),
                    onLoading: loadingWidget()),
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
        // });
  }

  @override
  Widget phone() {
    // ProductsBinding().dependencies();
    // return GetBuilder<ProductsController>(
    //     init: controller,
    //     initState: (state) => controller.fetchProducts(),
    //     builder: (_) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: GestureDetector(
              onTap: () => closeKeyboard(context),
              child: Scaffold(
                backgroundColor: AppColors.homeBackgroundColor,
                appBar: AppBar(
                  actions: [
                    ValueListenableBuilder(
                        valueListenable: Boxes.getBasketBox().listenable(),
                        builder: (context, box, widget) {
                          return GestureDetector(
                            onTap: () {
                              Get.offNamed(Routes.checkOutPage);
                            },
                            child: Badge(
                              toAnimate: true,

                              showBadge: basketController.box.values.isNotEmpty
                                  ? true
                                  : false,
                              position: BadgePosition(
                                  top: basketController.box.values.length > 50
                                      // badgeNumber != null && badgeNumber > 50
                                      ? -xSmallSize
                                      : xSmallSize,
                                  end: basketController.box.values.length > 50
                                      // badgeNumber != null && badgeNumber > 99
                                      ? -xSmallSize
                                      : standardSize * 1.5),
                              alignment: Alignment.center,
                              animationType: BadgeAnimationType.scale,
                              animationDuration:
                                  const Duration(milliseconds: 350),
                              badgeContent: Text(
                                basketController.box.values.length.toString(),
                                style: theme.textTheme.overline?.copyWith(
                                  letterSpacing: 0.2,
                                  color: Colors.white,
                                ),
                              ),
                              badgeColor: theme.primaryColor,
                              padding: EdgeInsets.all(xxSmallSize),
                              // position: BadgePosition.topEnd(),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                width: xxLargeSize / 1.15,
                                height: xxLargeSize / 1.15,
                                padding:
                                    EdgeInsetsDirectional.all(smallSize / 1.05),
                                child: SvgPicture.asset('assets/ic_store.svg',
                                    color:
                                        basketController.box.values.isNotEmpty
                                            ? theme.primaryColor
                                            : AppColors.captionColor),
                              ),
                            ),
                          );
                        }),

/*
                    IconButton(
                        splashColor: AppColors.splashColor,
                        splashRadius: standardRadius,
                        onPressed: () {
                          Get.off(CheckoutPage(
                            id: '',
                          ));
                        },
                        icon: SvgPicture.asset('assets/ic_store.svg',
                            color: AppColors.primaryColor))
*/
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
                          child: SearchWidget(
                              onFieldSubmitted: (value) {
                                controller.fetchProducts();
                              },
                              textEditingController: controller
                                  .mainPageController.searchTextController,
                              onTapClear: () {
                                controller
                                    .mainPageController.searchTextController
                                    .clear();
                                controller.fetchProducts();
                                controller.update();
                              })),
                      SizedBox(height: standardSize),
                      SizedBox(
                        height: xxLargeSize,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding:
                              EdgeInsetsDirectional.only(start: standardSize),
                          itemCount: controller.pref.getCategory.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => categoriesWidget(
                              controller.pref.getCategory[index], index),
                        ),
                      ),
                      SizedBox(height: standardSize),
                      controller.obx(
                          (state) => GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 10 / 14,
                                      mainAxisSpacing: standardSize,
                                      crossAxisSpacing: standardSize),
                              itemCount: controller.rpm?.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.symmetric(
                                  horizontal: standardSize),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return productsWidget(
                                    controller.rpm?[index] ?? ProductEntity());
                              }),
                          onEmpty: emptyWidget('محصولی وجود ندارد'),
                          onError: (error) => errorWidget(error.toString(),
                              onTap: () => controller.mainPageController
                                      .searchTextController.text.isEmpty
                                  ? controller.fetchProducts()
                                  : controller.fetchProducts()),
                          onLoading: loadingWidget()),
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
        // });
  }

  @override
  Widget tablet() {
    // ProductsBinding().dependencies();
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // return GetBuilder<ProductsController>(
    //     init: controller,
    //     initState: (state) => controller.fetchProducts(),
    //     builder: (_) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () => closeKeyboard(context),
        child: Scaffold(
          backgroundColor: AppColors.homeBackgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width/90),
                Container(
                  // alignment: AlignmentDirectional.centerStart,
                  // width: fullWidth/3.3,
                    margin:
                    EdgeInsets.symmetric(horizontal: width / 39),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: SizedBox(
                            height: width / 29,
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsetsDirectional.only(
                                  end: xSmallSize),
                              itemCount:
                              controller.pref.getCategory.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  categoriesWidget(
                                      controller.pref.getCategory[index],
                                      index,
                                      isDesktop: true),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: width / 31,
                            child: SearchWidget(
                                isDesktop: true,
                                onFieldSubmitted: (value) {
                                  controller.fetchProducts();
                                },
                                textEditingController: controller
                                    .mainPageController
                                    .searchTextController,
                                onTapClear: () {
                                  controller.mainPageController
                                      .searchTextController
                                      .clear();
                                  controller.fetchProducts();
                                  controller.update();
                                }),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: width/60),
                controller.obx(
                        (state) => GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 12 / 18,
                            mainAxisSpacing: width/43,
                            crossAxisSpacing: width/43),
                        itemCount: controller.rpm?.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 39),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return productsTabletWebWidget(
                              controller.rpm?[index] ?? ProductEntity());
                        }),
                    onEmpty:
                    emptyWidget('محصولی وجود ندارد', isDesktop: true),
                    onError: (error) => errorWidget(error.toString(),
                        onTap: () => controller.mainPageController
                            .searchTextController.text.isEmpty
                            ? controller.fetchProducts()
                            : controller.fetchProducts()),
                    onLoading: loadingWidget()),
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
    // });
  }
}
