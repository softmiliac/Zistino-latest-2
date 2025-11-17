import 'package:admin_dashboard/src/presentation/widgets/back_widget.dart';
import 'package:admin_dashboard/src/presentation/widgets/server_widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../../common/utils/hive_utils/hive_utils.dart';

import '../../../../../common/utils/number_format.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';

import '../../../../widgets/inv_widget/product_basket_widget.dart';
import '../../../../widgets/progress_button.dart';

import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';
import '../../basket_controller/basket_controller.dart';
import '../../payment_gateway/page/payment_gateway_page.dart';

class CheckoutPage extends GetResponsiveView<BasketController> {
  @override
  final BasketController controller = Get.find<BasketController>();
  late MainPageController mainController = Get.find();
  final TextEditingController counterEditController =
      TextEditingController(text: '1');
  final theme = Get.theme;

  CheckoutPage({super.key, required this.id});

  final String id;

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    Future<bool> onBackClicked() {
      Get.to(MainPage(selectedIndex: mainController.selectedIndex.value = 1));
      return Future.value(false);
    }

    return GetBuilder<BasketController>(
      init: controller,
      initState:(state) =>  controller.box.values,
      builder: (context) {
        return WillPopScope(
          onWillPop: onBackClicked,
          child: Scaffold(
              appBar: AppBar(
                title: Text("صورتحساب",
                    style: theme.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold)),
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: backIcon(iconColor: Colors.black, onTap: onBackClicked),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: a / 100),
                        controller.box.values.isEmpty
                            ? emptyWidget('محصولی وجود ندارد'
                            , height: b / 1.7)
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.box.length,
                                itemBuilder: (context, index) =>
                                    verticalProductWidgetPhone(
                                        controller.box.values.toList()[index],
                                        counterEditController)),
                        // SizedBox(height: b / 2.8,),
                      ],
                    ),
                  ),
                  // DraggableScrollableSheet(
                  //   minChildSize: 0.4,
                  //   initialChildSize: 0.4,
                  //   maxChildSize: 0.4,
                  //   builder: (
                  //     BuildContext context,
                  //     ScrollController scrollController,
                  //   ) {
                  //     return NotificationListener(
                  //       onNotification:
                  //           (OverscrollIndicatorNotification overScroll) {
                  //         overScroll.disallowIndicator();
                  //         return true;
                  //       },
                  //       child: SingleChildScrollView(
                  //         child: Container(
                  //           margin: EdgeInsets.only(
                  //             top: a/120
                  //           ),
                  //           decoration: BoxDecoration(
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.black.withOpacity(0.06),
                  //                 blurRadius: 29,
                  //                 spreadRadius: 0,
                  //               )
                  //             ],
                  //             borderRadius: BorderRadius.only(
                  //               topLeft: Radius.circular(a/90),
                  //               topRight: Radius.circular(a/90),
                  //             ),
                  //             color: AppColors.backgroundColor,
                  //           ),
                  //           child: SingleChildScrollView(
                  //             controller: scrollController,
                  //             padding: EdgeInsetsDirectional.all(a/100),
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                   decoration: BoxDecoration(
                  //                     borderRadius:
                  //                         BorderRadius.circular(xSmallRadius),
                  //                     color: AppColors.formFieldColor,
                  //                   ),
                  //                   padding:
                  //                       EdgeInsets.symmetric(horizontal: a/90),
                  //                   child: Column(
                  //                     children: [
                  //                       _factorItemWidget(
                  //                         "جمع کـل",
                  //                         "۱۲۰,۰۰۰ ريال",
                  //                       ),
                  //                       const Divider(),
                  //                       _factorItemWidget(
                  //                         "تخفیـف",
                  //                         "۴۰,۰۰۰ ريال",
                  //                       ),
                  //                       const Divider(),
                  //                       _factorItemWidget(
                  //                         "مبلغ قابـل پرداخـت",
                  //                         "۸۰,۰۰۰ ريال",
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: a/100),
                  //                 Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.spaceBetween,
                  //                   children: [
                  //                     Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                           "مبلغ قابـل پرداخـت :",
                  //                           style: Get.theme.textTheme.subtitle2
                  //                               ?.copyWith(
                  //                             color: const Color(0xFF8C8A8A)
                  //                                 .withOpacity(0.80),
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           "۸۰,۰۰۰ ريال",
                  //                           style: Get.theme.textTheme.subtitle2
                  //                               ?.copyWith(
                  //                             fontWeight: FontWeight.w700,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(
                  //                       width: a / 2.5,
                  //                       child: progressButton(
                  //                         onTap: () => Get.to(PaymentGatewayPage()),
                  //                         text: "پرداخت",
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
              bottomNavigationBar: ValueListenableBuilder(
                  valueListenable: Boxes.getBasketBox().listenable(),
                  builder: (context, box, widget) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: a / 120),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 29,
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(a / 90),
                            topRight: Radius.circular(a / 90),
                          ),
                          color: AppColors.backgroundColor,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsetsDirectional.all(a / 100),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "مبلغ قابـل پرداخـت :",
                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            color: const Color(0xFF8C8A8A)
                                                .withOpacity(0.80),
                                          ),
                                        ),
                                        Text(
                                          // controller.calculatedTotal().toString(),
                                          '${formatNumber(int.parse(controller.calculatedTotal().toStringAsFixed(0)))} ريال',

                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: a / 100),
                                  SizedBox(
                                      width: a / 2.5,
                                      child: ValueListenableBuilder(
                                          valueListenable:
                                              Boxes.getBasketBox().listenable(),
                                          builder: (context, box, widget) {
                                            return progressButton(
                                              // isDisabled:
                                              //     controller.box.values.isNotEmpty
                                              //         ? false
                                              //         : true,
                                              onTap: () {
                                                controller.createOrder();
                                                Get.to(PaymentGatewayPage());

                                                // if (controller
                                                //     .box.values.isNotEmpty) {
                                                //   Get.to(PaymentGatewayPage());
                                                // } //todo back this code after test
                                              },
                                              isDisable:
                                                  controller.box.values.isNotEmpty
                                                      ? false
                                                      : true,
                                              text: "پرداخت",
                                              isProgress: false,
                                            );
                                          }))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        );
      }
    );
  }

  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    Future<bool> onBackClicked() {
      Get.to(MainPage(selectedIndex: mainController.selectedIndex.value = 1));
      return Future.value(false);
    }

    return GetBuilder<BasketController>(
        init: controller,
        initState:(state) =>  controller.box.values,
      builder: (context) {
        return WillPopScope(
          onWillPop: onBackClicked,
          child: Scaffold(
              appBar: AppBar(
                title: Text("صورتحساب",
                    style: theme.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold)),
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: backIcon(iconColor: Colors.black, onTap: onBackClicked),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: a / 100),
                        controller.box.values.isEmpty
                            ? emptyWidget('محصولی وجود ندارد', height: b / 1.7)
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.box.length,
                                itemBuilder: (context, index) =>
                                    verticalProductWidgetDesktop(
                                        controller.box.values.toList()[index],
                                        counterEditController),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 2/2,
                                        mainAxisSpacing: 1,
                                        crossAxisSpacing: 0
                                ),
                              ),
                        // SizedBox(height: b / 2.8,),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: ValueListenableBuilder(
                  valueListenable: Boxes.getBasketBox().listenable(),
                  builder: (context, box, widget) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: a / 120),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 29,
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(a / 90),
                            topRight: Radius.circular(a / 90),
                          ),
                          color: AppColors.backgroundColor,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsetsDirectional.all(a / 100),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "مبلغ قابـل پرداخـت :",
                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            color: const Color(0xFF8C8A8A)
                                                .withOpacity(0.80),
                                          ),
                                        ),
                                        Text(
                                          // controller.calculatedTotal().toString(),
                                          '${formatNumber(int.parse(controller.calculatedTotal().toStringAsFixed(0)))} ريال',

                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: a / 100),
                                  SizedBox(
                                      width: a / 2.5,
                                      child: ValueListenableBuilder(
                                          valueListenable:
                                              Boxes.getBasketBox().listenable(),
                                          builder: (context, box, widget) {
                                            return progressButton(
                                              // isDisabled:
                                              //     controller.box.values.isNotEmpty
                                              //         ? false
                                              //         : true,
                                              onTap: () {
                                                controller.createOrder();
                                                Get.to(PaymentGatewayPage());

                                                // if (controller
                                                //     .box.values.isNotEmpty) {
                                                //   Get.to(PaymentGatewayPage());
                                                // } //todo back this code after test
                                              },
                                              isDisable:
                                                  controller.box.values.isNotEmpty
                                                      ? false
                                                      : true,
                                              text: "پرداخت",
                                              isProgress: false,
                                            );
                                          }))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        );
      }
    );
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    Future<bool> onBackClicked() {
      Get.to(MainPage(selectedIndex: mainController.selectedIndex.value = 1));
      return Future.value(false);
    }

    return GetBuilder<BasketController>(
        init: controller,
        initState:(state) =>  controller.box.values,
      builder: (context) {
        return WillPopScope(
          onWillPop: onBackClicked,
          child: Scaffold(
              appBar: AppBar(
                title: Text("صورتحساب",
                    style: theme.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold)),
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: backIcon(iconColor: Colors.black, onTap: onBackClicked),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: a / 100),
                        controller.box.values.isEmpty
                            ? emptyWidget('محصولی وجود ندارد', height: b / 1.7)
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.box.length,
                                itemBuilder: (context, index) =>
                                    verticalProductWidgetTablet(
                                        controller.box.values.toList()[index],
                                        counterEditController)),
                        // SizedBox(height: b / 2.8,),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: ValueListenableBuilder(
                  valueListenable: Boxes.getBasketBox().listenable(),
                  builder: (context, box, widget) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: a / 120),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 29,
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(a / 90),
                            topRight: Radius.circular(a / 90),
                          ),
                          color: AppColors.backgroundColor,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsetsDirectional.all(a / 100),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "مبلغ قابـل پرداخـت :",
                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            color: const Color(0xFF8C8A8A)
                                                .withOpacity(0.80),
                                          ),
                                        ),
                                        Text(
                                          // controller.calculatedTotal().toString(),
                                          '${formatNumber(int.parse(controller.calculatedTotal().toStringAsFixed(0)))} ريال',

                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: a / 100),
                                  SizedBox(
                                      width: a / 2.5,
                                      child: ValueListenableBuilder(
                                          valueListenable:
                                              Boxes.getBasketBox().listenable(),
                                          builder: (context, box, widget) {
                                            return progressButton(
                                              // isDisabled:
                                              //     controller.box.values.isNotEmpty
                                              //         ? false
                                              //         : true,
                                              onTap: () {
                                                controller.createOrder();
                                                Get.to(PaymentGatewayPage());

                                                // if (controller
                                                //     .box.values.isNotEmpty) {
                                                //   Get.to(PaymentGatewayPage());
                                                // } //todo back this code after test
                                              },
                                              isDisable:
                                                  controller.box.values.isNotEmpty
                                                      ? false
                                                      : true,
                                              text: "پرداخت",
                                              isProgress: false,
                                            );
                                          }))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
        );
      }
    );
  }
}
