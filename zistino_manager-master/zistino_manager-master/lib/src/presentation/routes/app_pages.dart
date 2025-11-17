import 'package:admin_zistino/src/presentation/ui/base/home_page/binding/binding.dart';
import 'package:admin_zistino/src/presentation/ui/sec/authentication/binding/auth_binding.dart';
import 'package:admin_zistino/src/presentation/ui/base/map_page/view/tracking_vehicle_page.dart';
import 'package:get/get.dart';
import '../ui/base/home_page/view/home_page.dart';
import '../../domain/entities/sec/address_entity.dart';
import '../ui/base/main_page/view/main_page.dart';
import '../ui/base/map_page/view/polyline_map_page.dart';
import '../ui/base/residue_page/binding/binding.dart';
import '../ui/base/residue_page/view/select_residue_page.dart';
import '../ui/base/splash_page/binding/splash_binding.dart';
import '../ui/base/splash_page/view/splash_page.dart';
import '../ui/sec/authentication/view/authentication_page.dart';

abstract class Routes {
  static const mainPage = '/main-page';
  static const mapPage = '/map-page';
  static const homePage = '/home-page';
  static const authenticationPage = '/authentication-page';
  static const verificationPage = '/verification-page';
  static const splashPage = '/splash-page';
  static const residuePricePage = '/residue_price_page';
  static const introductionPage = '/introduction_page';
  static const customMap = '/custom_map';
  static const residuePage = '/residue-page';
  static const selectResiduePage = '/select-residue-page';
}

class AppPages {
  static const initialRoute = Routes.splashPage;

  static final routes = [

    GetPage(
        name: Routes.selectResiduePage,
        page: () => SelectResiduePage(deliveryUserId: ''),
        binding: ResidueDeliveryBinding()),
    GetPage(
      name: Routes.authenticationPage,
      page: () => AuthenticationPage(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: Routes.mainPage,
      page: () => MainPage(),
    ),
    // GetPage(
    //   name: Routes.mapPage,
    //   page: () => PolyLinePage(),
    // ),
    GetPage(
      name: Routes.homePage,
      page: () => HomePage(),
      binding: HomeBinding()
    ),
    GetPage(
      name: Routes.splashPage,
      page: () => SplashPage(),
      binding: SplashBinding()
    ),
    // GetPage(
    //   name: Routes.customMap,
    //   page: () => TrackingVehiclePage(),
    //   // binding: SplashBinding()
    // ),

    // GetPage(
    //   name: Routes.residuePage,
    //   page: () => ResidueDetailPage(),
    // ),
  ];
}
