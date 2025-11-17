
import 'package:get/get.dart';
import '../data/repositories/base/category_repository.dart';
import '../data/repositories/base/driver_delivery_repository.dart';
import '../data/repositories/base/home_repository.dart';
import '../data/repositories/base/splash_repository.dart';
import '../data/repositories/pro/product_repository.dart';
import '../data/repositories/sec/address_repository.dart';
import '../data/repositories/sec/auth_repository.dart';
import '../data/repositories/sec/comment_repository.dart';
import '../data/repositories/sec/forgot_password_repository.dart';
import '../data/repositories/sec/orders_repository.dart';
import '../data/repositories/sec/user_repository.dart';
import '../data/repositories/sec/wallet_repository.dart';


class DependencyCreator {
  static init() {
    Get.lazyPut(() => HomeRepositoryImpl());
    Get.lazyPut(() => CategoryRepositoryImpl());
    Get.lazyPut(() => SplashRepositoryImpl());
    Get.lazyPut(() => ProductRepositoryIml());
    Get.lazyPut(() => CommentRepositoryImpl());
    Get.lazyPut(() => AuthRepositoryImpl());
    Get.lazyPut(() => AddressRepositoryImpl());
    Get.lazyPut(() => UserRepositoryImpl());
    Get.lazyPut(() => OrdersRepositoryImpl());
    Get.lazyPut(() => ForgotPasswordRepositoryImp());
    Get.lazyPut(() => DriverDeliveryRepositoryImpl());
    Get.lazyPut(() => WalletRepositoryImpl());
  }
}
