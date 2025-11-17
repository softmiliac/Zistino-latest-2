import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../domain/entities/base/driver_delivery.dart';
import '../../../../style/dimens.dart';

// import '../../../inv/residue_page/binding/binding.dart';
// import '../../../inv/residue_page/view/select_residue_page.dart';

Widget requestWidgetMap(DriverDeliveryEntity model,VoidCallback? onTap,bool isBusy) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: AlignmentDirectional.center,
      width: fullWidth / 1.2,
      margin: EdgeInsetsDirectional.only(end: smallSize, start: smallSize),
      padding: EdgeInsetsDirectional.all(standardSize),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(xSmallRadius),
        color: Colors.white,
        // boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1),blurRadius: 2,
        // spreadRadius: 3
        // )]
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _rowItems('assets/ic_frame.svg', model.creator),
                SizedBox(
                  height: smallSize,
                ),
                _rowItems('assets/ic_calendar-2.svg', model.address),
                SizedBox(
                  height: smallSize,
                ),
                _rowItems('assets/ic_call.svg', model.phoneNumber),
              ],
            ),
          ),
          if(isBusy)
            CupertinoActivityIndicator()
        ],
      ),
    ),
  );
}

Widget requestEmptyWidgetMap() {
  return Container(
    width: fullWidth,
    margin: EdgeInsetsDirectional.only(
        top: standardSize, end: standardSize, start: standardSize),
    padding: EdgeInsetsDirectional.all(standardSize),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(xSmallRadius),
      color: Colors.white,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "سفارشی ثبت نشده است.",
          style: Get.theme.textTheme.bodyText1
              ?.copyWith(fontWeight: FontWeight.w600),
        )
      ],
    ),
  );
}

Widget _rowItems(String icon, String name) {
  final theme = Get.theme;

  return Row(
    children: [
      SvgPicture.asset(
        icon,
        color: theme.primaryColor,
      ),
      SizedBox(width: smallSize),
      Expanded(
        child: Text(
          name,
          style: theme.textTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      )
    ],
  );
}
