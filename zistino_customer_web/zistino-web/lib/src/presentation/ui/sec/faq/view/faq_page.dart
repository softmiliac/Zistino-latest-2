import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../controller/faq_binding.dart';
import '../controller/faq_controller.dart';
import '../widgets/faq_item.dart';

class FAQPage extends GetResponsiveView<FAQController> {
  FAQPage({Key? key}) : super(key: key);
  var theme = Get.theme;
  var context = Get.context!;
  @override
  Widget desktop() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // FAQBinding().dependencies();
    // return GetBuilder<FAQController>(
    //     initState: (state) {
    //       controller.fetchFaq(
    //           searchText: controller.searchController.text, context: Get.context!);
    //     },
    //     init: controller,
    //     builder: (_) {
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 0,
                elevation: 0),
            drawerEnableOpenDragGesture: true,
            backgroundColor: theme.backgroundColor,
            body: Column(children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsetsDirectional.only(
                    start: a/80/3,
                    end: a/80/3,
                    bottom: a/80/3,
                    top: a/80/3),
                child: Text('سوالات خودتون پیدا کنید',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              controller.obx(
                    (state) => Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: a/24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      ListView.builder(
                        padding: EdgeInsets.only(
                          left: a/80,
                          right: a/80,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.rpm?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FAQItem(index: index);
                        },
                      ),
                    ]),
                  ),
                ),
                onEmpty: Container(
                  margin: EdgeInsets.only(top: a/24),
                  child: emptyWidget('اطـلاعاتـی وجود ندارد',
                      height: b / 1.7,isDesktop: true),
                ),
                onLoading: loadingWidget(),
                onError: (error) => errorWidget(error.toString(),
                    onTap: () => controller.fetchFaq(
                        searchText: '', context: Get.context!)),
              )
            ]),
          );
        // });
  }

  @override
  Widget phone() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // FAQBinding().dependencies();
    // return GetBuilder<FAQController>(
    //     initState: (state) {
    //       controller.fetchFaq(
    //           searchText: controller.searchController.text, context: Get.context!);
    //     },
    //     init: controller,
    //     builder: (_) {
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                shadowColor: AppColors.shadowColor.withOpacity(0.2),
                elevation: 15,
                centerTitle: true,
                leading: backIcon(),
                title: Text(
                  'سؤالات متداول',
                  style: theme.textTheme.subtitle1,
                )),
            drawerEnableOpenDragGesture: true,
            backgroundColor: theme.backgroundColor,
            body: Column(children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsetsDirectional.only(
                    start: a/20,
                    end: a/24,
                    bottom: a/24,
                    top: a/20),
                child: Text('سوالات خودتون پیدا کنید',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              controller.obx(
                    (state) => Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: a/24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      ListView.builder(
                        padding: EdgeInsets.only(
                          left: a/24,
                          right: a/24,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.rpm?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FAQItem(index: index);
                        },
                      ),
                    ]),
                  ),
                ),
                onEmpty:
                emptyWidget('اطـلاعاتـی وجود ندارد', height: b / 1.7),
                onLoading: loadingWidget(),
                onError: (error) => errorWidget(error.toString(),
                    onTap: () =>
                        controller.fetchFaq(searchText: '', context: context)),
              )
            ]),
          );
        // });
  }

  @override
  Widget tablet() {
    var a = MediaQuery.of(Get.context!).size.width;
    var b = MediaQuery.of(Get.context!).size.height;
    // FAQBinding().dependencies();
    // return GetBuilder<FAQController>(
    //     initState: (state) {
    //       controller.fetchFaq(
    //           searchText: controller.searchController.text, context: Get.context!);
    //     },
    //     init: controller,
    //     builder: (_) {
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                shadowColor: AppColors.shadowColor.withOpacity(0.2),
                elevation: 15,
                centerTitle: true,
                leading: backIcon(),
                title: Text(
                  'سؤالات متداول',
                  style: theme.textTheme.subtitle1,
                )),
            drawerEnableOpenDragGesture: true,
            backgroundColor: theme.backgroundColor,
            body: Column(children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                margin: EdgeInsetsDirectional.only(
                    start: a/20,
                    end: a/24,
                    bottom: a/24,
                    top: a/20),
                child: Text('سوالات خودتون پیدا کنید',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              controller.obx(
                    (state) => Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: a/24),
                    physics: const BouncingScrollPhysics(),
                    child: Column(children: [
                      ListView.builder(
                        padding: EdgeInsets.only(
                          left: a/24,
                          right: a/24,
                        ),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.rpm?.length ?? 0,
                        itemBuilder: (context, index) {
                          return FAQItem(index: index);
                        },
                      ),
                    ]),
                  ),
                ),
                onEmpty:
                emptyWidget('اطـلاعاتـی وجود ندارد', height: b / 1.7),
                onLoading: loadingWidget(),
                onError: (error) => errorWidget(error.toString(),
                    onTap: () =>
                        controller.fetchFaq(searchText: '', context: context)),
              )
            ]),
          );
        // });
  }

}
