import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../style/colors.dart';
import '../style/dimens.dart';

Widget backIcon({VoidCallback? onTap, Color? iconColor}) {
  return RotatedBox(
    quarterTurns: 2,
    child: IconButton(
      splashRadius: standardSize,
      splashColor: AppColors.splashColor,
      icon: SvgPicture.asset('assets/ic_back.svg',
          color: iconColor ?? Get.theme.iconTheme.color),
      onPressed: onTap ??
          () {
            Get.back();
          },
    ),
  );
}
