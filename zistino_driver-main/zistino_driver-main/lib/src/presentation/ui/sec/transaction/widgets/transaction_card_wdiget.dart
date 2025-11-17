import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:recycling_machine/src/presentation/ui/sec/transaction/widgets/timeline_widget.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../data/enums/transaction/index_place.dart';
import '../../../../../domain/entities/sec/wallet.dart';
import '../../../../style/colors.dart';
import '../../../../style/dimens.dart';

Widget transactionCardWidget(Wallet item, IndexPlace indexPlace) {
  var theme = Get.theme;
  Jalali createdOn = Jalali.fromDateTime(DateTime.parse(item.createdOn ?? ''));
  return Container(
    padding: EdgeInsetsDirectional.only(
      start: standardSize,
      end: standardSize,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        timelineWidget(indexPlace, true),
        Container(
          margin: EdgeInsetsDirectional.only(
            start: xSmallSize,
            end: xSmallSize,
          ),
          padding: EdgeInsetsDirectional.all(xSmallSize),
          width: fullWidth / 9,
          height: fullWidth / 9,
          decoration: BoxDecoration(
            // color: entity.result.transactions.data[widget.index].type == TransactionType.Deposit //todo change type
            color: (item.type ?? 0) > 0
                ? const Color(0xffF2FAF6) // TODO: Set color
                : const Color(0xfffdf0f0), // TODO: Set color
            shape: BoxShape.circle,
          ),
          // ignore: unrelated_type_equality_checks
          child: SvgPicture.asset(
            (item.type ?? 0) > 0
                ? "assets/ic_increase.svg"
                : "assets/ic_decrease.svg",
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: fullWidth / 1.8,
                child: Text(
                  (item.type ?? 0) == 0 ? 'برداشت' : 'واریز',
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: AppColors.textBlackColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                margin: EdgeInsetsDirectional.only(top: xxSmallSize),
                child: Text(
                  formatNumber(item.price ?? 0),
                  style: theme.textTheme.caption?.copyWith(
                    color: (item.type ?? 0) > 0
                        ? const Color(0xff00D6A3) // TODO: Set color
                        : theme.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "زمان",
              style: theme.textTheme.caption?.copyWith(
                color: AppColors.textBlackColor,
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: xxSmallSize),
              child: Text(
                '${DateTime.parse(item.createdOn ?? "").hour}:${DateTime.parse(item.createdOn ?? "").minute} - ${createdOn.formatter.yyyy}/${createdOn.formatter.mm}/${createdOn.formatter.d}',
                style: theme.textTheme.caption?.copyWith(
                  fontSize: theme.textTheme.overline?.fontSize,
                  color: AppColors.captionTextColor,
                ),
              ),
            ),
          ],
        ),// TODO: Set date time from server
      ],
    ),
  );
}
