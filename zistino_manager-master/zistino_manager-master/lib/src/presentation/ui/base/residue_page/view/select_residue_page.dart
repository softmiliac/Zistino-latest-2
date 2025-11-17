// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:admin_zistino/src/presentation/routes/app_pages.dart';
import 'package:admin_zistino/src/presentation/ui/base/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../map_page/view/tracking_vehicle_page.dart';
import '../binding/binding.dart';
import '../controller/residue_controller.dart';
import '../widgets/select_residue_widget.dart';
import 'residue_detail_page.dart';

class SelectResiduePage extends StatelessWidget {
  SelectResiduePage({super.key,required this.deliveryUserId});
  String deliveryUserId;
  final ThemeData theme = Get.theme;
  final ResidueDeliveryController controller= Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResidueDeliveryController>(
        init: controller,
        initState: (state) {
          controller.fetchCategories();
          controller.fetchResidueRemote();
          deliveryUserId = Get.arguments as String;
        },
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              // if(isFromMain){
              //
              // Get.off(MainPage());
              // controller.selectedCat.clear();
              // }else{
              controller.selectedCat.clear();
              Get.offNamed(Routes.homePage);
              // }
              return false;
            },
            child: Scaffold(
              backgroundColor: AppColors.homeBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.backgroundColor,
                shadowColor: AppColors.shadowColor.withOpacity(0.2),
                elevation: 15,
                title: const Text("انتخاب نوع پسماند"),
                leading: backIcon(onTap: () {
                  // if(isFromMain){
                  Get.offNamed(Routes.homePage);
                  //   controller.selectedCat.clear();
                  // }else{
                  controller.selectedCat.clear();
                  // Get.off(TrackingVehiclePage());

                  // }
                }),
              ),
              bottomNavigationBar: Obx(() => Container(
                decoration:
                BoxDecoration(color: theme.backgroundColor, boxShadow: [
                  BoxShadow(
                      color: AppColors.shadowColor.withOpacity(0.2),
                      offset: const Offset(0, -5),
                      spreadRadius: 0,
                      blurRadius: 10)
                ]),
                padding: EdgeInsets.all(largeSize),
                child: progressButton(
                    isDisable:
                    controller.selectedCat.isEmpty ? true : false,
                    isProgress: false,
                    onTap: controller.selectedCat.isEmpty
                        ? () {}
                        : () {
                      debugPrint(controller.result?.data.toString());
                      Get.to(ResidueDetailPage(deliveryUserID: deliveryUserId,));
                      controller.orderQuantity.clear();
                      controller.createOrderItems();
                    },
                    text: "ادامه"),
              )),
              body: controller.obx(
                      (state) => ListView.builder(
                    padding: EdgeInsets.only(
                        top: largeSize,
                        left: standardSize,
                        right: standardSize),
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.categoryRPM?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return selectResidueWidget(
                          index,
                          controller.categoryRPM?[index] ??
                              CategoryEntity());
                    },
                  ),
                  onError: (error) => errorWidget("$error", onTap: () {
                    controller.fetchCategories();
                  }),
                  onLoading: loadingWidget(),
                  onEmpty: emptyWidget("پسماندی وجود ندارد")),
            ),
          );
        });
  }


}
