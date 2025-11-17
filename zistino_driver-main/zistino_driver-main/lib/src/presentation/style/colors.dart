import 'package:flutter/material.dart';

class AppColors {
  static LinearGradient primaryGradientColor = const LinearGradient(
      colors: [
        Color(0xFF1c855f),
        Color(0xFF7BE5A9),
      ],
      begin: AlignmentDirectional.bottomStart,
      end: AlignmentDirectional.topEnd
  );
  static const Color primaryColor = Color(0xFF45B886);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color homeBackgroundColor = Color(0xFFF2F3F7);
  static const Color formFieldColor = Color(0xFFFFFFFF); //
  static Color captionColor = Colors.black.withOpacity(0.3); //
  static const Color textBlackColor = Color(0xFF181725); //




  static const Color accentColor = Color(0xFF0F172A); //
  static const Color borderColor = Color(0xffA8A8A8); //
  static const Color iconColor = Color(0xffffffff); //
  static const Color descriptionColor = Color(0xff666666); //
  static const Color descriptionColor2 = Color(0xff767171); //
  static const Color surfaceColor = Color(0xFF000000); //
  static const Color textWhiteColor = Color(0xffffffff); //
  static const Color cardColor = Color(0xff000000); //
  static Color hintColor = const Color.fromARGB(60, 235, 235, 245); //
  static Color dividerColor = Colors.black.withOpacity(0.2); //
  static Color splashColor = const Color(0xFF45B886).withOpacity(0.03); //todo
  static const Color errorColor = Colors.red; //
  static const Color shadowColor = Color(0xffbbbbbb); //

  static const Color captionTextColor = Color(0xff637381); //

  static const Color successfulColor = Color(0xFF39B54A);
  static const Color failedColor = Color(0xFFD14141);
}
