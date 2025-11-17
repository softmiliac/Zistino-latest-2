import 'package:admin_dashboard/src/presentation/style/dimens.dart';
import 'package:admin_dashboard/src/presentation/ui/base/main_page/view/main_page.dart';
import 'package:admin_dashboard/src/presentation/widgets/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/home_page/controller/home_controller.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/products_page/controller/products_controller.dart';
import '../../basket_controller/basket_controller.dart';

class SendWithSmsPage extends StatelessWidget {
  final theme = Get.theme;
  final MainPageController mainController = Get.find();
  final ProductsController productsController = Get.find();
  final BasketController basketController = Get.find();

  SendWithSmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(standardSize),
        child: progressButton(
          isProgress: false,
          onTap: () {
            productsController.fetchProducts();
            basketController.box.clear();
            Get.to(MainPage(selectedIndex: mainController.selectedIndex.value = 1,));
          },
          text: 'بازگشت به صفحه اصلی'

        ),
      ),
      appBar: AppBar(
        title:  Text('تکمیل صورت حساب',style: theme.textTheme.subtitle1,),
      ),
      body: SizedBox(
        width: fullWidth,
        height: fullHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsetsDirectional.all(standardSize),
              height: fullWidth,
              child: Text(
                'کالاهای سفارش داده شده در تحویل پسماند بعدی برای شما ارسال خواهد شد',
                style: theme.textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
