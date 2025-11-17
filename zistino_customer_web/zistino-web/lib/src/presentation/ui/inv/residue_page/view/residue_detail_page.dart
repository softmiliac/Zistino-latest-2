import 'package:admin_dashboard/src/presentation/ui/map_page/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/utils/number_format.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../map_page/widgets/create_delivery.dart';
import '../controller/residue_controller.dart';
import '../widgets/residue_detail_widget.dart';

class ResidueDetailPage extends StatelessWidget {
  ResidueDetailPage({super.key,required this.addressID});
  int addressID;
// DriverDeliveryEntity driverDeliveryEntity;
  final ThemeData theme = Get.theme;
  late final ResidueDeliveryController controller = Get.find();
  late final MyMapController mapController = Get.find();
  late final MainPageController mainPageController = Get.find();

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder(
    //     valueListenable: Boxes.getBasketBox().listenable(),
    //     builder: (context, box, widget) {
    return Scaffold(
        backgroundColor: AppColors.homeBackgroundColor,
        appBar: AppBar(
          leading: backIcon(),
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
                          '${formatNumber(controller.totalOrderPrice().value)} ريال',
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
                  child:Obx(()=> progressButton(
                      isDisable: controller.orderItems.isEmpty ? true : false,
                      isProgress: controller.isBusyCreateOrder.value,
                      onTap: controller.orderItems.isEmpty
                          ? () {}
                          : () {
                        debugPrint('$addressID AS');
                              controller.createOrder(addressID);
                        Get.to(CreateDriverDelivery(orderId: controller.result?.data ?? 0));

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
        ));
    // });
  }
}
