import 'package:recycling_machine/src/presentation/widgets/back_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../../common/utils/hive_utils/hive_utils.dart';

import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

import '../../../../widgets/inv_widget/product_basket_widget.dart';
import '../../../../widgets/progress_button.dart';

import '../../basket_controller/basket_controller.dart';
import '../../payment_gateway/page/payment_gateway_page.dart';

class CheckoutPage extends GetView<BasketController> {
  @override
  final BasketController controller = BasketController();

  // final CheckOutC controller = BasketController();

  final TextEditingController counterEditController =
      TextEditingController(text: '1');
  final theme = Get.theme;

  CheckoutPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasketController>(
        init: controller,
        initState: (state) => controller.box.values,
        builder: (controller) => Scaffold(
            appBar: AppBar(
              title: Text("صورتحساب",
                  style: theme.textTheme.subtitle1
                      ?.copyWith(fontWeight: FontWeight.bold)),
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: backIcon(iconColor: Colors.black),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: standardSize),
                      Container(
                        margin: EdgeInsets.all(standardSize),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(xSmallRadius),
                          color: AppColors.formFieldColor,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: smallSize),
                        child: Column(
                          children: [
                            _factorItemWidget(
                              "پـذیرنـده",
                              "فـروشگـاه افـق",
                              icon: "assets/icons/ic_document.svg",
                            ),
                            const Divider(),
                            _factorItemWidget(
                              "شمـاره فـاکـتـور",
                              "۱۲۴۸۷۵۴۶",
                              icon: "assets/icons/ic_receipt_item.svg",
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
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
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(xSmallRadius),
                                color: AppColors.formFieldColor,
                              ),
                              padding:
                                  EdgeInsets.symmetric(horizontal: smallSize),
                              child: Column(
                                children: [
                                  _factorItemWidget("جمع کـل", 'asdqwerqwr'
                                      // formatter.format(int.parse(controller
                                      //     .calculatedTotal()
                                      //     .toStringAsFixed(0))),
                                      ),
                                  const Divider(),
                                  _factorItemWidget("تخفیـف", 'asdasdas'
                                      // formatter.format(int.parse(controller
                                      //     .discountTotal()
                                      //     .toStringAsFixed(0))),
                                      ),
                                  const Divider(),
                                  _factorItemWidget(
                                      "مبلغ قابـل پرداخـت", 'sadasd'
                                      // formatter.format(int.parse(
                                      //     controller.total().toStringAsFixed(0))),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(height: standardSize),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                      'sdasd',
                                      // formatter.format(int.parse(controller
                                      //     .total()
                                      //     .toStringAsFixed(0))),
                                      style: Get.theme.textTheme.subtitle2
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    width: fullWidth / 2.5,
                                    child: ValueListenableBuilder(
                                        valueListenable:
                                            Boxes.getBasketBox().listenable(),
                                        builder: (context, box, widget) {
                                          return
                                            progressButton(
                                            // isDisabled:
                                            //     controller.box.values.isNotEmpty
                                            //         ? false
                                            //         : true,
                                            onTap: () {
                                              if (controller
                                                  .box.values.isNotEmpty) {
                                                Get.to(PaymentGatewayPage());
                                              }
                                            },
                                            isDisable:controller.box.values.isNotEmpty ? false :true                                                                    ,
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
                })));
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
