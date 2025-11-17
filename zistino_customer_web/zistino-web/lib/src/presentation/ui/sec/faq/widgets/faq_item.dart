// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../base/responsive_layout_base/responsive_layout_base.dart';
import '../controller/faq_controller.dart';

class FAQItem extends GetResponsiveView<FAQController> {
  int index;
  var theme = Get.theme;

  FAQItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget desktop() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: xxSmallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(
              top: xxSmallSize,
              // bottom: xxSmallSize,
              // start: xxSmallSize/2,
            ),
            child: Text(
              controller.rpm?[index].categoryName ?? '',
              style: theme.textTheme.subtitle1?.copyWith(
                  fontWeight: FontWeight.w600, color: AppColors.textBlackColor),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: xxSmallSize),
            shrinkWrap: true,
            itemCount: controller.rpm?[index].faqs.length,
            itemBuilder: (context, faqsIndex) {
              return webFaqExpansion(faqsIndex, context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget phone() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: smallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(
              top: smallSize,
              bottom: smallSize,
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

  @override
  Widget tablet() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: smallSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsetsDirectional.only(
              top: smallSize,
              bottom: smallSize,
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
          padding: EdgeInsetsDirectional.only(
              start: xSmallSize,
              end: xSmallSize,
              top: xSmallSize,
              bottom: xSmallSize),
          margin: EdgeInsets.symmetric(vertical: xSmallSize),
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
            borderRadius: BorderRadius.circular(standardRadius),
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

  Widget webFaqExpansion(int faqsIndex, BuildContext context) {
    RxBool isExpand = false.obs;

    return Obx(() {
      return Container(
          padding: EdgeInsetsDirectional.only(
            start: xxSmallSize,
            end: xxSmallSize,
          ),
          margin: EdgeInsets.symmetric(vertical: xxSmallSize / 1.7),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color:
                    isExpand.value ? theme.primaryColor : Colors.transparent),
            boxShadow: isExpand.value
                ? [
                    BoxShadow(
                        color: const Color(0xff10548B).withOpacity(0.05),
                        spreadRadius: 0.2,
                        blurRadius: 5,
                        offset: const Offset(0, 8))
                  ]
                : [],
            borderRadius: BorderRadius.circular(xxSmallRadius / 1.7),
            color: theme.cardColor,
          ),
          child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  tilePadding:
                      EdgeInsets.symmetric(horizontal: xxSmallSize / 2),
                  childrenPadding: const EdgeInsets.all(0),
                  onExpansionChanged: (value) {
                    isExpand.value = value;
                  },
                  iconColor: theme.primaryColor,
                  trailing: AnimatedRotation(
                      turns: isExpand.value ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(CupertinoIcons.chevron_down,
                          size: iconSizeXXSmall / 2.5)),
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
                            horizontal: xSmallSize / 3, vertical: xxSmallSize),
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
