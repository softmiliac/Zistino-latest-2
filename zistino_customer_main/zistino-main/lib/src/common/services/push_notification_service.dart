//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:mobile_fabric/sec/common/services/get_storage_service.dart';
//
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// // final NavigationService _navigationService = locator<NavigationService>();
// var initializationSettingsAndroid =
//     const AndroidInitializationSettings('drawable/logo_notif');
//
// const IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//         requestAlertPermission: true, defaultPresentSound: true);
// String? pageId;
//
// class PushNotificationService extends GetxService{
//   final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   final LocalStorageService preferences = Get.find<LocalStorageService>();
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   Future initialise() async {
//     // _fcm.subscribeToTopic("vip")
//
//     preferences.firebaseToken = (await _fcm.getToken())!;
//     NotificationSettings settings = await _fcm.requestPermission(
//       alert: true,
//
//       badge: true,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       debugPrint('User granted provisional permission');
//     } else {
//       debugPrint('User declined or has not accepted permission');
//     }
//
//     // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
//     // _fcm.getInitialMessage().then((RemoteMessage message) {
//     //   debugPrint('getInitialMessage data: ${message.data}');
//     //   _serialiseAndNavigate(message);
//     // });
//
//     // onMessage: When the app is open and it receives a push notification
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       await showNotification(message);
//       debugPrint("onMessage data: ${message.data}");
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         serialiseAndNavigate(message, false);
//       }
//     });
//   }
// }
//
// Future<void> serialiseAndNavigate(RemoteMessage message, bool isSplash) async {
//   String notificationData = message.data['page'];
//
//   if (message.data['id'] != null) {
//     try {
//       pageId = message.data['id'];
//     } catch (e) {
//       debugPrint(e);
//     }
//   }
//
//   if (notificationData == 'audiobook' || notificationData == 'podcast') {
//     try {
//       // await _navigationService.navigateTo(Routes.basePodcastPage,
//       //     arguments: BasePodcastPageArguments(
//       //         id: pageId!, isFromSplash: isSplash ? true : false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   } else if (notificationData == 'ebook') {
//     try {
//       // await _navigationService.navigateTo(Routes.baseEBookPage,
//       //     arguments: BaseEBookPageArguments(
//       //         id: pageId!, isFromSplash: isSplash ? true : false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   } else if (notificationData == 'episode') {
//     try {
//       // await _navigationService.navigateTo(Routes.baseEpisodePage,
//       //     arguments: BaseEpisodePageArguments(
//       //         id: pageId!, isFromSplash: isSplash ? true : false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   } else if (notificationData == 'messages') {
//     try {
//       // await _navigationService.navigateTo(Routes.notificationPage,
//       //     arguments: NotificationPageArguments(
//       //         isFromSplash: isSplash ? true : false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   }
// }
//
// showNotification(RemoteMessage message) async {
//   if (message.data['id'] != null) {
//     try {
//       pageId = message.data['id'];
//     } catch (e) {
//       debugPrint(e);
//     }
//   }
//
//   try {
//     await flutterLocalNotificationsPlugin.initialize(
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS
//         ),
//         onSelectNotification: onSelectNotification);
//
//     var android = const AndroidNotificationDetails('id', 'channel ',
//         icon: 'drawable/logo_notif',
//         autoCancel: false,
//         channelShowBadge: true,
//         enableVibration: true,
//         playSound: true,
//         priority: Priority.high,
//         importance: Importance.max);
//     var platform = new NotificationDetails(android: android);
//     await flutterLocalNotificationsPlugin.show(
//         0, message.notification!.title, message.notification!.body, platform,
//         payload: message.data['page']);
//   } catch (e) {
//     debugPrint(e);
//   }
// }
//
// Future<dynamic> onSelectNotification(payload) async {
//   debugPrint(payload);
//   if (payload == 'audiobook' || payload == 'podcast') {
//     try {
//       // await _navigationService.navigateTo(Routes.basePodcastPage,
//       //     arguments:
//       //         BasePodcastPageArguments(id: pageId!, isFromSplash: false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   } else if (payload == 'ebook') {
//     try {
//       // await _navigationService.navigateTo(Routes.baseEBookPage,
//       //     arguments: BaseEBookPageArguments(id: pageId!, isFromSplash: false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   } else if (payload == 'episode') {
//     try {
//       // await _navigationService.navigateTo(Routes.baseEpisodePage,
//       //     arguments:
//       //         BaseEpisodePageArguments(id: pageId!, isFromSplash: false));
//     } catch (e) {
//       debugPrint(e);
//     }
//   } else if (payload == 'messages') {
//     try {
//       // await _navigationService.navigateTo(Routes.notificationPage);
//     } catch (e) {
//       debugPrint(e);
//     }
//   }
// }
