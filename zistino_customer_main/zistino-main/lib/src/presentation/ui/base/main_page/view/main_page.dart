// ignore_for_file: deprecated_member_use

import 'package:zistino/src/presentation/ui/map_page/view/map_page.dart';
import 'package:zistino/src/presentation/ui/sec/profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pandabar/model.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../../../data/models/base/lazy_rqm.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../wallet/view/wallet_page.dart';
import '../../home_page/binding/binding.dart';
import '../../home_page/view/home_page.dart';
import '../../products_page/binding/products_binding.dart';
import '../../products_page/view/products_page.dart';
import '../controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:pandabar/main.view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final ThemeData theme = Get.theme;
  final MainPageController controller = Get.put(MainPageController());

  @override
  void initState() {
    // initTarget();
    // WidgetsBinding.instance.addPostFrameCallback(afterLayout);
    // controller.pref.showTutorial = false;
    if (controller.pref.showTutorial == true &&
            controller.pref.addresses.isEmpty ||
        controller.pref.addresses == null) {
      initTarget();

      WidgetsBinding.instance.addPostFrameCallback(afterLayout);
    }
      controller.pref.showTutorial = false;
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
        hideSkip: true)
      ..show(context: context);
  }

  void afterLayout(_) {
    Future.delayed(const Duration(milliseconds: 100));
    showTutorial();
  }

  @override
  Widget build(BuildContext context) {

    debugPrint('${controller.pref.showTutorial} Tt');

    ProductsBinding().dependencies();
    HomeBinding().dependencies();

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
          body: Stack(
            children: [
              Positioned.fill(
                  left: 0, right: 0, bottom: 0, top: 0, child: body()),

              Align(
                alignment: const Alignment(0.38, 0.97),
                child: SizedBox(
                  height: xLargeSize * 1.2,
                  width: xLargeSize * 1.2,
                  key: controller.shop,
                ),
              ),
              Align(
                alignment: const Alignment(0.0, 0.86),
                child: SizedBox(
                  height: xxLargeSize,
                  width: xxLargeSize,
                  key: controller.request,
                ),
              ),
              Align(
                alignment: const Alignment(-0.38, 0.97),
                child: SizedBox(
                  height: xLargeSize * 1.2,
                  width: xLargeSize * 1.2,
                  key: controller.walletRequest,
                ),
              ),
            ],
          ),
        ));
  }

  Widget body() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          // controller.searchTextController.clear();
          controller.addressRepository.fetchAll();
          controller.walletRepository.getUserTotal();
          controller.productRepository.getCategories1();
          controller.addressRepository.fetchAllZones(LazyRQM(
              pageNumber: 1,
              pageSize: 50,
              brandId: null,
              keyword: '',
              orderBy: ['']));
          return HomePage();
        case 1:
          return const ProductsPage();
        case 2:
          // controller.searchTextController.clear();
          return WalletPage();
        case 3:
          // controller.searchTextController.clear();

          return ProfilePage();
        default:
          // controller.searchTextController.clear();

          return HomePage();
      }
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
                            'برای تماشای ادامه راهنمای استفاده از اپلیکیشن کلیک کنید و برای رد کردن راهنما از دکمه «رد کردن» در بالای صفحه استفاده کنید'))),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        focusAnimationDuration: const Duration(milliseconds: 300),
        shape: ShapeLightFocus.RRect,
        radius: xSmallSize,
        identify: 'خرید',
        keyTarget: controller.buy,
        contents: [
          TargetContent(
            child: TutorialContent(
                buttonTitle: 'بعدی',
                name: 'خرید',
                description: 'جهت مشاهده محصولات کلیک کنید'),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        focusAnimationDuration: const Duration(milliseconds: 300),
        shape: ShapeLightFocus.RRect,
        radius: xSmallSize,
        identify: 'استعلام پسماند',
        keyTarget: controller.residue,
        contents: [
          TargetContent(
            child: TutorialContent(
                buttonTitle: 'بعدی',
                name: 'استعلام پسماند',
                description: 'جهت استعلام از مبالغ خرید پسماند کلیک کنید'),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        focusAnimationDuration: const Duration(milliseconds: 300),
        shape: ShapeLightFocus.RRect,
        radius: smallRadius,
        identify: 'کیف پول',
        keyTarget: controller.wallet,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: TutorialContent(
                buttonTitle: 'بعدی',
                name: 'کیف پول',
                description:
                    'جهت اطلاع از جزئیات کیف پول خود و  مشاهده سوابق تراکنشات خود کلیک کنید'),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        focusAnimationDuration: const Duration(milliseconds: 300),
        identify: 'فروشگاه',
        keyTarget: controller.shop,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: TutorialContent(
                buttonTitle: 'بعدی',
                name: 'فروشگاه',
                description: 'جهت مشاهده محصولات کلیک کنید'),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        identify: 'ثبت درخواست',
        focusAnimationDuration: const Duration(milliseconds: 300),
        keyTarget: controller.request,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: TutorialContent(
                buttonTitle: 'بعدی',
                name: 'درخواست جمع آوری',
                description:
                    'برای ثبت درخواست جمع آوری پسماند از این بخش استفاده کنید'),
          ),
        ],
      ),
    );
    controller.targets.add(
      TargetFocus(
        shape: ShapeLightFocus.Circle,
        identify: 'درخواست برداشت',
        focusAnimationDuration: const Duration(milliseconds: 300),
        keyTarget: controller.walletRequest,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: TutorialContent(
                hasSkip: false,
                buttonTitle: 'پایان',
                name: 'درخواست برداشت وجه',
                description:
                    'جهت ثبت درخواست برداشت وجه از کیف پول خود از این بخش استفاده کنید'),
          ),
        ],
      ),
    );
  }
}

class TutorialContent extends StatelessWidget {
  String name, description, buttonTitle = 'بعدی';
  final MainPageController controller = Get.put(MainPageController());
  final bool hasSkip;

  TutorialContent(
      {Key? key,
      required this.name,
      required this.description,
      required this.buttonTitle,
      this.hasSkip = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.tutorialCoachMark.next();
      },
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: smallSize, vertical: smallSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name,
                style: Get.theme.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: xSmallSize),
            Text(
              description,
              style:
                  Get.theme.textTheme.bodyText1?.copyWith(color: Colors.white),
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
                    controller.tutorialCoachMark.next();
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
                    onPressed: controller.tutorialCoachMark.skip,
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
      ),
    );
  }
}
