import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/data/models/base/driver_delivery_model.dart';
import 'package:recycling_machine/src/domain/entities/base/driver_delivery.dart';
import 'package:recycling_machine/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/empty_widget.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/error_widget.dart';
import 'package:recycling_machine/src/presentation/widgets/server_widgets/loading_widget.dart';
import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../base/main_page/view/main_page.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../controller/residue_controller.dart';
import '../widgets/select_residue_widget.dart';
import 'residue_detail_page.dart';

class SelectResiduePage extends ResponsiveLayoutBaseGetView<ResidueController> {
  SelectResiduePage({Key? key,required this.isFromMain,required this.driverDeliveryEntity}) : super(key: key);

  final ThemeData theme = Get.theme;

  bool isFromMain = false;
  DriverDeliveryModel driverDeliveryEntity;

  final BasketController basketController = Get.find();

  @override
  Widget build(BuildContext context) {
    return responsiveWidget(context);
  }

  @override
  Widget desktop(BuildContext context) {
    // TODO: implement desktop
    throw UnimplementedError();
  }

  @override
  Widget mobile(BuildContext context) {
    return GetBuilder(
        init: controller,
        initState: (state) {
          controller.fetchCategories();
          controller.
          fetchResidueRemote();
        },
        builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              if(isFromMain){

              Get.off(MainPage());
              controller.selectedCat.clear();
              }else{
                controller.selectedCat.clear();

                Get.back();
              }
              basketController.box.clear();
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
                  if(isFromMain){

                    Get.off(MainPage());
                    controller.selectedCat.clear();

                  }else{
                    Get.back();
                    controller.selectedCat.clear();

                  }
                  basketController.box.clear();
                }),
              ),
              bottomNavigationBar:Obx(()=>Container(
                      decoration: BoxDecoration(
                          color: theme.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.shadowColor.withOpacity(0.2),
                                offset: const Offset(0, -5),
                                spreadRadius: 0,
                                blurRadius: 10)
                          ]),
                      padding: EdgeInsets.all(largeSize),
                      child: progressButton(
                          isDisable: controller.selectedCat.isEmpty
                              ? true
                              : false,
                          isProgress: false,
                          onTap: controller.selectedCat.isEmpty
                              ? () {}
                              : () {

                            Get.to(ResidueDetailPage(driverDeliveryEntity: driverDeliveryEntity,));
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
                          return selectResidueWidget(index,
                              controller.categoryRPM?[index] ?? CategoryEntity());

                        },
                      ),
                  onError: (error) => errorWidget("$error",onTap: () {
                    controller.fetchCategories();
                  }),
                  onLoading: loadingWidget(defaultHeight: false),
                  onEmpty: emptyWidget("پسماندی وجود ندارد")),
            ),
          );
        });
  }

  @override
  Widget tablet(BuildContext context) {
    // TODO: implement tablet
    throw UnimplementedError();
  }
}
