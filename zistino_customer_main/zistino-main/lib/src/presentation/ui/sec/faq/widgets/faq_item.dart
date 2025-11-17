// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../controller/faq_controller.dart';

class FAQItem extends GetWidget<FAQController> {
  int index;
  var theme = Get.theme;

  FAQItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: xxSmallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(
              top: xSmallSize,
              bottom: xSmallSize,
              start: smallSize,
            ),
            child: Text(
              controller.rpm?[index].categoryName ?? '',
              style: theme.textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textBlackColor),
            ),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.rpm?[index].faqs.length,
              itemBuilder: (context, faqsIndex) {
                return faqExpansion(faqsIndex, context);
              }),
        ],
      ),
    );
  }

  Widget faqExpansion(int faqsIndex, BuildContext context) {
    RxBool isExpand = false.obs;

    return Obx(() {
      return Container(
          // padding: EdgeInsetsDirectional.only(
          //     start: xxSmallSize,
          //     end: xxSmallSize,
          //     top: xxSmallSize,
          //     bottom: xxSmallSize
          // ),
          margin: EdgeInsets.symmetric(vertical: xxSmallSize),
          decoration: BoxDecoration(
            boxShadow: isExpand.value
                ? [
                    BoxShadow(
                        color: const Color(0xff10548B).withOpacity(0.08),
                        spreadRadius: 0.2,
                        blurRadius: 10,
                        offset: const Offset(0, 10))
                  ]
                : [],
            borderRadius: BorderRadius.circular(smallRadius),
            color: theme.cardColor,
          ),
          child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: standardSize),
                  childrenPadding: const EdgeInsets.all(0),
                  onExpansionChanged: (value) {
                    isExpand.value = value;
                  },
                  iconColor: theme.primaryColor,
                  collapsedIconColor: AppColors.textBlackColor,
                  title: Text(
                    controller.rpm?[index].faqs[faqsIndex].title ?? '',
                    maxLines: 4,
                    style: theme.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isExpand.value
                            ? theme.primaryColor
                            : AppColors.textBlackColor),
                  ),
                  children: [
                    Container(
                        alignment: AlignmentDirectional.centerStart,
                        padding: EdgeInsets.symmetric(
                            horizontal: standardSize, vertical: xSmallSize),
                        child: Text(
                            controller
                                    .rpm?[index].faqs[faqsIndex].description ??
                                '',
                            textAlign: TextAlign.start,
                            style: theme.textTheme.caption?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)))
                  ])));
    });
  }
}
