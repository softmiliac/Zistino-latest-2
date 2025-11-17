import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../data/enums/transaction/index_place.dart';
import '../../../../../domain/entities/sec/wallet.dart';
import '../../../../style/colors.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../binding/address_binding.dart';
import '../controller/transaction_controller.dart';
import '../widgets/transaction_card_wdiget.dart';

class TransactionPage extends GetResponsiveView<TransactionController> {
  TransactionPage({Key? key}) : super(key: key);
  final ThemeData theme = Get.theme;
  // bool isDesktop = false;

  @override
  Widget phone() {
    var a =MediaQuery.of(Get.context!).size.width;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) => controller.fetchData(),
    //     builder: (_) {
          return Scaffold(
              backgroundColor: theme.backgroundColor,
              appBar: AppBar(
                title: const Text('کیف پول'),
                leading: backIcon(),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                // padding: EdgeInsets.all(a/24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: AlignmentDirectional.center,
                      margin: EdgeInsets.only(
                          right: a/24,
                          left: a/24,
                          bottom: a/94,
                          top: a/24),
                      child: Text(
                        'اعتبـار کیـف پول',
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: a/94 / 2),
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: a/24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatNumber(
                                controller.pref.totalWallet?[0].price ?? 0),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: a/94),
                          Text(
                            'ريال',
                            style: theme.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: a/24, top: a/8),
                      child: Text(
                        'تاریخچه تراکنشات',
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    controller.obx(
                          (state) {
                        return ListView.builder(
                          padding: EdgeInsetsDirectional.only(
                            top: a/33,
                            bottom: a/33,
                          ),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.rpm?.length ?? 0,
                          itemBuilder: (context, index) {
                            return transactionCardWidget(
                              controller.rpm?[index] ?? Wallet(),
                              index == 0
                                  ? IndexPlace.zero
                                  : index + 1 ==
                                  (controller.rpm?.length ?? 0)
                                  ? IndexPlace.last
                                  : IndexPlace.normal,
                            );
                          },
                        );
                      },
                      onLoading: loadingWidget(height: MediaQuery.of(Get.context!).size.height / 2.3),
                      onEmpty: emptyWidget('تبادلی انجام نشده است'),
                      onError: (error) => errorWidget('$error',
                          onTap: () => controller.fetchData()),
                    ),
/*
                    Obx(
                          () {
                        List<BonusModel> items = bonusItems(
                          controller.selectedTab.value,
                        );
                        return
                          ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                bottom: index + 1 < items.length ? a/24 : 0,
                              ),
                              child: bonusItemWidget(
                                bonus: items[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
*/
                  ],
                ),
              ));
        // });
  }


  @override
  Widget desktop() {
    var a =MediaQuery.of(Get.context!).size.width;
    // TransactionBinding().dependencies();
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) => controller.fetchData(),
    //     builder: (_) {
          return Scaffold(
              backgroundColor: AppColors.homeBackgroundColor,
              appBar: AppBar(
                title: const Text('کیف پول'),
                leading: backIcon(),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                // padding: EdgeInsets.all(a/24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: AlignmentDirectional.center,
                      margin: EdgeInsets.only(
                          right: a/24,
                          left: a/24,
                          bottom: a/94,
                          top: a/48
                      ),
                      child: Text(
                        'اعتبـار کیـف پول',
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    // SizedBox(height: a/94 / 2),
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: a/24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatNumber(
                                controller.pref.totalWallet?[0].price ?? 0),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: a/94),
                          Text(
                            'ريال',
                            style: theme.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: a/40,
                          top: a/20
                      ),
                      child: Text(
                        'تاریخچه تراکنشات',
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 20,),
                    controller.obx(
                          (state) {
                         return   GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 5/1,
                                    mainAxisSpacing: 1,
                                    crossAxisSpacing: 0),
                                itemCount: controller.rpm?.length,
                                shrinkWrap: true,
                                padding: EdgeInsetsDirectional.only(start: a/40 ),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return transactionCardWidget(
                                    controller.rpm?[index] ?? Wallet(),
                                    index == 0
                                        ? IndexPlace.zero
                                        : index + 1 ==
                                        (controller.rpm?.length ?? 0)
                                        ? IndexPlace.last
                                        : IndexPlace.normal,
                                  );
                                  });
                        /*return ListView.builder(
                          padding: EdgeInsetsDirectional.only(
                            top: a/33,
                            bottom: a/33,
                          ),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.rpm?.length ?? 0,
                          itemBuilder: (context, index) {
                            return transactionCardWidget(
                              controller.rpm?[index] ?? Wallet(),
                              index == 0
                                  ? IndexPlace.zero
                                  : index + 1 ==
                                  (controller.rpm?.length ?? 0)
                                  ? IndexPlace.last
                                  : IndexPlace.normal,
                            );
                          },
                        );*/
                      },
                        onLoading: loadingWidget(height: MediaQuery.of(Get.context!).size.height / 2.3),                      onEmpty: emptyWidget('تبادلی انجام نشده است'),
                      onError: (error) => errorWidget('$error',
                          onTap: () => controller.fetchData()),
                    ),
/*
                    Obx(
                          () {
                        List<BonusModel> items = bonusItems(
                          controller.selectedTab.value,
                        );
                        return
                          ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                bottom: index + 1 < items.length ? a/24 : 0,
                              ),
                              child: bonusItemWidget(
                                bonus: items[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
*/
                  ],
                ),
              ));
        // });
  }

  @override
  Widget tablet() {
    var a =MediaQuery.of(Get.context!).size.width;

    // TransactionBinding().dependencies();
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) => controller.fetchData(),
    //     builder: (_) {
          return Scaffold(
              backgroundColor: theme.backgroundColor,
              appBar: AppBar(
                title: const Text('کیف پول'),
                leading: backIcon(),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                // padding: EdgeInsets.all(a/24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: AlignmentDirectional.center,
                      margin: EdgeInsets.only(
                          right: a/24,
                          left: a/24,
                          bottom: a/94,
                          top: a/24),
                      child: Text(
                        'اعتبـار کیـف پول',
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: a/94 / 2),
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: a/24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatNumber(
                                controller.pref.totalWallet?[0].price ?? 0),
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: a/94),
                          Text(
                            'ريال',
                            style: theme.textTheme.subtitle1!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsetsDirectional.only(
                          start: a/24, top: a/8),
                      child: Text(
                        'تاریخچه تراکنشات',
                        style: theme.textTheme.subtitle1!
                            .copyWith(fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    controller.obx(
                          (state) {
                        return ListView.builder(
                          padding: EdgeInsetsDirectional.only(
                            top: a/33,
                            bottom: a/33,
                          ),
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.rpm?.length ?? 0,
                          itemBuilder: (context, index) {
                            return transactionCardWidget(
                              controller.rpm?[index] ?? Wallet(),
                              index == 0
                                  ? IndexPlace.zero
                                  : index + 1 ==
                                  (controller.rpm?.length ?? 0)
                                  ? IndexPlace.last
                                  : IndexPlace.normal,
                            );
                          },
                        );
                      },
                      onLoading: loadingWidget(height:MediaQuery.of(Get.context!).size.height ),
                      onEmpty: emptyWidget('تبادلی انجام نشده است'),
                      onError: (error) => errorWidget('$error',
                          onTap: () => controller.fetchData()),
                    ),
/*
                    Obx(
                          () {
                        List<BonusModel> items = bonusItems(
                          controller.selectedTab.value,
                        );
                        return
                          ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          primary: false,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(
                                bottom: index + 1 < items.length ? a/24 : 0,
                              ),
                              child: bonusItemWidget(
                                bonus: items[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
*/
                  ],
                ),
              ));
        // });
  }
}
