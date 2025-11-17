import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../style/dimens.dart';

Widget emptyWidget(String text, {double? height, bool isDesktop = false}) {
  return AnimatedOpacity(
    duration: Duration(
      milliseconds: 900,
    ),
    opacity: 1,
    child: Container(
        height: height ?? MediaQuery.of(Get.context!).size.height/2.3,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/pic_empty.png',height: isDesktop ? MediaQuery.of(Get.context!).size.height/4 : MediaQuery.of(Get.context!).size.height/6),
            SizedBox(height: MediaQuery.of(Get.context!).size.width/24),
            Text(text,style: Get.theme.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w700,letterSpacing: 0.2)),
          ],
        )),
  );
}
