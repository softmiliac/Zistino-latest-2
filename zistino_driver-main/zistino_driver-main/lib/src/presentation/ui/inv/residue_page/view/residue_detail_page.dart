import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/common/utils/close_keyboard.dart';
import 'package:recycling_machine/src/common/utils/number_format.dart';
import 'package:recycling_machine/src/data/models/base/driver_delivery_model.dart';
import 'package:recycling_machine/src/presentation/style/colors.dart';
import 'package:recycling_machine/src/presentation/ui/base/main_page/controller/main_controller.dart';
import 'package:recycling_machine/src/presentation/widgets/back_widget.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/empty_widget.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';
import '../controller/residue_controller.dart';
import '../widgets/residue_detail_widget.dart';

class ResidueDetailPage extends StatelessWidget {

  ResidueDetailPage({super.key, required this.driverDeliveryEntity});

  DriverDeliveryModel driverDeliveryEntity;
  final ThemeData theme = Get.theme;
  late final ResidueController controller = Get.find();
  late final MainPageController mainPageController = Get.find();

  @override
  Widget build(BuildContext context) {

    // return ValueListenableBuilder(
    //     valueListenable: Boxes.getBasketBox().listenable(),
    //     builder: (context, box, widget) {
    return GestureDetector(
      onTap: () {
        closeKeyboard(context);
      },
      child: WillPopScope(
        onWillPop: () async{
          Get.back();
          return Future.value(true);
        },
        child: Scaffold(
            backgroundColor: AppColors.homeBackgroundColor,
            appBar: AppBar(
              leading: backIcon(
                onTap: () {
                  Get.back();

                },
              ),
              title: const Text(
                'انتخاب مقدار پسماند',
              ),
            ),
            bottomNavigationBar: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'جمع کل',
                            style: theme.textTheme.subtitle1,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(
                                start: xSmallSize, end: xSmallSize),
                            child: Text(
                              '${formatNumber(controller.totalOrderPrice().value)} ریال',
                              textAlign: TextAlign.end,
                              style: theme.textTheme.subtitle1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: fullWidth / 1.5,
                        // decoration:
                        //     BoxDecoration(color: theme.backgroundColor, boxShadow: [
                        //   BoxShadow(
                        //       color: AppColors.shadowColor.withOpacity(0.2),
                        //       offset: const Offset(0, -5),
                        //       spreadRadius: 0,
                        //       blurRadius: 10)
                        // ]),
                        padding: EdgeInsets.all(largeSize),
                        child: Obx(
                          () => progressButton(
                              isDisable:
                              controller.isValidTotal(),
                              isProgress: controller.isBusyCreateOrder.value,
                              onTap: controller.isValidTotal()
                                  ? () {}
                                  : () {
                                      controller.createOrder(
                                          driverDeliveryEntity);
                                      // Get.offAll(MainPage(
                                      //     selectedIndex: mainPageController
                                      //         .selectedIndex.value = 0));
                                      // controller.createOrder();
                                      // basketController.box.clear();
                                    },
                              text: "ثبت"),
                        )),
                  ],
                )),
            body: Obx(
              () => controller.orderItems.isEmpty
                  ? emptyWidget("پسماندی وجود ندارد")
                  : ListView.builder(
                      itemCount: controller.orderItems.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: standardSize),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          residueDetailWidget(controller.orderItems[index], index)),
            )),
      ),
    );
    // });
  }
}
