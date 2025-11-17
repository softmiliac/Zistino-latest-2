import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';
import '../../../base/products_page/controller/products_controller.dart';
import '../../basket_controller/basket_controller.dart';

class SuccessPaymentPage extends StatelessWidget {
   SuccessPaymentPage({Key? key}) : super(key: key);
final theme = Get.theme;
   final MainPageController mainController = Get.find();
   final ProductsController productsController = Get.find();
   final BasketController basketController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('صورت حساب موفق',style: theme.textTheme.subtitle1,),
      ),
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
                'کالاهای سفارش داده شده در تحویل پسماند بعدی برای شما ارسال خواهد شد',
                style: theme.textTheme.subtitle1,
                textAlign: TextAlign.center,
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
          onTap: () {
            productsController.fetchProducts();
            basketController.box.clear();
            mainController.selectedIndex.value = 1;
            Get.to(const MainPage());
          },
          text: "بازگشت به صفحه اصلی",
        ),
      ),
    );
  }
}
