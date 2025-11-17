// import 'dart:async';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:admin_zistino/src/common/dependency.dart';
// import 'package:admin_zistino/src/common/services/get_storage_service.dart';
// import 'package:admin_zistino/src/common/utils/app_logger.dart';
// import 'package:admin_zistino/src/common/utils/hive_utils/hive_utils.dart';
// import 'package:admin_zistino/src/data/providers/remote/api_provider.dart';
// import 'package:admin_zistino/src/domain/entities/inv/basket_item.dart';
// import 'package:admin_zistino/src/presentation/routes/app_pages.dart';
// import 'package:admin_zistino/src/presentation/style/app_theme.dart';
// import 'package:admin_zistino/src/presentation/ui/base/home_page/controller/home_controller.dart';
// import 'package:admin_zistino/src/presentation/ui/inv/basket_controller/basket_controller.dart';
// import 'package:admin_zistino/src/presentation/ui/map_page/controller/tracking_controller.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:hive_flutter/adapters.dart';
//
//
// void main() async{
//   await setupHive();
//   await initServices();
//   DependencyCreator.init();
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     setupChromeSystem();
//     return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       useInheritedMediaQuery: false,
//       splitScreenMode: true,
//       builder: (context, widget) {
//         return GetMaterialApp(
//           smartManagement: SmartManagement.onlyBuilder,
//           transitionDuration: const Duration(milliseconds: 400),
//           defaultTransition: Transition.leftToRight,
//           useInheritedMediaQuery: false,
//           debugShowCheckedModeBanner: false,
//           initialRoute: AppPages.initialRoute,
//           // getPages: AppPages.routes,
//           theme: AppThemes.themeData(context),
//           locale: const Locale('fa'),
//           title: "زیستینو راننده",
//           builder: (context, widget) {
//             return MediaQuery(
//               data: MediaQuery.of(context).copyWith(
//                 textScaleFactor: 1.0,
//               ),
//               child: widget!,
//             );
//           },
//         );
//       },
//     );
//   }
// }
//
// setupHive() async {
//   try {
//     await Hive.initFlutter();
//     Hive.registerAdapter(BasketItemAdapter());
//     // Hive.registerAdapter(BookmarkItemAdapter());
//     await Hive.openBox<BasketItem>(Boxes.basketBox);
//     // await Hive.openBox<BasketItem>(Boxes.nextShoppingBox);
//     // await Hive.openBox<BookmarkItem>(Boxes.bookmarkBox);
//   } catch (_) {
//     AppLogger.catchLog(_);
//   }
// }
//
// Future initServices() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await GetStorage.init();
//   await initializeService();
//   Get.put(LocalStorageService());
//   Get.put(APIProvider());
//   Get.put(BasketController());
//   // Get.put(MyMapController());
//
//   // Get.putAsync<Isar>(() async => IsarUtil(),
//   //     permanent: true);
//   //
//   // await IsarUtil().initDatabase();
//
// }
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//
//   //تنظیمات ایکون و... برای فورگراند
//   await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         // this will be executed when app is in foreground or background in separated isolate
//         // this will be executed when app is in foreground or background in separated isolate
//        // این فانکشنی هست ک میخوایم صدا بزنیم در مواقع بک گراند و فورگراند
//         onStart: foregroundServiceFunction,
//
//         // auto start service
//         autoStart: false,
//         isForegroundMode: true,
//
//         notificationChannelId: 'my_foreground',
//         initialNotificationTitle: 'AWESOME SERVICE',
//         initialNotificationContent: 'Initializing',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration());
//
//   // service.startService();
// }
//
//
// Future<void> foregroundServiceFunction(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//
//   // اینجا میگی ک هر چند ثانیه صدا بزنی متد رو
//   Timer.periodic(Duration(seconds: 3), (timer) {
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//
//     // هر متدی که بخوای تو بک گراند کال کنی باید اینجا صدا بزنی
//     getLocations();
//   });
// }
//
//
// void getLocations() {
//
//   // اینجا باید شرط بنویسید که اگر پرمیژن داشت این متد اجرا بشه
//   Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//       .then((Position position) {
//     print(position);
//   }).catchError((e) {
//     print(e);
//   });
// }
//
//
//
// // این دوتا متد رو تو صفحه ی مپ صدا بزنید ک پرمیژن مپ رو بگیره
//
//
// //void getPermission() async {
// //   LocationPermission permission = await Geolocator.checkPermission();
// //   checkGPS();
// //
// //   if (permission == LocationPermission.deniedForever) {
// //     return Future.error(
// //         'Location permissions are permanently disabled. Please, enable them to use the app.');
// //   } else if (permission == LocationPermission.denied) {
// //     permission = await Geolocator.requestPermission();
// //     if (permission != LocationPermission.always &&
// //         permission != LocationPermission.whileInUse) {
// //       return Future.error(
// //           'Location permissions are denied (actual value: $permission).');
// //     }
// //   }
// // }
// //
// // checkGPS() async {
// //   final result = await Geolocator.isLocationServiceEnabled();
// //   if (result == true) {
// //     print("Success");
// //   } else {
// //     print("Fail");
// //   }
// // }
//
//
// void setupChromeSystem() {
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
// }
