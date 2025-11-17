// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/back_widget.dart';
import '../../../../widgets/server_widgets/empty_widget.dart';
import '../../../../widgets/server_widgets/error_widget.dart';
import '../../../../widgets/server_widgets/loading_widget.dart';
import '../controller/faq_binding.dart';
import '../controller/faq_controller.dart';
import '../widgets/faq_item.dart';

class FAQPage extends GetView<FAQController> {
  FAQPage({Key? key}) : super(key: key);
  var theme = Get.theme;
  var isEmptyField = false.obs;

  @override
  Widget build(BuildContext context) {
    FAQBinding().dependencies();
    return GetBuilder<FAQController>(
        initState: (state) {
          controller.fetchFaq(
              searchText: controller.searchController.text, context: context);
        },
        init: controller,
        builder: (_) {
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
                    start: largeSize, end: standardSize, bottom: standardSize,top: largeSize),
                child: Text('سوالات خودتون پیدا کنید',
                    textAlign: TextAlign.start,
                    style: theme.textTheme.headline6
                        ?.copyWith(fontWeight: FontWeight.w600)),
              ),
              controller.obx(
                (state) => Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: standardSize),
                    physics: const BouncingScrollPhysics(),
                    child: ListView.builder(
                      padding: EdgeInsets.only(
                        left: standardSize,
                        right: standardSize,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.rpm?.length ?? 0,
                      itemBuilder: (context, index) {
                        return FAQItem(index: index);
                      },
                    ),
                  ),
                ),
                onEmpty: emptyWidget('اطـلاعاتـی وجود ندارد',height: fullHeight/1.7),
                onLoading: loadingWidget(),
                onError: (error) => errorWidget(error.toString(),onTap: () => controller.fetchFaq(searchText: '', context: context)),
              )
            ]),
          );
        });
  }
}
