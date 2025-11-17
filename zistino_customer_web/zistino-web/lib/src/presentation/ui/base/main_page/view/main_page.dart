import 'package:admin_dashboard/src/presentation/ui/map_page/view/map_page.dart';
import 'package:admin_dashboard/src/presentation/ui/sec/profile/view/profile_page.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pandabar/model.dart';
import '../../../../../common/utils/hive_utils/hive_utils.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
import '../../../inv/basket_controller/basket_controller.dart';
import '../../../inv/checkout_page/page/checkout_page.dart';
import '../../../wallet/view/wallet_page.dart';
import '../../home_page/view/home_page.dart';
import '../../products_page/view/products_page.dart';
import '../controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:pandabar/main.view.dart';

class MainPage extends GetResponsiveView<MainPageController>
    with WidgetsBindingObserver {
  MainPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  final int selectedIndex;

  final ThemeData theme = Get.theme;

  @override
  final MainPageController controller = Get.put(MainPageController());
  final BasketController basketController = Get.find();
  //
  // @override
  // Widget build(BuildContext context) {
  //   return responsiveWidget(context);
  // }

  @override
  Widget desktop() {
    return WillPopScope(
        onWillPop: controller.onBackClicked,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.3,
            // toolbarHeight: fullHeight / 9,
            toolbarHeight: MediaQuery.of(Get.context!).size.height / 9,
            shadowColor: AppColors.shadowColor,
            centerTitle: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        // height: fullHeight / 22,
                        height: MediaQuery.of(Get.context!).size.height / 22,
                        // width: fullHeight / 22,
                        width: MediaQuery.of(Get.context!).size.height / 22,
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsetsDirectional.only(end: 8),
                        decoration: BoxDecoration(
                            color: theme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.shadowColor,
                                  spreadRadius: 0.5,
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ]),
                        child: Image.asset('assets/pic_white_logo.png'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('سلام دوست عزیز',
                              style: theme.textTheme.bodyText2
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          Text('خوش آمدید به زیستـینــو',
                              style: theme.textTheme.overline?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0,
                                  color: AppColors.captionTextColor)),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      navigationItemWeb('خانه', 0),
                      navigationItemWeb('فروشگاه', 1),
                      navigationItemWeb('ثبت درخواست', 2),
                      navigationItemWeb('درخواست تصویه', 3),
                      navigationItemWeb('پروفایل', 4),
                    ],
                  ),
                ),
                Expanded(flex: 3, child: Container(
                  margin: const EdgeInsetsDirectional.only(end: 4/4),
                  alignment: AlignmentDirectional.centerEnd,
                  width: 24,
                  height: 24,
                  child: ValueListenableBuilder(
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
                                top: basketController.box.values.length >
                                    50
                                // badgeNumber != null && badgeNumber > 50
                                    ? -8
                                    : -6,
                                end: basketController.box.values.length >
                                    50
                                // badgeNumber != null && badgeNumber > 99
                                    ? -8
                                    : 16),
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
                            padding: const EdgeInsets.all(2),
                            // position: BadgePosition.topEnd(),
                            child: SvgPicture.asset('assets/ic_store.svg',
                                color:
                                basketController.box.values.isNotEmpty
                                    ? theme.primaryColor
                                    : AppColors.captionColor),
                          ),
                        );
                      }),
                ))
              ],
            ),
          ),
          extendBody: true,
          body: bodyWeb(),
        ));
  }

  @override
  Widget phone() {
    return WillPopScope(
        onWillPop: controller.onBackClicked,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const SizedBox(),
            toolbarHeight: 0,
          ),
          bottomNavigationBar: Obx(() => PandaBar(
                backgroundColor: theme.backgroundColor,
                buttonSelectedColor: theme.primaryColor,
                buttonColor: AppColors.captionColor,
                buttonData: [
                  PandaBarButtonData(
                      id: 0,
                      icon: SvgPicture.asset(
                        "assets/ic_home.svg",
                        color: controller.selectedIndex.value == 0
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ),
                      title: Text(
                        'خانه',
                        style: theme.textTheme.caption!.copyWith(
                          fontSize: 10,
                          color: controller.selectedIndex.value == 0
                              ? theme.primaryColor
                              : AppColors.captionColor,
                        ),
                      )),
                  PandaBarButtonData(
                      id: 1,
                      icon: SvgPicture.asset(
                        "assets/ic_store.svg",
                        color: controller.selectedIndex.value == 1
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ),
                      title: Text('فروشگاه',
                          style: theme.textTheme.caption!.copyWith(
                            fontSize: 10,
                            color: controller.selectedIndex.value == 1
                                ? theme.primaryColor
                                : AppColors.captionColor,
                          ))),
                  PandaBarButtonData(
                      id: 2,
                      icon: SvgPicture.asset(
                        "assets/ic_wallet.svg",
                        color: controller.selectedIndex.value == 2
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ),
                      title: Text(
                        'برداشت وجه',
                        style: theme.textTheme.caption!.copyWith(
                          fontSize: 10,
                          color: controller.selectedIndex.value == 2
                              ? theme.primaryColor
                              : AppColors.captionColor,
                        ),
                      )),
                  PandaBarButtonData(
                      id: 3,
                      icon: SvgPicture.asset(
                        "assets/ic_profile.svg",
                        color: controller.selectedIndex.value == 3
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ),
                      title: Text(
                        'پروفایل',
                        style: theme.textTheme.caption!.copyWith(
                          fontSize: 10,
                          color: controller.selectedIndex.value == 3
                              ? theme.primaryColor
                              : AppColors.captionColor,
                        ),
                      )),
                ],
                onChange: (id) {
                  controller.selectedIndex.value = id;
                },
                fabColors: [theme.primaryColor, theme.primaryColor],
                onFabButtonPressed: () {
                  Get.offAll(MapPage());
                },
              )),
          extendBody: true,
          body: body(),
        ));
  }

  @override
  Widget tablet() {
    return WillPopScope(
        onWillPop: controller.onBackClicked,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const SizedBox(),
            toolbarHeight: 0,
          ),
          bottomNavigationBar: Obx(() => PandaBar(
            backgroundColor: theme.backgroundColor,
            buttonSelectedColor: theme.primaryColor,
            buttonColor: AppColors.captionColor,
            buttonData: [
              PandaBarButtonData(
                  id: 0,
                  icon: SvgPicture.asset(
                    "assets/ic_home.svg",
                    color: controller.selectedIndex.value == 0
                        ? theme.primaryColor
                        : AppColors.captionColor,
                  ),
                  title: Text(
                    'خانه',
                    style: theme.textTheme.caption!.copyWith(
                      fontSize: 10,
                      color: controller.selectedIndex.value == 0
                          ? theme.primaryColor
                          : AppColors.captionColor,
                    ),
                  )),
              PandaBarButtonData(
                  id: 1,
                  icon: SvgPicture.asset(
                    "assets/ic_store.svg",
                    color: controller.selectedIndex.value == 1
                        ? theme.primaryColor
                        : AppColors.captionColor,
                  ),
                  title: Text('فروشگاه',
                      style: theme.textTheme.caption!.copyWith(
                        fontSize: 10,
                        color: controller.selectedIndex.value == 1
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ))),
              PandaBarButtonData(
                  id: 2,
                  icon: SvgPicture.asset(
                    "assets/ic_wallet.svg",
                    color: controller.selectedIndex.value == 2
                        ? theme.primaryColor
                        : AppColors.captionColor,
                  ),
                  title: Text(
                    'برداشت وجه',
                    style: theme.textTheme.caption!.copyWith(
                      fontSize: 10,
                      color: controller.selectedIndex.value == 2
                          ? theme.primaryColor
                          : AppColors.captionColor,
                    ),
                  )),
              PandaBarButtonData(
                  id: 3,
                  icon: SvgPicture.asset(
                    "assets/ic_profile.svg",
                    color: controller.selectedIndex.value == 3
                        ? theme.primaryColor
                        : AppColors.captionColor,
                  ),
                  title: Text(
                    'پروفایل',
                    style: theme.textTheme.caption!.copyWith(
                      fontSize: 10,
                      color: controller.selectedIndex.value == 3
                          ? theme.primaryColor
                          : AppColors.captionColor,
                    ),
                  )),
            ],
            onChange: (id) {
              controller.selectedIndex.value = id;
            },
            fabColors: [theme.primaryColor, theme.primaryColor],
            onFabButtonPressed: () {
              Get.offAll(MapPage());
            },
          )),
          extendBody: true,
          body: body(),
        ));

/*
    return WillPopScope(
        onWillPop: controller.onBackClicked,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.3,
            // toolbarHeight: fullHeight / 9,
            toolbarHeight: MediaQuery.of(Get.context!).size.height / 9,
            shadowColor: AppColors.shadowColor,
            centerTitle: false,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      // height: fullHeight / 22,
                      height: MediaQuery.of(Get.context!).size.height/ 22,
                      // width: fullHeight / 22,
                      width: MediaQuery.of(Get.context!).size.height/ 22,
                      padding: const EdgeInsets.all(4 / 3),
                      margin: const EdgeInsetsDirectional.only(end: 8),
                      decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                                color: AppColors.shadowColor,
                                spreadRadius: 0.5,
                                blurRadius: 4,
                                offset: Offset(0, 2))
                          ]),
                      child: Image.asset('assets/pic_white_logo.png'),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('سلام دوست عزیز',
                            style: theme.textTheme.bodyText2
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text('خوش آمدید به زیستـینــو',
                            style: theme.textTheme.overline?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0,
                                color: AppColors.captionTextColor)),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    navigationItemWeb('خانه', 0),
                    navigationItemWeb('فروشگاه', 1),
                    navigationItemWeb('ثبت درخواست', 2),
                    navigationItemWeb('درخواست تصویه', 3),
                    navigationItemWeb('پروفایل', 4),
                  ],
                ),
                Spacer(),
                Container(
                  margin: const EdgeInsetsDirectional.only(end: 4/4),
                  alignment: AlignmentDirectional.centerEnd,
                  width: MediaQuery.of(Get.context!).size.width/40,
                  height: MediaQuery.of(Get.context!).size.width/40,

                  child: ValueListenableBuilder(
                      valueListenable: Boxes.getBasketBox().listenable(),
                      builder: (context, box, widget) {
                        return GestureDetector(
                          onTap: () {
                            Get.off(CheckoutPage(
                              id: '',
                            ));
                          },
                          child: Badge(
                            toAnimate: true,
                            showBadge: basketController.box.values.isNotEmpty
                                ? true
                                : false,
                            position: BadgePosition(
                                top: basketController.box.values.length >
                                    50
                                // badgeNumber != null && badgeNumber > 50
                                    ? -8
                                    : -4/1.5,
                                end: basketController.box.values.length >
                                    50
                                // badgeNumber != null && badgeNumber > 99
                                    ? -8
                                    : 4),
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
                            padding: const EdgeInsets.all(4/3.5),
                            // position: BadgePosition.topEnd(),
                            child: SvgPicture.asset('assets/ic_store.svg',
                                color:
                                basketController.box.values.isNotEmpty
                                    ? theme.primaryColor
                                    : AppColors.captionColor),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          extendBody: true,
          body: bodyWeb(),
        ));
*/
  }

  Widget body() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          controller.searchTextController.clear();
          controller.addressRepository.fetchAll();
          controller.walletRepository.getUserTotal();
          controller.productRepository.getCategories1();
          return HomePage();
        case 1:
          return ProductsPage();
        case 2:
          controller.searchTextController.clear();

          return WalletPage();
        case 3:
          controller.searchTextController.clear();

          return ProfilePage();
        default:
          controller.searchTextController.clear();

          return HomePage();
      }
    });
  }
  Widget bodyWeb() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          controller.searchTextController.clear();
          controller.addressRepository.fetchAll();
          controller.walletRepository.getUserTotal();
          controller.productRepository.getCategories1();
          controller.searchTextController.clear();
          controller.selectedProfileIndex.value = -1;
          return HomePage();
        case 1:
          controller.selectedProfileIndex.value = -1;
          return ProductsPage();
        case 2:
          controller.searchTextController.clear();
          controller.selectedProfileIndex.value = -1;

          return MapPage();
        case 3:
          controller.selectedProfileIndex.value = -1;
          return WalletPage();
        case 4:
          controller.searchTextController.clear();
          return ProfilePage(selectedIndex: controller.selectedProfileIndex);

        default:
          controller.searchTextController.clear();

          return HomePage();
      }
    });
  }

  Widget navigationItemWeb(String name, int selectedIndex) {
    return Obx(() {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6 / 4),
          splashColor: AppColors.splashColor,
          onTap: () => controller.selectedIndex.value = selectedIndex,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4 , horizontal: 12),
            child: Text(
              name,
              style: theme.textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w600,
                color: controller.selectedIndex.value == selectedIndex
                    ? theme.primaryColor
                    : AppColors.textBlackColor,
              ),
            ),
          ),
        ),
      );
    });
  }
}
