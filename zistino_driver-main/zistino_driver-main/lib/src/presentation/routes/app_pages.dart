import 'package:recycling_machine/src/presentation/ui/sec/authentication/binding/auth_binding.dart';
import 'package:get/get.dart';
import '../ui/base/intro_page/binding/intro_binding.dart';
import '../ui/base/intro_page/view/introduction_page.dart';
import '../ui/base/main_page/view/main_page.dart';
import '../ui/base/splash_page/binding/splash_binding.dart';
import '../ui/base/splash_page/view/splash_page.dart';
import '../ui/sec/authentication/view/authentication_page.dart';
import '../ui/sec/authentication/view/verification_page.dart';

abstract class Routes {
  static const mainPage = '/main-page';
  static const authenticationPage = '/authentication-page';
  static const verificationPage = '/verification-page';
  static const splashPage = '/splash-page';
  static const residuePricePage = '/residue_price_page';
  static const introductionPage = '/introduction_page';
  static const customMap = '/custom_map';
  static const residuePage = '/residue-page';
}

class AppPages {
  static const initialRoute = Routes.splashPage;

  static final routes = [

    GetPage(
      name: Routes.authenticationPage,
      page: () => AuthenticationPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.verificationPage,
      page: () => VerificationPage(message: '',phoneNumber: ''),
      binding: VerifyBinding(),
    ),
    GetPage(
      name: Routes.mainPage,
      page: () => MainPage(),
    ),
    GetPage(
      name: Routes.splashPage,
      page: () => SplashPage(),
      binding: SplashBinding()
    ),
    GetPage(
      name: Routes.introductionPage,
      page: () => IntroductionPage(),
      binding:IntroBinding()
    ),
    // GetPage(
    //   name: Routes.residuePage,
    //   page: () => ResidueDetailPage(),
    // ),
  ];
}
