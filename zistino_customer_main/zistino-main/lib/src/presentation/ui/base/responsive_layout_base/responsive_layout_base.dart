import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../style/dimens.dart';

abstract class ResponsiveLayoutBaseGetView<T> extends StatelessWidget {
  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag)!;

  const ResponsiveLayoutBaseGetView({Key? key}) : super(key: key);

  Widget responsiveWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        if (constraints.maxWidth > 360 && constraints.maxWidth < 480) {
          return mobile(context);
        } else if (constraints.maxWidth >= 800 &&
            constraints.maxWidth <= 1280) {
          return tablet(context);
        } else if (constraints.maxWidth > 1280) {
          return desktop(context);
        }
        return mobile(context);
      },
    );
  }

  Widget mobile(BuildContext context);

  Widget tablet(BuildContext context);

  Widget desktop(BuildContext context);
}

Widget scaffoldPublic({required String title, required List<Widget> children,Widget? bottomNavigationWidget}) {
  return Scaffold(
    bottomNavigationBar: bottomNavigationWidget,
    appBar: AppBar(
      title: Text(title),
    ),
    body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsetsDirectional.only(
            start: standardSize, end: standardSize, top: standardSize),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children),
      ),
    ),
  );
}

abstract class RespTest<T> extends StatelessWidget{
  final String? tag = null;
   RespTest({super.key});

  T get controller => GetInstance().find<T>(tag: tag)!;
  Widget responsive(BuildContext context){
    RxBool isLarge = false.obs;

    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        debugPrint('${orientation} asda');

        if (MediaQuery.of(context).size.width>700) {
          isLarge.value = true;
        }  else{
          isLarge.value = false;
        }
        debugPrint('${isLarge.value} asda');

        return Obx(()=> isLarge.value == false

            ? mobile(context)

            : desktop(context));

      },

    );
  }
  Widget mobile(BuildContext context);
  Widget desktop(BuildContext context);}
