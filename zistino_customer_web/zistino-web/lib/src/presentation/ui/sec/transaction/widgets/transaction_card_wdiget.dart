import 'package:admin_dashboard/src/presentation/ui/sec/transaction/widgets/timeline_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/utils/number_format.dart';
import '../../../../../data/enums/transaction/index_place.dart';
import '../../../../../domain/entities/sec/wallet.dart';
import '../../../../style/colors.dart';
// import '../../../../style/dimens.dart';

Widget transactionCardWidget(Wallet item, IndexPlace indexPlace) {
   var a = MediaQuery.of(Get.context!).size.width;
  var theme = Get.theme;
  Jalali createdOn = Jalali.fromDateTime(DateTime.parse(item.createdOn ?? ''));
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(a/200)
    ),
    margin: EdgeInsetsDirectional.only(end:  a/120 ,top: a/200),
    padding: EdgeInsetsDirectional.only(
      start: a/24,
      end: a/24,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        timelineWidget(indexPlace, true),
        Container(

          margin: EdgeInsetsDirectional.only(
            start: a/47,
            end: a/47,
          ),
          padding: EdgeInsetsDirectional.all(a/100),
          width: a / 20,
          height: a / 20,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: a / 1.8,
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
                margin: EdgeInsetsDirectional.only(top: a/92),
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
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              "زمان",
              style: theme.textTheme.caption?.copyWith(
                color: AppColors.textBlackColor,
              ),
            ),
            Container(
              margin: EdgeInsetsDirectional.only(top: a/92),
              child: Text(
                '${createdOn.formatter.yyyy}/${createdOn.formatter.mm}/${createdOn.formatter.d}',
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
