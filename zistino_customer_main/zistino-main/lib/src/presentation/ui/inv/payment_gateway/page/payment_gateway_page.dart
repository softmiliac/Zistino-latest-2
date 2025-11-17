import 'package:zistino/src/common/utils/number_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../basket_controller/basket_controller.dart';
import '../../success_payment_page/page/success_payment_page.dart';
import '../controller/payment_gateway_controller.dart';
import '../widgets/custom_radio_item.dart';

class PaymentGatewayPage extends StatelessWidget {
  final BasketController controller = BasketController();

  PaymentGatewayPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<BasketController>(
        init: controller,
        builder: (controller) {
          controller.selectedGateway.value = -1;
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              title: const Text("درگاه پرداخت"),
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: backIcon(),
            ),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(standardSize),
              child: Column(
                children: [
                  // Obx(
                  //       () => customRadioItem(
                  //     selected: controller.selectedGateway,
                  //     index: 0,
                  //     iconWidget: Padding(
                  //       padding: EdgeInsetsDirectional.only(end: smallSize),
                  //       child: SvgPicture.asset(
                  //         "assets/ic_cards.svg",
                  //         color: controller.selectedGateway.value == 0
                  //             ? AppColors.primaryColor
                  //             : const Color(0xFF8C8A8A).withOpacity(0.80),
                  //         width: iconSizeLarge,
                  //         height: iconSizeLarge,
                  //       ),
                  //     ),
                  //     name: "پرداخت اینترنتی",
                  //   ),
                  // ),

                    Obx(
                          () => customRadioItem(
                        selected: controller.selectedGateway,
                        index: 1,
                        suffixWidget: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('موجودی کیف پول',
                                style: Get.theme.textTheme.caption
                                    ?.copyWith(
                                    fontWeight: FontWeight.w700)),
                            SizedBox(height: xxSmallSize / 1.1),
                            RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: formatNumber(controller
                                          .pref.totalWallet?[0].price
                                          ?.toInt() ??
                                          0),
                                      style: Get.theme.textTheme.bodyText2
                                          ?.copyWith(
                                          fontFamily: 'b-nazanin',
                                          color: AppColors.captionTextColor,
                                          fontWeight: FontWeight.w700)),
                                  TextSpan(
                                      text: ' ریال',
                                      style: Get.theme.textTheme.overline
                                          ?.copyWith(
                                          letterSpacing: 0.5,
                                          color: AppColors.captionTextColor,
                                          fontWeight: FontWeight.w700)),
                                ])),
                          ],
                        ),
                        iconWidget: Padding(
                          padding:
                          EdgeInsetsDirectional.only(end: smallSize),
                          child: SvgPicture.asset(
                            "assets/ic_wallet.svg",
                            width: iconSizeMedium,
                            height: iconSizeMedium,
                            color: controller.selectedGateway.value == 1
                                ? AppColors.primaryColor
                                : const Color(0xFF8C8A8A).withOpacity(0.80),
                          ),
                        ),
                        name: "پرداخت از کیف پول",
                      ),
                    )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(standardSize),
              child: Obx(
                    () => progressButton(
                  // isDisable: false,
                  isProgress: controller.isBusyRequest.value,

                  isDisable:
                  controller.selectedGateway.value == -1 ? true : false,
                  onTap: () {
                    if (controller.selectedGateway.value != -1) {
                      if (controller.selectedGateway.value == 1 &&
                          controller.calculatedTotal() >
                              (controller.pref.totalWallet?[0].price
                                  ?.toInt() ??
                                  0)) {
                        showTheResult(
                            resultType: SnackbarType.message,
                            showTheResultType: ShowTheResultType.snackBar,
                            title: 'پیام',
                            message:
                            'مجموع مبلغ خرید شما بیشتر از اعتبار کیف پول شما میباشد');
                      } else {
                        if(controller.selectedGateway.value == 1){
                          controller.createOrder();
                        }
                      }
                    }
                  },
                  text: "پرداخت",
                ),
              ),
            ),
          );
        });
  }
}
