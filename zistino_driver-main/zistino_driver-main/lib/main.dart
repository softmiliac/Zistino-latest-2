import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:recycling_machine/src/common/dependency.dart';
import 'package:recycling_machine/src/common/services/get_storage_service.dart';
import 'package:recycling_machine/src/common/utils/app_logger.dart';
import 'package:recycling_machine/src/common/utils/hive_utils/hive_utils.dart';
import 'package:recycling_machine/src/data/providers/remote/api_provider.dart';
import 'package:recycling_machine/src/domain/entities/inv/basket_item.dart';
import 'package:recycling_machine/src/presentation/ui/base/home_page/binding/binding.dart';
import 'package:recycling_machine/src/presentation/ui/base/home_page/controller/home_controller.dart';
import 'package:recycling_machine/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'src/presentation/routes/app_pages.dart';
import 'src/presentation/style/app_theme.dart';

void main() async {
  await setupHive();
  await initServices();
  DependencyCreator.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    setupChromeSystem();
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      useInheritedMediaQuery: false,
      splitScreenMode: true,
      builder: (context, widget) {
        return GetMaterialApp(
          smartManagement: SmartManagement.onlyBuilder,
          transitionDuration: const Duration(milliseconds: 400),
          defaultTransition: Transition.leftToRight,
          useInheritedMediaQuery: false,
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.initialRoute,
          getPages: AppPages.routes,
          theme: AppThemes.themeData(context),
          locale: const Locale('fa'),
          title: "زیستینو راننده",
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}

setupHive() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(BasketItemAdapter());
    await Hive.openBox<BasketItem>(Boxes.basketBox);
    // Hive.registerAdapter(LocationItemAdapter());
    // await Hive.openBox<LocationItem>(Boxes.locationBox);
    // await Hive.openBox<BasketItem>(Boxes.nextShoppingBox);
    // await Hive.openBox<BookmarkItem>(Boxes.bookmarkBox);
  } catch (_) {
    AppLogger.catchLog(_);
  }
}

Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await GetStorage.init();
  // await getPermission();
  Get.put(LocalStorageService());
  Get.put(APIProvider());
  Get.put(BasketController());
  HomeBinding().dependencies();
   initForegroundTask();

  // Get.put(ShoozService());

  // Get.put(MyMapController());

  // Get.putAsync<Isar>(() async => IsarUtil(),
  //     permanent: true);
  //
  // await IsarUtil().initDatabase();
}
void initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'notification_channel_id',
      channelName: 'Foreground Notification',
      channelDescription: 'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.HIGH,
      priority: NotificationPriority.HIGH,
      iconData: const NotificationIconData(
        resType: ResourceType.mipmap,
        resPrefix: ResourcePrefix.ic,
        name: 'launcher',
      ),
      buttons: [
        // const NotificationButton(id: 'sendButton', text: 'توقف'),
      ],
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(
      interval: 15000,
      isOnceEvent: false,
      autoRunOnBoot: false,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

@pragma('vm:entry-point')
void startCallbackNew() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

void startCallback() async{
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}
void setupChromeSystem() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
