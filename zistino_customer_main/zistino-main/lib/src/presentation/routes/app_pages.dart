import 'package:zistino/src/domain/entities/sec/address_entity.dart';
import 'package:zistino/src/presentation/ui/base/home_page/binding/binding.dart';
import 'package:zistino/src/presentation/ui/map_page/view/map_page.dart';
import 'package:zistino/src/presentation/ui/sec/authentication/binding/auth_binding.dart';
import 'package:get/get.dart';
import 'package:zistino/src/presentation/ui/sec/review_page/binding/review_binding.dart';
import 'package:zistino/src/presentation/ui/sec/review_page/view/review_page.dart';
import '../ui/base/intro_page/view/introduction_page.dart';
import '../ui/base/main_page/view/main_page.dart';
import '../ui/base/residue_price_page/binding/binding.dart';
import '../ui/base/residue_price_page/view/residue_price_page.dart';
import '../ui/base/splash_page/view/splash_page.dart';
import '../ui/inv/residue_page/binding/binding.dart';
import '../ui/inv/residue_page/view/select_residue_page.dart';
import '../ui/map_page/binding/map_binding.dart';
import '../ui/sec/addresses/binding/address_binding.dart';
import '../ui/sec/addresses/view/addresses_page.dart';
import '../ui/sec/authentication/binding/verification_binding.dart';
import '../ui/sec/authentication/view/authentication_page.dart';
import '../ui/sec/authentication/view/verification_page.dart';
import '../ui/sec/faq/view/faq_page.dart';
import '../ui/sec/orders_page/view/orders_page.dart';
import '../ui/sec/sign_up_page/binding/sign_up_binding.dart';
import '../ui/sec/sign_up_page/view/sign_up_page.dart';
import '../ui/sec/transaction/view/transaction_page.dart';

abstract class Routes {
  static const mainPage = '/main-page';
  static const authenticationPage = '/authentication-page';
  static const addressesPage = '/addresses-page';
  static const verificationPage = '/verification-page';
  static const splashPage = '/splash-page';
  static const ordersPage = '/orders-page';
  static const residuePricePage = '/residue_price_page';
  static const introductionPage = '/introduction_page';
  static const transactionPage = '/transaction_page';
  static const faqPage = '/faq-page';
  static const selectResiduePage = '/select-residue-page';
  static const introTest = '/introTest';
  static const mapPage = '/mapPage';
  static const reviewPage = '/review_page';
  static const signUpPage = '/sign_up_page';
}

class AppPages {
  static const initialRoute = Routes.splashPage;

  static final routes = [
    GetPage(
      name: Routes.addressesPage,
      page: () => AddressesPage(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.introTest,
      page: () => IntroTest(),
      // binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.ordersPage,
      page: () => OrdersPage(),
      // binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.authenticationPage,
      page: () => AuthenticationPage(),
      binding: AuthBinding(),
    ),
    // GetPage(
    //   name: Routes.verificationPage,
    //   page: () => VerificationPage(),
    //   binding: AuthBinding(),
    // ),
    GetPage(
        name: Routes.mainPage, page: () => const MainPage(), binding: HomeBinding()),
    GetPage(
      name: Routes.splashPage,
      page: () => SplashPage(),
    ),
    GetPage(
        name: Routes.residuePricePage,
        page: () => ResiduePricePage(),
        binding: ResiduePriceBinding()),
    GetPage(
      name: Routes.introductionPage,
      page: () => IntroductionPage(),
    ),
    GetPage(
      name: Routes.transactionPage,
      page: () => TransactionPage(),
    ),
    GetPage(
      name: Routes.faqPage,
      page: () => FAQPage(),
    ),
    GetPage(
        name: Routes.selectResiduePage,
        page: () => SelectResiduePage(address: AddressEntity()),
        binding: ResidueDeliveryBinding()),

    GetPage(name: Routes.mapPage, page: () => MapPage(), binding: MapBinding()),
    GetPage(
        name: Routes.reviewPage,
        page: () => ReviewPage(),
        binding: ReviewBinding()),
    GetPage(
        name: Routes.signUpPage,
        page: () => SignUpPage(),
        binding: SignUpBinding()),
    GetPage(
        name: Routes.verificationPage,
        page: () => VerificationPage(phoneNumber: '', message: ''),
        binding: VerifyBinding()),
  ];
}
