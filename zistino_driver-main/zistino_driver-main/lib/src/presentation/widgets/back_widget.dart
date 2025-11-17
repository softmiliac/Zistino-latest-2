import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../style/colors.dart';
import '../style/dimens.dart';

Widget backIcon({VoidCallback? onTap, Color? iconColor}) {
  return IconButton(
    splashRadius: standardSize,
    splashColor: AppColors.splashColor,
    icon: const Icon(Icons.arrow_back,
        color: Colors.black),
    onPressed: onTap ??
        () {
          Get.back();
        },
  );
}
