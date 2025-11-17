// ignore_for_file: must_be_immutable

import 'package:admin_dashboard/src/presentation/ui/map_page/view/map_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../domain/entities/pro/category_entity.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/progress_button.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../binding/binding.dart';
import '../controller/residue_controller.dart';
import '../widgets/select_residue_widget.dart';
import 'residue_detail_page.dart';

class SelectResiduePage extends GetResponsiveView<ResidueDeliveryController> {
  SelectResiduePage({Key? key,required this.addressId}) : super(key: key);
  int addressId;
  final ThemeData theme = Get.theme;



  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchCategories();
    //
    //     },
    //     builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              // if(isFromMain){
              //
              // Get.off(MainPage());
              // controller.selectedCat.clear();
              // }else{
              controller.selectedCat.clear();
              Get.to(MapPage());
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
                  //   Get.off(MainPage());
                  //   controller.selectedCat.clear();
                  // }else{
                  Get.to(MapPage());
                  controller.selectedCat.clear();

                  // }
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
                padding: EdgeInsets.all(a/16),
                child: progressButton(
                    isDisable: controller.selectedCat.isEmpty
                        ? true
                        : false,
                    isProgress: false,
                    onTap: controller.selectedCat.isEmpty
                        ? () {}
                        : () {

                      Get.to(ResidueDetailPage(addressID: addressId,));
                      controller.createOrderItems();
                    },
                    text: "ادامه"),
              )),
              body: controller.obx(
                      (state) => ListView.builder(
                    padding: EdgeInsets.only(
                        top: a/16,
                        left: a/24,
                        right: a/24),
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
                  onLoading: loadingWidget(),
                  onEmpty: emptyWidget("پسماندی وجود ندارد")),
            ),
          );
        // });
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
        // init: controller,
        // initState: (state) {
        //   controller.fetchCategories();
        //
        // },
        // builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              // if(isFromMain){
              //
              // Get.off(MainPage());
              // controller.selectedCat.clear();
              // }else{
                controller.selectedCat.clear();
                Get.to(MapPage());
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
                  //   Get.off(MainPage());
                  //   controller.selectedCat.clear();
                  // }else{
                  Get.to(MapPage());
                    controller.selectedCat.clear();

                  // }
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
                      padding: EdgeInsets.all(a/16),
                      child: progressButton(
                          isDisable: controller.selectedCat.isEmpty
                              ? true
                              : false,
                          isProgress: false,
                          onTap: controller.selectedCat.isEmpty
                              ? () {}
                              : () {

                            Get.to(ResidueDetailPage(addressID: addressId,));
                            controller.createOrderItems();
                                },
                          text: "ادامه"),
                    )),
              body: controller.obx(
                  (state) => ListView.builder(
                        padding: EdgeInsets.only(
                            top: a/16,
                            left: a/24,
                            right: a/24),
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
                  onLoading: loadingWidget(),
                  onEmpty: emptyWidget("پسماندی وجود ندارد")),
            ),
          );
        // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // return GetBuilder(
    //     init: controller,
    //     initState: (state) {
    //       controller.fetchCategories();
    //
    //     },
    //     builder: (_) {
          return WillPopScope(
            onWillPop: () async {
              // if(isFromMain){
              //
              // Get.off(MainPage());
              // controller.selectedCat.clear();
              // }else{
              controller.selectedCat.clear();
              Get.to(MapPage());
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
                  //   Get.off(MainPage());
                  //   controller.selectedCat.clear();
                  // }else{
                  Get.to(MapPage());
                  controller.selectedCat.clear();

                  // }
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
                padding: EdgeInsets.all(a/16),
                child: progressButton(
                    isDisable: controller.selectedCat.isEmpty
                        ? true
                        : false,
                    isProgress: false,
                    onTap: controller.selectedCat.isEmpty
                        ? () {}
                        : () {

                      Get.to(ResidueDetailPage(addressID: addressId,));
                      controller.createOrderItems();
                    },
                    text: "ادامه"),
              )),
              body: controller.obx(
                      (state) => ListView.builder(
                    padding: EdgeInsets.only(
                        top: a/16,
                        left: a/24,
                        right: a/24),
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
                  onLoading: loadingWidget(),
                  onEmpty: emptyWidget("پسماندی وجود ندارد")),
            ),
          );
        // });
  }
}
