import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../fake_model/terms_and_conditions_model.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

Widget termsAndConditionsWidget(BuildContext context,TermsAndConditionsModel entity) {
  RxBool isExpand = false.obs;
  var theme = Get.theme;
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
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
                tilePadding: EdgeInsets.symmetric(horizontal: standardSize),
                childrenPadding: const EdgeInsets.all(0),
                onExpansionChanged: (value) {
                  isExpand.value = value;
                },
                iconColor: theme.primaryColor,
                collapsedIconColor: AppColors.textBlackColor,
                title: Text(
                  entity.title,
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
                      child: Text(entity.desc,
                          textAlign: TextAlign.start,
                          style: theme.textTheme.caption?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)))
                ])));
  });
}
// }
