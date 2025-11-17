import 'package:zistino/src/presentation/widgets/back_widget.dart';
import 'package:zistino/src/presentation/widgets/server_widgets/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../../common/utils/hive_utils/hive_utils.dart';

import '../../../../../common/utils/number_format.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

import '../../../../widgets/inv_widget/product_basket_widget.dart';
import '../../../../widgets/progress_button.dart';

import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';
import '../../basket_controller/basket_controller.dart';
import '../../payment_gateway/page/payment_gateway_page.dart';

class CheckoutPage extends GetView<BasketController> {
  @override
  final BasketController controller = BasketController();

  // final CheckOutC controller = BasketController();

  MainPageController mainController = Get.find();
  final TextEditingController counterEditController =
      TextEditingController(text: '1');
  final theme = Get.theme;

  CheckoutPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    Future<bool> onBackClicked() {
      mainController.selectedIndex.value = 1;
      Get.to(MainPage());
      return Future.value(false);
    }

    return GetBuilder<BasketController>(
        init: controller,
        initState: (state) => controller.box.values,
        builder: (controller) => WillPopScope(
          onWillPop: onBackClicked,
          child: Scaffold(
              appBar: AppBar(
                title: Text("صورتحساب",
                    style: theme.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.bold)),
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: backIcon(iconColor: Colors.black,onTap: onBackClicked),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: standardSize),
                       controller.box.values.isEmpty ? emptyWidget('محصولی وجود ندارد',height: fullHeight/1.7) :  ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.box.length,
                            itemBuilder: (context, index) =>
                                verticalProductWidget(
                                    controller.box.values.toList()[index],
                                    counterEditController)),
                        // SizedBox(height: fullHeight / 2.8,),
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
                  //             top: xxSmallSize
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
                  //               topLeft: Radius.circular(standardRadius),
                  //               topRight: Radius.circular(standardRadius),
                  //             ),
                  //             color: AppColors.backgroundColor,
                  //           ),
                  //           child: SingleChildScrollView(
                  //             controller: scrollController,
                  //             padding: EdgeInsetsDirectional.all(standardSize),
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                   decoration: BoxDecoration(
                  //                     borderRadius:
                  //                         BorderRadius.circular(xSmallRadius),
                  //                     color: AppColors.formFieldColor,
                  //                   ),
                  //                   padding:
                  //                       EdgeInsets.symmetric(horizontal: smallSize),
                  //                   child: Column(
                  //                     children: [
                  //                       _factorItemWidget(
                  //                         "جمع کـل",
                  //                         "۱۲۰,۰۰۰ ریال",
                  //                       ),
                  //                       const Divider(),
                  //                       _factorItemWidget(
                  //                         "تخفیـف",
                  //                         "۴۰,۰۰۰ ریال",
                  //                       ),
                  //                       const Divider(),
                  //                       _factorItemWidget(
                  //                         "مبلغ قابـل پرداخـت",
                  //                         "۸۰,۰۰۰ ریال",
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 SizedBox(height: standardSize),
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
                  //                           "۸۰,۰۰۰ ریال",
                  //                           style: Get.theme.textTheme.subtitle2
                  //                               ?.copyWith(
                  //                             fontWeight: FontWeight.w700,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     SizedBox(
                  //                       width: fullWidth / 2.5,
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

              /*bottomNavigationBar: Padding(
            padding: EdgeInsets.all(standardSize),
            child: progressButton(
              onTap: () => Get.off(const SuccessPaymentPage()),
              text: "پرداخت",
            ),
          ),*/
              bottomNavigationBar: ValueListenableBuilder(
                  valueListenable: Boxes.getBasketBox().listenable(),
                  builder: (context, box, widget) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: xxSmallSize),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 29,
                              spreadRadius: 0,
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(standardRadius),
                            topRight: Radius.circular(standardRadius),
                          ),
                          color: AppColors.backgroundColor,
                        ),
                        child: SingleChildScrollView(
                          padding: EdgeInsetsDirectional.all(standardSize),
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
                                          '${formatNumber(int.parse(controller.calculatedTotal().toStringAsFixed(0)))} ریال',

                                          style: Get.theme.textTheme.subtitle2
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: xSmallSize),
                                  SizedBox(
                                      width: fullWidth / 2.5,
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
                                                // controller.createOrder();
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
        ));
  }

  Widget _factorItemWidget(
    String title,
    String subTitle, {
    String? icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null) SvgPicture.asset(icon),
            Padding(
              padding: EdgeInsets.only(
                right: smallSize,
                top: smallSize,
                bottom: smallSize,
              ),
              child: Text("$title :",
                  style: Get.theme.textTheme.subtitle2!
                      .copyWith(color: AppColors.primaryColor)),
            ),
          ],
        ),
        SizedBox(width: xxSmallSize),
        Flexible(
            child: Text(
          subTitle,
          style: Get.theme.textTheme.subtitle2,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )),
      ],
    );
  }
}
