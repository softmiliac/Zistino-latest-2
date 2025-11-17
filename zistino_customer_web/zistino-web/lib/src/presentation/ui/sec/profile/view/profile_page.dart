import 'package:admin_dashboard/src/common/utils/number_format.dart';
import 'package:admin_dashboard/src/presentation/ui/base/invite_page/view/invite_page.dart';
import 'package:admin_dashboard/src/presentation/ui/sec/profile/controller/profle_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/exit_dialog_widget.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../../about_zistino_page/view/about_zistino_page.dart';
import '../../addresses/binding/address_binding.dart';
import '../../addresses/view/addresses_page.dart';
import '../../edit_profile/view/edit_profile_page.dart';
import '../../faq/view/faq_page.dart';
import '../../orders_page/view/orders_page.dart';
import '../../transaction/view/transaction_page.dart';
import '../binding/profile_binding.dart';

class ProfilePage extends GetResponsiveView<ProfileController> {
  ProfilePage({super.key, this.selectedIndex});

  final theme = Get.theme;

  RxInt? selectedIndex = (-1).obs;

  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    ProfileBinding().dependencies();
    AddressBinding().dependencies();
    // selectedIndex?.value = -1;
    return GetBuilder<ProfileController>(
        init: controller,
        initState: (state) {
          controller.getUserInfo();
          controller.fetchWalletData();
        },
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.homeBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(a/60),
                child: Row(
                  children: [
                    Container(
                      height: b,
                      width: a / 4,
                      padding: EdgeInsets.all(a/60 / 1.5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadiusDirectional.circular(a/80)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: b / 9,
                                height: b / 9,
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        width: b / 9,
                                        height: b / 9,
                                        padding: EdgeInsets.all(a/16),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 1,color: AppColors.dividerColor),
                                            borderRadius:
                                                BorderRadiusDirectional
                                                    .circular(a/100)),
                                        child: Image.asset(
                                          'assets/pic_avatar.png',
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(1.07, 1.07),
                                      child: GestureDetector(
                                        onTap: () {
                                          selectedIndex?.value = 5;
                                        },
                                        child: SvgPicture.asset(
                                          'assets/ic_edit.svg',
                                          height: a/60 / 1.8,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: a/60 / 1.4,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${controller.user?.firstName ?? controller.pref.user.firstName} ${controller.user?.lastName ?? controller.pref.user.lastName}',
                                    style: theme.textTheme.bodyText2!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(
                                    height: a/100 / 1.5,
                                  ),
                                  Text(
                                    controller.user?.phoneNumber ??
                                        controller.pref.user.phoneNumber,
                                    style: theme.textTheme.bodyText2!
                                        .copyWith(
                                            color: Colors.black,
                                            letterSpacing: 0.5,
                                            fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: a/100 / 1.5,
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.to(TransactionPage()),
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'اعتبار شما: ',
                                            style: theme.textTheme.subtitle2!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                          Text(
                                            controller.pref.totalWallet != []
                                                ? formatNumber(controller
                                                        .pref
                                                        .totalWallet?[0]
                                                        .price ??
                                                    0)
                                                : '0',
                                            style: theme.textTheme.bodyText2!
                                                .copyWith(
                                                    color: theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: a/60),
                          Container(
                            padding: EdgeInsets.all(a/60 / 2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1,color: AppColors.dividerColor),
                                borderRadius:
                                    BorderRadiusDirectional.circular(
                                        a/100 / 1.5)),
                            child: Column(
                              children: [
                                webItemProfile(
                                  isFirst: true,
                                  name: 'سـؤالات مـتداول',
                                  icon: 'assets/ic_book.svg',
                                  index: 0,
                                ),
                                webItemProfile(
                                    name: 'تبادلات',
                                    icon: 'assets/ic_refresh-square-2.svg',
                                    index: 1),
                                webItemProfile(
                                  name: 'معرفی به دوستان',
                                  icon: 'assets/ic_profile-2user.svg',
                                  index: 2,
                                ),
                                webItemProfile(
                                    name: 'آدرس های منتخب',
                                    icon: 'assets/ic_location-add.svg',
                                    index: 3),
                                webItemProfile(
                                  name: 'درباره زیستینو',
                                  icon: 'assets/ic_info-circle.svg',
                                  index: 4,

                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: a/60 / 1.5),
                          Container(
                            padding: EdgeInsets.all(a/60 / 1.8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1,color: AppColors.dividerColor),
                                borderRadius:
                                    BorderRadiusDirectional.circular(
                                        a/100 / 1.5)),
                            child: webItemProfile(
                              name: 'خروج',
                              isFirst: true,
                              icon: 'assets/ic_logout.svg',
                              isExit: true,
                              onTap: () => logOutDialog(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: a/60),
                    Expanded(
                      child: Container(
                          height: b,
                          padding: EdgeInsets.all(a/60 / 1.5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusDirectional.circular(
                                  a/80/2)),
                          child:
                          body()
                          // controller.selectedIndex.value == -1
                          //     ? const Center(
                          //         child: Text('صفحه ای انتخاب نشده است'))
                          //     : PageView(
                          //         physics:
                          //             const NeverScrollableScrollPhysics(),
                          //         pageSnapping: false,
                          //         controller: controller.pageController,
                          //         onPageChanged: (value) {
                          //           controller.selectedIndex.value = value;
                          //         },
                          //         children: [
                          //           FAQPage(),
                          //           TransactionPage(),
                          //           InvitePage(),
                          //           AddressesPage(),
                          //           AboutZistinoPage(),
                          //         ],
                          //       ),
                        )
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // ProfileBinding().dependencies();
    // return GetBuilder<ProfileController>(
    //     init: controller,
    //     initState: (state) {
    //       controller.getUserInfo();
    //       controller.fetchWalletData();
    //     },
    //     builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.homeBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              shadowColor: AppColors.shadowColor.withOpacity(0.2),
              elevation: 15,
              centerTitle: true,
              // toolbarHeight: kToolbarHeight * 1.5,
              title: Container(
                margin: EdgeInsetsDirectional.only(top: a/60),
                child: Text(
                  'پروفایل',
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(a/24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: a / 4.4,
                          height: a / 4.4,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  width: a / 4.4,
                                  height: a / 4.4,
                                  padding: EdgeInsets.all(a/16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 2),
                                            color: const Color(0xff10548B)
                                                .withOpacity(0.04),
                                            blurRadius: 5,
                                            blurStyle: BlurStyle.normal,
                                            spreadRadius: 4)
                                      ],
                                      borderRadius:
                                          BorderRadiusDirectional.circular(
                                              a/24)),
                                  child: Image.asset(
                                    'assets/pic_avatar.png',
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(1.07, 1.07),
                                child: GestureDetector(
                                  onTap: () async {
                                    String? result =
                                        await Get.toNamed(Routes.editProfile);
                                    if (result != null) {
                                      controller.getUserInfo();
                                    }
                                  },
                                  child: SvgPicture.asset('assets/ic_edit.svg'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: a/16,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.user?.firstName ?? controller.pref.user.firstName} ${controller.user?.lastName ?? controller.pref.user.lastName}',
                              style: theme.textTheme.subtitle1!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: a/100,
                            ),
                            Text(
                              controller.user?.phoneNumber ??
                                  controller.pref.user.phoneNumber,
                              style: theme.textTheme.caption!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: a/100,
                            ),
                            GestureDetector(
                              onTap: () => Get.to(TransactionPage()),
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اعتبار شما: ',
                                      style: theme.textTheme.subtitle2!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      controller.pref.totalWallet != []
                                          ? formatNumber(controller
                                                  .pref.totalWallet?[0].price ??
                                              0)
                                          : '0',
                                      style: theme.textTheme.subtitle1!
                                          .copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: a/16),
                    Container(
                      padding: EdgeInsets.all(a/60),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color:
                                    const Color(0xff10548B).withOpacity(0.04),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: 4)
                          ],
                          borderRadius:
                              BorderRadiusDirectional.circular(a/80)),
                      child: Column(
                        children: [
                          itemProfile(
                            isFirst: true,
                            name: 'سـؤالات مـتداول',
                            icon: 'assets/ic_book.svg',
                            onTap: () {
                              Get.to(FAQPage());
                            },
                          ),
                          itemProfile(
                              name: 'تبادلات',
                              icon: 'assets/ic_refresh-square-2.svg',
                              onTap: () => Get.toNamed(Routes.ordersPage)),
                          itemProfile(
                              name: 'معرفی به دوستان',
                              icon: 'assets/ic_profile-2user.svg',
                              onTap: () {
                                Get.to(InvitePage());
                              }),
                          itemProfile(
                              name: 'آدرس های منتخب',
                              icon: 'assets/ic_location-add.svg',
                              onTap: () {
                                Get.toNamed(Routes.addressesPage);
                              }),
                          itemProfile(
                              name: 'درباره زیستینو',
                              icon: 'assets/ic_info-circle.svg',
                              onTap: () {
                                Get.to(AboutZistinoPage());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: a/24),
                    Container(
                      padding: EdgeInsets.all(a/60),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color:
                                    const Color(0xff10548B).withOpacity(0.04),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: 4)
                          ],
                          borderRadius:
                              BorderRadiusDirectional.circular(a/80)),
                      child: itemProfile(
                        name: 'خروج',
                        isFirst: true,
                        icon: 'assets/ic_logout.svg',
                        isExit: true,
                        onTap: () => removeRequestSheet(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // ProfileBinding().dependencies();
    // return GetBuilder<ProfileController>(
    //     init: controller,
    //     initState: (state) {
    //       controller.getUserInfo();
    //       controller.fetchWalletData();
    //     },
    //     builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.homeBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              shadowColor: AppColors.shadowColor.withOpacity(0.2),
              elevation: 15,
              centerTitle: true,
              // toolbarHeight: kToolbarHeight * 1.5,
              title: Container(
                margin: EdgeInsetsDirectional.only(top: a/60),
                child: Text(
                  'پروفایل',
                  style: theme.textTheme.subtitle1!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(a/24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: a / 4.4,
                          height: a / 4.4,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  width: a / 4.4,
                                  height: a / 4.4,
                                  padding: EdgeInsets.all(a/16),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 2),
                                            color: const Color(0xff10548B)
                                                .withOpacity(0.04),
                                            blurRadius: 5,
                                            blurStyle: BlurStyle.normal,
                                            spreadRadius: 4)
                                      ],
                                      borderRadius:
                                      BorderRadiusDirectional.circular(
                                          a/24)),
                                  child: Image.asset(
                                    'assets/pic_avatar.png',
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const Alignment(1.07, 1.07),
                                child: GestureDetector(
                                  onTap: () async {
                                    String? result =
                                    await Get.toNamed(Routes.editProfile);
                                    if (result != null) {
                                      controller.getUserInfo();
                                    }
                                  },
                                  child: SvgPicture.asset('assets/ic_edit.svg'),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: a/16,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${controller.user?.firstName ?? controller.pref.user.firstName} ${controller.user?.lastName ?? controller.pref.user.lastName}',
                              style: theme.textTheme.subtitle1!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: a/100,
                            ),
                            Text(
                              controller.user?.phoneNumber ??
                                  controller.pref.user.phoneNumber,
                              style: theme.textTheme.caption!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: a/100,
                            ),
                            GestureDetector(
                              onTap: () => Get.to(TransactionPage()),
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'اعتبار شما: ',
                                      style: theme.textTheme.subtitle2!
                                          .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      controller.pref.totalWallet != []
                                          ? formatNumber(controller
                                          .pref.totalWallet?[0].price ??
                                          0)
                                          : '0',
                                      style: theme.textTheme.subtitle1!
                                          .copyWith(
                                          color: theme.primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: a/16),
                    Container(
                      padding: EdgeInsets.all(a/60),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color:
                                const Color(0xff10548B).withOpacity(0.04),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: 4)
                          ],
                          borderRadius:
                          BorderRadiusDirectional.circular(a/80)),
                      child: Column(
                        children: [
                          itemProfile(
                            isFirst: true,
                            name: 'سـؤالات مـتداول',
                            icon: 'assets/ic_book.svg',
                            onTap: () {
                              Get.to(FAQPage());
                            },
                          ),
                          itemProfile(
                              name: 'تبادلات',
                              icon: 'assets/ic_refresh-square-2.svg',
                              onTap: () => Get.toNamed(Routes.ordersPage)),
                          itemProfile(
                              name: 'معرفی به دوستان',
                              icon: 'assets/ic_profile-2user.svg',
                              onTap: () {
                                Get.to(InvitePage());
                              }),
                          itemProfile(
                              name: 'آدرس های منتخب',
                              icon: 'assets/ic_location-add.svg',
                              onTap: () {
                                Get.toNamed(Routes.addressesPage);
                              }),
                          itemProfile(
                              name: 'درباره زیستینو',
                              icon: 'assets/ic_info-circle.svg',
                              onTap: () {
                                Get.to(AboutZistinoPage());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(height: a/24),
                    Container(
                      padding: EdgeInsets.all(a/60),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color:
                                const Color(0xff10548B).withOpacity(0.04),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: 4)
                          ],
                          borderRadius:
                          BorderRadiusDirectional.circular(a/80)),
                      child: itemProfile(
                        name: 'خروج',
                        isFirst: true,
                        icon: 'assets/ic_logout.svg',
                        isExit: true,
                        onTap: () => removeRequestSheet(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        // });
  }

  Widget itemProfile(
      {required String name,
      required String icon,
      bool isExit = false,
      bool isFirst = false,
      Color? boxColor,
      VoidCallback? onTap}) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    return Column(
      children: [
        if (!isFirst) SizedBox(height: a/60),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: isExit == true
                ? const Color(0xFFE74F55).withOpacity(0.15)
                : theme.primaryColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(a/100),
            child: Row(
              children: [
                Container(
                  width: a / 9.3,
                  height: a / 9.3,
                  padding: EdgeInsets.all(a/60 / 1.2),
                  decoration: BoxDecoration(
                      color: isExit == true
                          ? const Color(0xFFE74F55).withOpacity(0.15)
                          : theme.primaryColor.withOpacity(0.15),
                      borderRadius:
                          BorderRadiusDirectional.circular(a/60)),
                  child: SvgPicture.asset(
                    icon,
                    color: isExit == true
                        ? const Color(0xFFE74F55)
                        : theme.primaryColor,
                  ),
                ),
                SizedBox(
                  width: a/60,
                ),
                Expanded(
                  child: Text(
                    name,
                    style: theme.textTheme.subtitle2,
                  ),
                ),
                SvgPicture.asset(
                  'assets/ic_back.svg',
                  color: Colors.black,
                  height: a/60,
                ),
                SizedBox(
                  width: a/60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget webItemProfile(
      {required String name,
      required String icon,
      bool isExit = false,
      bool isFirst = false,
      int? index,
      Color? boxColor,
      VoidCallback? onTap}) {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    return Obx(() {
        return Column(
          children: [
            if (!isFirst) SizedBox(height: a/100),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap ??
                    () {
                      selectedIndex?.value = index!;
                    },
                splashColor: isExit == true
                    ? const Color(0xFFE74F55).withOpacity(0.15)
                    : theme.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(a/100 / 1.5),
                child: Row(
                  children: [
                    Container(
                      width: b / 15,
                      height: b / 15,
                      padding: EdgeInsets.all(a/100 / 1.3),
                      decoration: BoxDecoration(
                          color: isExit == true
                              ? const Color(0xFFE74F55).withOpacity(0.15)
                              : theme.primaryColor.withOpacity(0.15),
                          borderRadius:
                              BorderRadiusDirectional.circular(a/100 / 1.5)),
                      child: SvgPicture.asset(
                        icon,
                        color: isExit == true
                            ? const Color(0xFFE74F55)
                            : theme.primaryColor,
                      ),
                    ),
                    SizedBox(
                      width: a/100,
                    ),
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.caption?.copyWith(
                            color: selectedIndex?.value == index ? theme.primaryColor : Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/ic_back.svg',
                      color: selectedIndex?.value == index ? theme.primaryColor : Colors.black,
                      height: a/60 / 1.5,
                    ),
                    SizedBox(
                      width: a/100,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }

Widget body() {
  return Obx(() {
    switch (selectedIndex?.value) {
      case 0:
        return FAQPage();
      case 1:
        return OrdersPage();
      case 2:
        return InvitePage();
      case 3:
        return AddressesPage();
      case 4:
        return AboutZistinoPage();
      case 5:
        return EditProfilePage();
      default:
        return const
        Center(
          child: Text('صفحه ای انتخاب نشده است'),
        );
    }
  });
}
}
