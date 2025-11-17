// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:zistino/src/domain/entities/pro/product_entity.dart';
import 'package:zistino/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:badges/badges.dart' as prefix;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../../../common/utils/close_keyboard.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/search_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../inv/checkout_page/page/checkout_page.dart';
import '../controller/products_controller.dart';
import '../widgets/categories_widget.dart';
import '../widgets/products_widget.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<StatefulWidget> createState() => ProductsPageState();
}

class ProductsPageState extends State<ProductsPage>
    with WidgetsBindingObserver {
  final ThemeData theme = Get.theme;
  final BasketController basketController = Get.find();
  final ProductsController controller = Get.find();

  @override
  void initState() {
    if (controller.pref.showTutorialProducts == true) {
      initTarget();
      WidgetsBinding.instance.addPostFrameCallback(afterLayout);
      controller.pref.showTutorialProducts = false;
    }
    super.initState();
  }

  void showTutorial() {
    controller.tutorialCoachMark = TutorialCoachMark(
      targets: controller.targets,
      colorShadow: Colors.black,
      opacityShadow: 0.7,
      paddingFocus: 5,
      textStyleSkip: const TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
      hideSkip: true,
    )..show(context: context);
  }

  void afterLayout(_) {
    Future.delayed(const Duration(milliseconds: 100));
    showTutorial();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductsController>(
        init: controller,
        initState: (state) => controller.fetchProducts(),
        builder: (_) {
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
                              Get.off(CheckoutPage(
                                id: '',
                              ));
                            },
                            child: prefix.Badge(
                              toAnimate: true,

                              showBadge: basketController.box.values.isNotEmpty
                                  ? true
                                  : false,
                              position: prefix.BadgePosition(
                                  top: basketController.box.values.length > 50
                                      // badgeNumber != null && badgeNumber > 50
                                      ? -xSmallSize
                                      : xSmallSize,
                                  end: basketController.box.values.length > 50
                                      // badgeNumber != null && badgeNumber > 99
                                      ? -xSmallSize
                                      : standardSize * 1.5),
                              alignment: Alignment.center,
                              animationType: prefix.BadgeAnimationType.scale,
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
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: RefreshIndicator(
                        onRefresh: () => controller.fetchProducts(),
                        color: theme.primaryColor,
                        edgeOffset: -largeSize,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics()),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (controller.pref.getCategory.isNotEmpty)
                                SizedBox(height: standardSize),
                              if (controller.pref.getCategory.isNotEmpty)
                                SizedBox(
                                  height: xxLargeSize,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: EdgeInsetsDirectional.only(
                                        start: standardSize),
                                    itemCount:
                                        controller.pref.getCategory.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        categoriesWidget(
                                            controller.pref.getCategory[index],
                                            index),
                                  ),
                                ),
                              SizedBox(height: standardSize),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: standardSize),
                                  child: SearchWidget(
                                      onChange: (value) {
                                        controller.changeSearchText(value);
                                        controller.update();
                                      },
                                      textEditingController: controller
                                          .mainPageController
                                          .searchTextController,
                                      onTapClear: () {
                                        if (controller
                                            .isBusyGetProducts.isFalse) {
                                          controller.mainPageController
                                              .searchTextController
                                              .clear();
                                          controller.searchingText.value = '';
                                          // controller.fetchProducts();
                                          controller.update();
                                        }
                                      })),
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
                                            controller.rpm?[index] ??
                                                ProductEntity());
                                      }),
                                  onEmpty: emptyWidget('محصولی وجود ندارد'),
                                  onError: (error) => errorWidget(
                                      error.toString(),
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
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.0, -1.3),
                      child: SizedBox(
                        height: 0,
                        width: 0,
                        key: controller.tutorial,
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0.21, -0.045),
                      child: SizedBox(
                        height: xLargeSize,
                        width: xLargeSize,
                        key: controller.addCart,
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-0.96, -1.15),
                      child: SizedBox(
                        height: xLargeSize,
                        width: xLargeSize,
                        key: controller.checkOut,
                      ),
                    ),
                  ],
                ),
                // ;
                // }),
              ),
            ),
          );
        });
  }

  void initTarget() {
    controller.targets.add(
      TargetFocus(
        focusAnimationDuration: const Duration(milliseconds: 300),
        shape: ShapeLightFocus.RRect,
        radius: xSmallSize,
        identify: 'راهنما',
        paddingFocus: 0,
        enableTargetTab: false,
        enableOverlayTab: false,
        color: Colors.black,
        keyTarget: controller.tutorial,
        contents: [
          TargetContent(
            padding: const EdgeInsets.all(0),
            child: GestureDetector(
                onTap: () {
                  controller.tutorialCoachMark.next();
                },
                child: Container(
                    height: fullHeight,
                    color: Colors.transparent,
                    child: TutorialContent(
                        name: 'راهنما',
                        buttonTitle: 'بعدی',
                        description:
                            'برای تماشای ادامه راهنمای صفحۀ فروشگاه کلیک کنید و برای رد کردن راهنما از دکمه «رد کردن» در بالای صفحه استفاده کنید'))),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        focusAnimationDuration: const Duration(milliseconds: 300),
        shape: ShapeLightFocus.Circle,
        identify: 'افزودن به سبد خرید',
        keyTarget: controller.addCart,
        contents: [
          TargetContent(
            child: TutorialContent(
                buttonTitle: 'بعدی',
                name: 'افزودن به سبد خرید',
                description:
                    'جهت افزودن محصول به سبد خرید از این گزینه استفاده کنید'),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        focusAnimationDuration: const Duration(milliseconds: 300),
        shape: ShapeLightFocus.Circle,
        radius: xSmallSize,
        identify: 'سبد خرید',
        keyTarget: controller.checkOut,
        contents: [
          TargetContent(
            child: TutorialContent(
                hasSkip: false,
                buttonTitle: 'پایان',
                name: 'سبد خرید',
                description:
                    'جهت مشاهده جزئیات سبد خرید و تکمیل فرآیند خرید از این گزینه استفاده کنید'),
          ),
        ],
      ),
    );
  }
}

class TutorialContent extends StatelessWidget {
  String name, description, buttonTitle = 'بعدی';
  ProductsController productsController = Get.find();
  bool hasSkip;

  TutorialContent(
      {super.key,
      required this.name,
      required this.description,
      required this.buttonTitle,
      this.hasSkip = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: smallSize, vertical: smallSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name,
              style: Get.theme.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: xSmallSize),
          Text(
            description,
            style: Get.theme.textTheme.bodyText1?.copyWith(color: Colors.white),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    padding: EdgeInsets.symmetric(
                        horizontal: smallSize, vertical: xSmallSize),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(smallRadius)),
                    primary: AppColors.primaryColor),
                onPressed: () {
                  productsController.tutorialCoachMark.next();
                },
                child: Text(
                  buttonTitle,
                  style: Get.theme.textTheme.bodyText1
                      ?.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(width: smallSize),
              if (hasSkip)
                ElevatedButton(
                  onPressed: productsController.tutorialCoachMark.skip,
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: EdgeInsets.symmetric(
                          horizontal: smallSize, vertical: xSmallSize),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(smallRadius)),
                      primary: Get.theme.primaryColor),
                  child: Text('رد کردن',
                      style: Get.theme.textTheme.bodyText1
                          ?.copyWith(color: Colors.white)),
                ),
            ],
          )
        ],
      ),
    );
  }
}
