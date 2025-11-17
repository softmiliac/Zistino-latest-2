import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin_zistino/src/presentation/ui/base/splash_page/controller/splash_controller.dart';
import '../../../../style/animation/slide_transition.dart';
import '../../../../style/dimens.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});

  final ThemeData theme = Get.theme;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (logic) {
      return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          backgroundColor: theme.backgroundColor,
        ),
        body: Container(
          margin: EdgeInsets.only(bottom: xLargeSize),
          width: fullWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: SlideFadeTransition(
                delayStart: const Duration(milliseconds: 100),
                animationDuration: const Duration(milliseconds: 500),
                curve: Curves.fastLinearToSlowEaseIn,
                child: Image.asset("assets/pic_logo.png", scale: 2.5),
              )),
              const CupertinoActivityIndicator(),
            ],
          ),
        ),
      );
    });
  }
}
