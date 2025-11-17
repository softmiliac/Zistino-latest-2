import 'dart:ui';

import 'package:admin_zistino/src/common/services/get_storage_service.dart';
import 'package:admin_zistino/src/data/providers/remote/api_provider.dart';
import 'package:admin_zistino/src/presentation/routes/app_pages.dart';
import 'package:admin_zistino/src/presentation/style/app_theme.dart';
import 'package:admin_zistino/src/presentation/ui/base/map_page/view/tracking_vehicle_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


void main() async {
  // await setupHive();
  await initServices();
  // DependencyCreator.init();

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
          // home: TrackingVehiclePage(),
          initialRoute: AppPages.initialRoute,
          getPages: AppPages.routes,
          theme: AppThemes.themeData(context),
          locale: const Locale('fa'),
          title: "زیستینو ادمین",
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

void setupChromeSystem() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  await GetStorage.init();
  // await getPermission();
  Get.put(LocalStorageService());
  Get.put(APIProvider());
  // Get.put(BasketController());
  // HomeBinding().dependencies();
  // initForegroundTask();

  // Get.put(ShoozService());

  // Get.put(MyMapController());

  // Get.putAsync<Isar>(() async => IsarUtil(),
  //     permanent: true);
  //
  // await IsarUtil().initDatabase();
}
/*
class MyApp1 extends StatefulWidget {
  MyApp1({Key? key}) : super(key: key);

  @override
  State<MyApp1> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  String signalRStatus = "disconnected";
  final LocalStorageService pref = Get.find();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    signalR = SignalR(
      "https://api.zistino.com/",
      "notifications",
      hubMethods: ["Position"],
      headers: pref.headers,
      statusChangeCallback: _onStatusChange,
      hubCallback: _onNewMessage,
    );
  }

*//*
  Map<String, String> get headers {
    Map<String, String> headers = {
      'apiLevel': "1",
      //todo amin alizadeh
      'appVersion': "1.0.0",
      //todo amin alizadeh
      'platform': "1.0.0",
      //todo amin alizadeh
      'tenant':'root', //todo fix from server
      // 'tenant': tenant == defaultTenantValue ? defaultTenantValue : tenant,
      'Accept-Language':'en',
      'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImFhY2U0NzBmLWY4MzQtNGRlYi1hNmNmLThjMmQ4MjI3MGZmYyIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6ImFkbWluQHJvb3QuY29tIiwiZnVsbE5hbWUiOiJyb290IEFkbWluIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6InJvb3QiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zdXJuYW1lIjoiQWRtaW4iLCJpcEFkZHJlc3MiOiIxMzUuMTgxLjQ3LjEiLCJ0ZW5hbnQiOiJyb290Iiwicm9sZXMiOiJbXCJBZG1pblwiXSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL21vYmlsZXBob25lIjoiIiwiZXhwIjoxNjc3MTYxNzgwfQ.3xIrBl7n8paJ6TzwOv7Okg5KDI0zS9gfV4_kxCA8Pg8'
      // token == defaultTokenValue ? defaultTokenValue : 'Bearer $token'
      // 'Bearer $token'
    };

    return headers;
  }
*//*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SignalR Plugin Example App"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Connection Status: $signalRStatus\n",
                  style: Theme.of(context).textTheme.headline6),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                    onPressed: _buttonTapped,
                    child: const Text("Invoke Method")),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.cast_connected),
          onPressed: () async {
            final isConnected = await signalR.isConnected();
            if (!isConnected) {
              final connId = await signalR.connect();
              print("Connection ID: $connId");
            } else {
              signalR.stop();
            }
          },
        ),
      ),
    );
  }

  void _onStatusChange(ConnectionStatus? status) {
    if (mounted) {
      setState(() {
        signalRStatus = status?.name ?? ConnectionStatus.disconnected.name;
      });
    }
  }

  void _onNewMessage(String methodName, String message) {
    print("MethodName = $methodName, Message = $message");
  }

  void _buttonTapped() async {
    try {
      final result = await signalR.invokeMethod("Position", arguments: []);
      print(result);
    } catch (e) {
      print(e);
    }
  }
}*/

