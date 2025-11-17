import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../../fake_model/bonus_model.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';
import '../../../../widgets/progress_button.dart';

Widget bonusItemWidget({required BonusModel bonus}) {
  ThemeData theme = Get.theme;
  return InkWell(
    splashColor: AppColors.splashColor,
    onTap: (bonus.actionForceEnabled || bonus.progress == bonus.total)
        ? bonus.onActionTap ?? () {}
        : () {},
    borderRadius: BorderRadius.circular(standardSize),
    child: Container(
      width: fullWidth,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: const Color(0xFFF1F1FD), //TODO: Set color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(standardSize),
      ),
      padding: EdgeInsetsDirectional.only(
        top: smallSize,
        bottom: standardSize,
        start: standardSize,
        end: standardSize,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  shape: BoxShape.circle,
                ),
                width: 43.w,
                height: 43.w,
                padding: EdgeInsetsDirectional.all(smallSize),
                margin: EdgeInsetsDirectional.only(top: smallSize),
                child: SvgPicture.asset(
                  bonus.icon,
                  color: theme.primaryColor,
                ),
              ),
              SizedBox(width: standardSize),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: smallSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            bonus.title,
                            style: theme.textTheme.bodyText1?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                          child: progressButton(
                            // radius: standardRadius,
                            isProgress: false,
                            onTap: (bonus.actionForceEnabled ||
                                    bonus.progress == bonus.total)
                                ? bonus.onActionTap ?? () {}
                                : () {},
                            isDisable: bonus.actionForceEnabled
                                ? false
                                : (bonus.progress != bonus.total),
                            text: bonus.actionText ?? "claim".tr,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: xxSmallSize,),
                    bonus.descriptionWidget ??
                        Text(
                          bonus.description ?? "",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFFB3B3B3), //TODO: Set color
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
          bonus.footer ?? SizedBox(height: standardSize),
          ClipRRect(
            borderRadius: BorderRadius.circular(standardRadius),
            child: LinearProgressIndicator(
              value: bonus.progress == 0 && bonus.total > 1
                  ? 1 / bonus.total
                  : bonus.progress / bonus.total,
              backgroundColor: AppColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            ),
          ),
          SizedBox(height: xxSmallSize),
          bonus.separateCounter ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatNumber(bonus.progress),
                style: const TextStyle(
                  color: AppColors.textBlackColor,
                ),
              ),
              Text(
                formatNumber(bonus.total),
                style: const TextStyle(
                  color: AppColors.textBlackColor,
                ),
              ),
            ],
          ) : Text(
            "${formatNumber(bonus.progress)} / ${formatNumber(bonus.total)}",
            style: const TextStyle(
              color: AppColors.textBlackColor,
            ),
          )
        ],
      ),
    ),
  );
}
