


class AppConfiguration {
  final ThemeColors lightColors;
  final ThemeColors darkColors;
  final String appName;
  final String appIconUrl;

  AppConfiguration(
      {required this.lightColors,
      required this.darkColors,
      required this.appName,
      this.appIconUrl = ""});
}

class ThemeColors {
  int primary;
  int background;

  ThemeColors({this.primary = 00000, this.background = 0});
}
