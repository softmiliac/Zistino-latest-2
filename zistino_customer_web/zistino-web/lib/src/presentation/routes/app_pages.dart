import 'package:admin_dashboard/src/presentation/ui/base/home_page/binding/binding.dart';
import 'package:admin_dashboard/src/presentation/ui/inv/checkout_page/page/checkout_page.dart';
import 'package:admin_dashboard/src/presentation/ui/sec/authentication/binding/auth_binding.dart';
import 'package:get/get.dart';
import '../ui/base/intro_page/view/introduction_page.dart';
import '../ui/base/main_page/view/main_page.dart';
import '../ui/base/products_page/binding/products_binding.dart';
import '../ui/base/products_page/view/products_page.dart';
import '../ui/base/residue_price_page/binding/binding.dart';
import '../ui/base/residue_price_page/view/residue_price_page.dart';
import '../ui/base/splash_page/view/splash_page.dart';
import '../ui/inv/residue_page/binding/binding.dart';
import '../ui/inv/residue_page/view/select_residue_page.dart';
import '../ui/map_page/binding/map_binding.dart';
import '../ui/sec/addresses/binding/address_binding.dart';
import '../ui/sec/addresses/view/addresses_page.dart';
import '../ui/sec/authentication/view/authentication_page.dart';
import '../ui/sec/edit_profile/binding/edit_profile_binding.dart';
import '../ui/sec/edit_profile/view/edit_profile_page.dart';
import '../ui/sec/faq/controller/faq_binding.dart';
import '../ui/sec/faq/view/faq_page.dart';
import '../ui/sec/orders_page/binding/order_binding.dart';
import '../ui/sec/orders_page/view/orders_page.dart';
import '../ui/sec/profile/binding/profile_binding.dart';
import '../ui/sec/transaction/binding/address_binding.dart';
import '../ui/sec/transaction/view/transaction_page.dart';
import '../ui/wallet/binding/wallet_binding.dart';

abstract class Routes {
  static const mainPage = '/main-page';
  static const productsPage = '/products-page';
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
  static const testReponsivePage = '/test-page';
  static const editProfile = '/edit-profile-page';
  static const checkOutPage = '/check-out-page';
}

class AppPages {
  static const initialRoute = Routes.mainPage;

  static final routes = [
    GetPage(
      name: Routes.addressesPage,
      page: () => AddressesPage(),
      binding: AddressBinding(),
    ),
    GetPage(
      name: Routes.productsPage,
      page: () => ProductsPage(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: Routes.ordersPage,
      page: () => OrdersPage(),
      // binding: OrderBinding()
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
        name: Routes.mainPage, page: () => MainPage(), bindings: [HomeBinding(),
      ProductsBinding(),
      WalletBinding(),
      ProfileBinding(),
      AddressBinding(),
      ProfileBinding(),
      OrderBinding(),
      FAQBinding(),
      EditProfileBinding(),
      MapBinding()

    ]),
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
        binding: TransactionBinding()),
    GetPage(
      name: Routes.faqPage,
      page: () => FAQPage(),

    ),
    GetPage(
        name: Routes.selectResiduePage,
        page: () => SelectResiduePage(addressId: 0),
        binding: ResidueDeliveryBinding()),
    GetPage(
        name: Routes.editProfile,
        page: () => EditProfilePage(),
        binding: EditProfileBinding()),
    GetPage(
        name: Routes.checkOutPage,
        page: () => CheckoutPage(id: ''),
        // binding: EditProfileBinding()
    ),

    // GetPage(
    //     name: Routes.testReponsivePage,
    //     page: () => VerificationTestResponisve(),
    //   binding:     VerifyBinding()
    //
    // ),
  ];
}
