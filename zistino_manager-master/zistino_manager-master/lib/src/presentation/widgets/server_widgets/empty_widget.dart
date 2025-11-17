import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../style/dimens.dart';

Widget emptyWidget(String text, {double? height}) {
  return AnimatedOpacity(
    duration: Duration(
      milliseconds: 900,
    ),
    opacity: 1,
    child: Container(
        height: height ?? fullHeight/2.3,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/pic_empty.png',height: fullHeight/6),
            SizedBox(height: standardSize),
            Text(text,style: Get.theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w700,letterSpacing: 0.2)),
          ],
        )),
  );
}
