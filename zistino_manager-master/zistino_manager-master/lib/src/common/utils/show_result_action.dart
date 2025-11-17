import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/enums/bas/theme/show_result_type.dart';
import '../../data/enums/bas/theme/snackbar_type.dart';
import '../../presentation/style/dimens.dart';

void showTheResult(
    {required SnackbarType resultType,
    required ShowTheResultType showTheResultType,
    required String title,
    required String message,
    bool isLogin = false}) {
  snackBar(resultType, title, message, isLogin: isLogin);
}

/* Dialog Error Widgetas */

void dialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.red,
            child: Text(errorMessage),
          )
        ],
      );
    },
  );
}

/* SnackBar Error Widget */

void snackBar(SnackbarType resultType, String title, String message,
    {bool isLogin = false}) {
  var theme = Get.theme;
  Get.rawSnackbar(
      titleText: Text(
        title,
        style: theme.textTheme.bodyText1!
            .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      messageText: Text(
        message,
        style: theme.textTheme.bodyText2!.copyWith(color: Colors.white),
      ),
      mainButton: isLogin
          ? GestureDetector(
              onTap: () {
                // Get.off(LoginPage());
              },
              child: Container(
                margin: EdgeInsetsDirectional.only(end: standardSize),
                child: Text(
                  'Please Login',
                  style: theme.textTheme.subtitle1!
                      .copyWith(color: theme.primaryColor),
                ),
              ))
          : const SizedBox(),
      borderRadius: mediumRadius,
      duration: const Duration(milliseconds: 4500),
      overlayBlur: 0,
      backgroundColor: resultType == SnackbarType.success
          ? Colors.green
          : resultType == SnackbarType.error
              ? theme.errorColor
              : resultType == SnackbarType.warning
                  ? Colors.orangeAccent
                  : Colors.grey.shade800,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(standardSize));
}

/* Alert Error Widget */

void alert(BuildContext context, String errorMessage) {
  var theme = Theme.of(context);
  ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
    content: Text(
      errorMessage,
      style: theme.textTheme.subtitle1,
    ),
    leading: const Icon(Icons.info),
    backgroundColor: theme.cardColor,
    actions: [
      TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Some Action')),
      TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          child: const Text('Dismiss')),
    ],
  ));
}

/* Alert Error Widget */
