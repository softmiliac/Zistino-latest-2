import 'package:recycling_machine/src/presentation/ui/sec/profile/view/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pandabar/model.dart';
import 'package:recycling_machine/src/presentation/ui/sec/transaction/view/transaction_page.dart';
import '../../../../style/colors.dart';
import '../../../map_page/view/map_page.dart';
import '../../../sec/wallet/view/wallet_page.dart';
import '../../home_page/view/home_page.dart';
import '../controller/main_controller.dart';
import 'package:get/get.dart';
import 'package:pandabar/main.view.dart';

class MainPage extends GetView<MainPageController> with WidgetsBindingObserver {
  MainPage({Key? key, this.selectedIndex = 0}) : super(key: key);

  final int selectedIndex;

  final ThemeData theme = Get.theme;

  @override
  final MainPageController controller = Get.put(MainPageController());

  @override
  Widget build(BuildContext context) {
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
                        "assets/ic_wallet.svg",
                        color: controller.selectedIndex.value == 1
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ),
                      title: Text(
                        'کیف پول',
                        style: theme.textTheme.caption!.copyWith(
                          fontSize: 10,
                          color: controller.selectedIndex.value == 1
                              ? theme.primaryColor
                              : AppColors.captionColor,
                        ),
                      )),
                  PandaBarButtonData(
                      id: 2,
                      icon: SvgPicture.asset(
                        "assets/ic_receipt-add.svg",
                        color: controller.selectedIndex.value == 2
                            ? theme.primaryColor
                            : AppColors.captionColor,
                      ),
                      title: Text(
                        'ثبت درخواست',
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

                ],fabIcon: SvgPicture.asset('assets/ic_recycle_driver.svg'),
                onChange: (id) {
                  controller.selectedIndex.value = id;
                },
                fabColors: [theme.primaryColor, theme.primaryColor],
                onFabButtonPressed: () {
                  Get.off( MapPage());
                },
              )),
          extendBody: true,
          body: body(),
        ));
  }

  Widget body() {
    return Obx(() {
      switch (controller.selectedIndex.value) {
        case 0:
          controller.searchTextController.clear();
          controller.walletRepository.getUserTotal();

          return HomePage();
        case 1:
          controller.searchTextController.clear();
          return TransactionPage();

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
}

