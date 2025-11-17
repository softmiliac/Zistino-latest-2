import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:recycling_machine/src/data/models/base/lazy_rqm.dart';
import 'package:recycling_machine/src/data/providers/remote/api_provider.dart';
import 'package:recycling_machine/src/presentation/style/colors.dart';
import 'package:recycling_machine/src/presentation/ui/base/main_page/view/main_page.dart';
import '../../../../../../main.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../data/models/base/driver_delivery_model.dart';
import '../../../../../data/models/base/lazy_rpm.dart';
import '../../../../../data/models/base/location_rqm.dart';
import '../../../../../data/models/base/trip_rqm.dart';
import '../../../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../../../domain/entities/base/driver_delivery.dart';
import '../../../../../domain/entities/sec/address_entity.dart';
import '../../../../../domain/entities/sec/order_entity.dart';
import '../../../../../domain/usecases/bas/driver_delivery_usecase.dart';
import '../../../../../domain/usecases/bas/locations_usecase.dart';
import '../../../../../domain/usecases/bas/trip_usecase.dart';
import '../../../../../domain/usecases/sec/orders_usecase.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController
    with StateMixin<LazyRPM<DriverDeliveryEntity>> {

  /// Variable ///
  late List<GeoPoint> markers = [];
  var _status;
  GeoPoint? geoPoint;
  LazyRPM<DriverDeliveryModel>? homeEntity;
  AddressEntity? addressEntity;
  final currentIndex = 0.obs;
  RxBool isBusyDelete = false.obs;
  RxBool isBusyGetOrder = false.obs;
  RxBool isBusyOrders = false.obs;
  RxInt statusRemove = (-1).obs;
  RxBool isBusyCreateDelivery = false.obs;
  int orderID = 0;
  OrderEntity? orderResult;
  int? tripId;
  double lat = 0;
  double long = 0;
  RxBool isBusyTrip = false.obs;
  RxBool isBusyEndTrip = false.obs;
  RxInt endLocationID = RxInt(-1);
  RxInt startLocationID = RxInt(-1);
  String? userId;
  ReceivePort? receivePort;

  /// Instances ///

  final LocalStorageService pref = Get.find();
  final FetchDriverDeliveryUseCase _useCase = FetchDriverDeliveryUseCase();
  final DeleteDeliveryUseCase _deleteDeliveryUseCase = DeleteDeliveryUseCase();
  final CreateTripUseCase _createTripUseCase = CreateTripUseCase();
  final EndTripUseCase _endTripUseCase = EndTripUseCase();
  final OrderDetailUseCase _orderDetailUseCase = OrderDetailUseCase();
  final LocationsUseCase locationsUseCase = LocationsUseCase();
  final EditDeliveryUseCase _editDeliveryUseCase = EditDeliveryUseCase();
  late MapController mapController;
  final TextEditingController descriptionController = TextEditingController();

  /// Functions ///

/*
  Future fetchLocation(LocationItem locItem) async {
    try {
      await locBox.put(locItem.startLocation, locItem);
    } catch (e) {
      AppLogger.catchLog(e);
    }
  }
*/
  Future fetchLocations(Position position) async {
    try {
      LocationsRqm rqm = LocationsRqm(
        userId: pref.user.id,
        latitude: position.latitude,
        longitude: position.longitude,
        tripId: pref.tripId ?? 0,
        altitude: position.altitude,
        speed: 0,
        heading: '0',
      );
      var a = await locationsUseCase.execute(rqm);
      return a;
      // debugPrint('$firstLocation');
      // debugPrint('$valueLocation');
      // return valueLocation;
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  Future fetchData({int? index}) async {
    try {
      RxInt currentIndexOrder = (index ?? currentIndex.value).obs;
      if (isBusyOrders.isFalse) {
        isBusyOrders.value = true;
        if (currentIndexOrder.value == 0) {
          _status = 12;
        } else if (currentIndexOrder.value == 1) {
          _status = 4;
        } else if (currentIndexOrder.value == 2) {
          _status = 14;
        } else if (currentIndexOrder.value == 3) {
          _status = 13;
        } else {
          _status = null;
        }
        LazyRQM rqm = LazyRQM(
            pageNumber: 1,
            pageSize: 50,
            keyword: '',
            orderBy: [''],
            status: _status);

        change(null, status: RxStatus.loading());
        homeEntity = await _useCase.execute(rqm);
        if (homeEntity?.data.isEmpty ?? false) {
          change(LazyRPM(), status: RxStatus.empty());
        } else {
          change(homeEntity, status: RxStatus.success());
        }
        isBusyOrders.value = false;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyOrders.value = false;
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future rejectRequest(DriverDeliveryEntity entityRqm) async {
    try {
      if (Get.isSnackbarOpen == false) {
        DeleteDriverDeliveryRQM rqm = DeleteDriverDeliveryRQM(
            id: entityRqm.id,
            userId: entityRqm.userId,
            deliveryUserId: entityRqm.deliveryUserId!.isEmpty
                ? null
                : entityRqm.deliveryUserId,
            deliveryDate: entityRqm.createdOn,
            //todo set delivery date
            setUserId: null,
            addressId: entityRqm.addressId,
            orderId: null,
            examId: entityRqm.examId,
            requestId: entityRqm.requestId,
            zoneId: entityRqm.zoneId,
            status: statusRemove.value,
            description: descriptionController.text);
        BaseResponse result = await _deleteDeliveryUseCase.execute(rqm);
        if (result.succeeded == true) {
          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست جمع آوری شما با موفقیت لغو شد');
          descriptionController.clear();
          Get.back();
          Get.off(MainPage());
          update();
          fetchData();
          return result;
        }
      }
    } catch (e) {
      AppLogger.e('$e');
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message:ExceptionConstants.serverError);
    }
  }

  Future<List<GeoPoint>> fetchMarker() async {
    GeoPoint a = GeoPoint(
        latitude: homeEntity?.data[currentIndex.value].latitude ?? 0,
        longitude: homeEntity?.data[currentIndex.value].longitude ?? 0);
    markers.add(a);
    return markers;
  }

  String statusText(int status) {
    String statusText = '';
    switch (status) {
      case 0:
        statusText = 'در انتظار جمع آوری';
        break;
      case 2:
        statusText = 'در حال جمع آوری';
        break;
      case 4:
        statusText = 'در انتظار تایید کاربر';
        break;
      case 6:
        statusText = 'لغو شده توسط راننده';
        break;
      case 7:
        statusText = 'کاربر پاسخگو نبود';
        break;
      case 8:
        statusText = 'رد شده توسط کاربر';
        break;
      case 9:
        'پایان یافته';
        break;
      case 10:
        'پایان یافته';
        break;
      case 11:
        'statusText=لغو شده توسط کاربر';
        break;
      default:
        0;
    }
    return statusText;
  }

  // Future createDelivery(DriverDeliveryEntity entity) async {
  //   DriverDeliveryModel rqm = DriverDeliveryModel(
  //       userId: pref.user.id,
  //       id: entity.id,
  //       deliveryUserId: pref.user.id,
  //       preOrderId: entity.preOrderId,
  //       status: 2,
  //       // orderId: orderId,
  //       deliveryDate: entity.deliveryDate,
  //       addressId: entity.addressId,
  //       examId: 0,
  //       requestId: entity.requestId,
  //       zoneId: 0);
  //   try {
  //     if (isBusyCreateDelivery.value == false) {
  //       isBusyCreateDelivery.value = true;
  //       update();
  //       bool response = await _useCaseCreateDelivery.createDeliveryRequest(rqm);
  //       isBusyCreateDelivery.value = false;
  //       update();
  //       if (response == true) {
  //         // selectedCat.clear();
  //         showTheResult(
  //             resultType: SnackbarType.success,
  //             showTheResultType: ShowTheResultType.snackBar,
  //             title: 'موفقیت',
  //             message: 'درخواست شما با موفقیت ثبت شد');
  //         fetchData();
  //         update();
  //       }
  //       return response;
  //     }
  //   } catch (e) {
  //     AppLogger.e('$e');
  //     isBusyCreateDelivery.value = false;
  //     update();
  //     showTheResult(
  //         resultType: SnackbarType.error,
  //         showTheResultType: ShowTheResultType.snackBar,
  //         title: 'خطا',
  //         message:ExceptionConstants.serverError);
  //   }
  // }

  Future editDelivery(DriverDeliveryModel model) async {
    DriverDeliveryModel rqm = DriverDeliveryModel(
        userId: model.userId,
        id: model.id,
        vatNumber: model.vatNumber,
        deliveryUserId: pref.user.id,
        // preOrderId:0,
        // addressId : result?.data ?? addressId,
        // address: addressTxt.value + addressInfoTxt.value,
        // description: descriptionController.text,
        status: 4,
        orderId: model.orderId,
        // '2022-11-15T07:52:07.716Z',
        deliveryDate: '${DateFormat('yyyy-MM-dd').format(DateTime.now())}T${DateFormat('HH:mm:ss').format(DateTime.now())}.000Z',
        addressId: model.addressId
        //todo for mohandes
        ,
        // deliveryUserId:nu
        // 3ll ,
        examId: 0,
        requestId: 0,
        phoneNumber: model.phoneNumber,
        latitude: model.latitude,
        longitude: model.longitude,
        zoneId: model.zoneId);
    try {
      if (isBusyCreateDelivery.value == false) {
        isBusyCreateDelivery.value = true;
        update();
        BaseResponse response = await _editDeliveryUseCase.execute(rqm);
        isBusyCreateDelivery.value = false;
        update();
        if (response.succeeded == true) {
          // selectedCat.clear();
          showTheResult(
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar,
              title: 'موفقیت',
              message: 'درخواست شما با موفقیت ثبت شد');
          fetchData();
          update();
        }
        return response;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyCreateDelivery.value = false;
      update();
      showTheResult(
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar,
          title: 'خطا',
          message:ExceptionConstants.serverError);
    }
  }

  Future createTrip() async {
    TripRqm rqm = TripRqm(
      userId: pref.user.id,
    );
    try {
      if (isBusyTrip.value == false) {
        isBusyTrip.value = true;
        update();
        await _createTripUseCase.execute(rqm);
        isBusyTrip.value = false;
        update();
        // return tripId;
      }
    } catch (e) {
      isBusyTrip.value = false;
      update();

      AppLogger.e('$e');
    }
  }
  Future endTrip() async {
    try {
      if (isBusyEndTrip.value == false) {
        var tripRqm = TripRqm(
          userId: pref.user.id,
          startLocationId: 0,
          endLocationId: -100,
        );
        TripRqm rqm = tripRqm;
        isBusyEndTrip.value = true;
        update();
        var a = await _endTripUseCase.execute(rqm);
        debugPrint('$a aValue');
        if (a!=null) {
          pref.tripId = null;
          isBusyEndTrip.value = false;
          stopForegroundTask();
          update();
        }
        return a;
      }
    } catch (e) {
      isBusyEndTrip.value = false;
      update();
      AppLogger.e('$e');
    }
  }
  Future getLocations() async {
    //   // اینجا باید شرط بنویید که اگر پرمیژن داشت این متد اجرا بشه

    final result = await Geolocator.isLocationServiceEnabled();
    if (result == true) {
      debugPrint("Success");
      await getPermission();
    } else {
      debugPrint("Fail");
    }
  }
  Future fetchOrder() async {
    try {
      if (isBusyGetOrder.value == false) {
        isBusyGetOrder.value = true;
        orderResult = await _orderDetailUseCase.execute(orderID);
        isBusyGetOrder.value = false;
      }
    } catch (e) {
      AppLogger.e('$e');
      isBusyGetOrder.value = false;
      rethrow;
    }
  }
  Future getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently disabled. Please, enable them to use the app.');
    } else if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
  }

/// Foreground Service Config///
  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
        'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix:ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: AppColors.primaryColor,
        ),
        buttons: [
          // const NotificationButton(id: 'sendButton', text: 'Send'),
          // const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 15000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }
  Future<bool> startForegroundTask() async {
    // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
    // onNotificationPressed function to be called.
    //
    // When the notification is pressed while permission is denied,
    // the onNotificationPressed function is not called and the app opens.
    //
    // If you do not use the onNotificationPressed or launchApp function,
    // you do not need to write this code.
    if (!await FlutterForegroundTask.canDrawOverlays) {
      final isGranted =
      await FlutterForegroundTask.openSystemAlertWindowSettings();
      if (!isGranted) {
        debugPrint('SYSTEM_ALERT_WINDOW permission denied!');
        return false;
      }
    }

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort ;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      debugPrint('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'در حال جمع آوری',
        notificationText: 'شما در حال اجرای کار هستید',
        callback: startCallbackNew,
      );
    }
  }
  Future<bool> stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }
  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    receivePort = newReceivePort;
    receivePort?.listen((message) {
      if (message is int) {
        debugPrint('eventCount: $message');
      } else if (message is String) {
        if (message == 'onNotificationPressed') {
          Navigator.of(Get.context!).pushNamed('/resume-route');
        }
      } else if (message is DateTime) {
        debugPrint('timestamp: ${message.toString()}');
      }
    });

    return receivePort != null;
  }
  void _closeReceivePort() {
    receivePort?.close();
    receivePort = null;
  }
  T? _ambiguate<T>(T? value) => value;
  @override
  void onInit() {
    super.onInit();
    _initForegroundTask();
    _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });

  }
}

/// ForeGround Service Class ///
class MyTaskHandler extends TaskHandler {
  final LocalStorageService pref = Get.put(LocalStorageService());
  final HomeController homeController = Get.put(HomeController());
  final LocationsUseCase locationsUseCase = LocationsUseCase();
  final APIProvider provider = Get.put(APIProvider());

  void onStartForGround() async {
    Future fetchLocations(Position position) async {
      try {
        LocationsRqm rqm = LocationsRqm(
          userId: homeController.pref.user.id,
          latitude: position.latitude,
          longitude: position.longitude,
          tripId: homeController.pref.tripId ?? 0,
          altitude: position.altitude,
          speed: position.speed.toInt(),
          heading: position.heading.toString(),
        );
        var a = await locationsUseCase.execute(rqm);
        return a;
      } catch (e) {
        AppLogger.e('$e');
      }
    }

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      fetchLocations(position);
      debugPrint('${position.latitude}');
      debugPrint('${position.longitude}');
    }).catchError((e) {
      debugPrint(e);
    });

    final deviceInfo = DeviceInfoPlugin();
    String? device;
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      device = androidInfo.model;
    }

    if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.model;
    }
  }
  @override
  void onButtonPressed(String id) async {
    if (id == "sendButton") {
      // await homeController.endTrip().whenComplete(() {
      //   FlutterForegroundTask.stopService();
      // });
    }
    print('onButtonPressed >> $id');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    homeController.pref.setStartLocationId(homeController.pref.startLocationId!);
    debugPrint("on destroy ${homeController.pref.startLocationId}");
    debugPrint("on destroy End ${homeController.pref.endLocationId}");
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    onStartForGround();
    // debugPrint("onEvent ossered");
  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    onStartForGround();
  }
}
