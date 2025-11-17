import 'package:admin_dashboard/src/presentation/ui/base/splash_page/controller/splash_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../style/animation/slide_transition.dart';
import '../../../../style/dimens.dart';

class SplashPage extends GetResponsiveView<SplashController> {
  SplashPage({Key? key}) : super(key: key);

  final ThemeData theme = Get.theme;

  @override
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
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
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Image.asset("assets/pic_logo_zist.png",
                      scale: 2.5, color: theme.primaryColor),
                )),
            const CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget desktop() {
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
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Image.asset("assets/pic_logo_zist.png",
                      scale: 2.5, color: theme.primaryColor),
                )),
            const CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget phone() {
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
              delayStart: const Duration(milliseconds: 200),
              animationDuration: const Duration(milliseconds: 1000),
              curve: Curves.fastLinearToSlowEaseIn,
              child: Image.asset("assets/pic_logo_zist.png",
                  scale: 2.5, color: theme.primaryColor),
            )),
            const CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }

  @override
  Widget tablet() {
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
                  delayStart: const Duration(milliseconds: 200),
                  animationDuration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: Image.asset("assets/pic_logo_zist.png",
                      scale: 2.5, color: theme.primaryColor),
                )),
            const CupertinoActivityIndicator(),
          ],
        ),
      ),
    );
  }
}
