import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'dimens.dart';

class AppThemes {
  static ThemeData themeData(BuildContext context) {
    var theme = Theme.of(context);
    return ThemeData(
      typography: Typography.material2018(),
      primaryColor: AppColors.primaryColor,
      errorColor: AppColors.errorColor,
      indicatorColor: AppColors.primaryColor,
      dividerColor: AppColors.dividerColor,
      shadowColor: AppColors.shadowColor,
      brightness: Brightness.light,
      // cardColor: AppColors.cardColor,
      backgroundColor: AppColors.backgroundColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      dialogBackgroundColor: AppColors.surfaceColor,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      toggleableActiveColor: AppColors.primaryColor,
      applyElevationOverlayColor: false,
      fontFamily: 'vazir',
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 93,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
        ),
        headline2: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 58,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        headline3:TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 46,
          fontWeight: FontWeight.w400,
        ),
        headline4: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 33,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headline5: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
        headline6: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 19,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        subtitle1: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        subtitle2: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyText1: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyText2: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        button: TextStyle(
          fontFamily: 'vazir',

          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        caption: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        overline: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.textBlackColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'vazir',

          fontWeight: FontWeight.w600,
          color: AppColors.textBlackColor,
          fontSize: 16,
          letterSpacing: 0.15,
        ),
        color: AppColors.backgroundColor,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8.0,
        selectedItemColor: AppColors.primaryColor,
        backgroundColor: AppColors.backgroundColor,
        type: BottomNavigationBarType.fixed,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceColor,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(largeSize),
        ),
        backgroundColor: AppColors.backgroundColor,
      ),
      hintColor: AppColors.hintColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(
            vertical: standardSize, horizontal: standardSize),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.captionColor,width: 1),
            borderRadius: BorderRadius.circular(smallRadius)),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 0.5),
            borderRadius: BorderRadius.circular(smallRadius)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 0.5),
            borderRadius: BorderRadius.circular(smallRadius)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.errorColor, width: 0.5),
            borderRadius: BorderRadius.circular(smallRadius)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.errorColor, width: 0.5),
            borderRadius: BorderRadius.circular(smallRadius)),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(smallRadius)),
        fillColor: AppColors.formFieldColor,
        filled: true,
        labelStyle: TextStyle(
          fontFamily: 'vazir',

          color: AppColors.captionColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.dividerColor,
        thickness: 0.3,
        endIndent: 0,
        indent: 0,
        space: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: AppColors.primaryColor,
          shadowColor: AppColors.primaryColor.withOpacity(0.50),
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: standardSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
      ),
      buttonTheme: ButtonThemeData(
          padding: EdgeInsets.all(smallSize),
          buttonColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          )),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(AppColors.primaryColor),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(AppColors.primaryColor),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          primary: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mediumRadius),
          ),
        ),
      ),
      iconTheme: IconThemeData(
        color: AppColors.iconColor,
        size: iconSizeMedium,
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.primaryColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(AppColors.primaryColor),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primaryColor,
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelStyle: theme.textTheme.subtitle1,
        labelStyle: theme.textTheme.subtitle1,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        fillColor: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(mediumRadius),
        borderColor: AppColors.borderColor,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: AppColors.accentColor,
      ),
    );
  }
}
