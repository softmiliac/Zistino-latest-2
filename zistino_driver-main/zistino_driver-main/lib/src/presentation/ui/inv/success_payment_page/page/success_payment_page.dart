import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';

class SuccessPaymentPage extends StatelessWidget {
  const SuccessPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: fullWidth,
        height: fullHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: fullWidth / 3,
              width: fullWidth / 3,
              child: Lottie.asset('assets/payment_success.json'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: smallSize,
                horizontal: xxLargeSize,
              ),
              child: Text(
                "پـرداخت شمـا بـرای فاکتـور شمـاره : ۲۸۹۸۳۹۲۹۷۸۲۰۵۹۴۲ بـا موفقیـت انجـام شد.",
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: fullWidth,
        margin: EdgeInsets.all(standardSize),
        child: progressButton(
          isDisable: false,
          isProgress: false,
          onTap: () => Get.back(),
          text: "بازگشت",
        ),
      ),
    );
  }
}
