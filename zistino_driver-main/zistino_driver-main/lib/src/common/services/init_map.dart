// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
//
//
// class BackGroundService extends GetxController {
//   final service = FlutterBackgroundService();
//
//   Future<void> initializeService() async {
//     //تنظیمات ایکون و... برای فورگراند
//     await service.configure(
//         androidConfiguration: AndroidConfiguration(
//           // this will be executed when app is in foreground or background in separated isolate
//           // this will be executed when app is in foreground or background in separated isolate
//           // این فانکشنی هست ک میخوایم صدا بزنیم در مواقع بک گراند و فورگراند
//           onStart: foregroundServiceFunction,
//
//           // auto start service
//           autoStart: true,
//           isForegroundMode: true,
//
//           // notificationChannelId: 'my_foreground',
//           initialNotificationTitle: 'AWESOME SERVICE',
//           initialNotificationContent: 'Initializing',
//           foregroundServiceNotificationId: 888,
//         ),
//         iosConfiguration: IosConfiguration());
//
//     // service.startService();
//   }
//
//   Future<void> foregroundServiceFunction(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();
//     var locationPermission = await Geolocator.checkPermission();
//     // اینجا میگی ک هر چند ثانیه صدا بزنی متد رو
//     if (locationPermission == LocationPermission.always ||
//         locationPermission == LocationPermission.whileInUse) {
//       Timer.periodic(const Duration(seconds: 3), (timer) {
//         print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//
//         // هر متدی که بخوای تو بک گراند کال کنی باید اینجا صدا بزنی
//         Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//             .then((Position position) {
//           print(position);
//         }).catchError((e) {
//           print(e);
//         });
//       });
//     }
//   }
//
//   Future getLocations() async {
//     //   // اینجا باید شرط بنویید که اگر پرمیژن داشت این متد اجرا بشه
//
//     final result = await Geolocator.isLocationServiceEnabled();
//     if (result == true) {
//       print("Success");
//       await getPermission();
//     } else {
//       print("Fail");
//     }
//   }
//
// // این دوتا متد رو تو صفحه ی مپ صدا بزنید ک پرمیژن مپ رو بگیره
//
//   Future getPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently disabled. Please, enable them to use the app.');
//     } else if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission != LocationPermission.always &&
//           permission != LocationPermission.whileInUse) {
//         return Future.error(
//             'Location permissions are denied (actual value: $permission).');
//       }
//     }
//   }
//
// }
// class ShoozService extends GetxService{
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   @pragma('vm:entry-point')
//
//   void onStartt(ServiceInstance service) async {
//     DartPluginRegistrant.ensureInitialized();
//     if (service is AndroidServiceInstance) {
//       service.on('setAsForeground').listen((event) {
//         service.setAsForegroundService();
//       });
//
//       service.on('setAsBackground').listen((event) {
//         service.setAsBackgroundService();
//       });
//     }
//
//     service.on('stopService').listen((event) {
//       service.stopSelf();
//     });
//
//     Timer.periodic(const Duration(seconds: 1), (timer) async {
//       if (service is AndroidServiceInstance) {
//         if (await service.isForegroundService()) {
//           Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//               .then((Position position) {
//             debugPrint('$position asdasd');
//           }).catchError((e) {
//             print(e);
//           });
//           /// OPTIONAL for use custom notification
//           /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//           flutterLocalNotificationsPlugin.show(
//             888,
//             'COOL SERVICE',
//             'Awesome ${DateTime.now()}',
//             const NotificationDetails(
//               android: AndroidNotificationDetails(
//                 autoCancel: false,
//                 'my_foreground',
//                 'MY FOREGROUND SERVICE',
//                 category: AndroidNotificationCategory('888'),
//                 icon: 'ic_bg_service_small',
//                 ongoing: true,
//               ),
//             ),
//           );
//
//           // if you don't using custom notification, uncomment this
//           // service.setForegroundNotificationInfo(
//           //   title: "My App Service",
//           //   content: "Updated at ${DateTime.now()}",
//           // );
//         }
//       }
//
//       /// you can see this log in logcat
//       print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//
//       // test using external plugin
//       final deviceInfo = DeviceInfoPlugin();
//       String? device;
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         device = androidInfo.model;
//       }
//
//       if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         device = iosInfo.model;
//       }
//
//       service.invoke(
//         'update',
//         {
//           "current_date": DateTime.now().toIso8601String(),
//           "device": device,
//         },
//       );
//     });
//   }
//
// }