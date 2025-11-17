import 'package:admin_dashboard/src/common/dependency.dart';
import 'package:admin_dashboard/src/common/services/get_storage_service.dart';
import 'package:admin_dashboard/src/common/utils/app_logger.dart';
import 'package:admin_dashboard/src/common/utils/hive_utils/hive_utils.dart';
import 'package:admin_dashboard/src/data/providers/remote/api_provider.dart';
import 'package:admin_dashboard/src/domain/entities/inv/basket_item.dart';
import 'package:admin_dashboard/src/presentation/ui/base/scroll_behavior/scroll_behavior.dart';
import 'package:admin_dashboard/src/presentation/ui/inv/basket_controller/basket_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'src/presentation/routes/app_pages.dart';
import 'src/presentation/style/app_theme.dart';

void main() async{
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

    return GetMaterialApp(
      scrollBehavior: WebDragScrollBehavior(),
      smartManagement: SmartManagement.onlyBuilder,
      transitionDuration: const Duration(milliseconds: 400),
      defaultTransition: Transition.leftToRight,
      useInheritedMediaQuery: false,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
      theme: AppThemes.themeData(context),
      locale: const Locale('fa'),
      title: "زیستینو",
      // builder: (context, widget) {
      //   return MediaQuery(
      //
      //     data: MediaQuery.of(context).copyWith(
      //       textScaleFactor: 1.0,
      //     ),
      //     child: widget!,
      //   );
      // },
    );


  }
}
setupHive() async {
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(BasketItemAdapter());
    // Hive.registerAdapter(BookmarkItemAdapter());
    await Hive.openBox<BasketItem>(Boxes.basketBox);
    // await Hive.openBox<BasketItem>(Boxes.nextShoppingBox);
    // await Hive.openBox<BookmarkItem>(Boxes.bookmarkBox);
  } catch (_) {
    AppLogger.catchLog(_);
  }
}
Future initServices() async {

    WidgetsFlutterBinding.ensureInitialized();
    await GetStorage.init();
    Get.put(LocalStorageService());
    Get.put(APIProvider());
    Get.put(BasketController());
    // Get.put(MyMapController());


    // Get.putAsync<Isar>(() async => IsarUtil(),
    //     permanent: true);
    //
    // await IsarUtil().initDatabase();

}

void setupChromeSystem() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
