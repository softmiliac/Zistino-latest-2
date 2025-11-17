import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geopoint/geopoint.dart';

import 'package:get/get.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/data/providers/remote/api_provider.dart';
import 'package:admin_zistino/src/presentation/ui/base/main_page/view/main_page.dart';
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
import '../../../../../data/repositories/base/driver_delivery_repository.dart';
import '../../../../../domain/entities/base/driver_delivery.dart';
import '../../../../../domain/entities/base/driver_entity.dart';
import '../../../../../domain/entities/sec/address_entity.dart';
import '../../../../../domain/entities/sec/order_entity.dart';
import '../../../../../domain/usecases/bas/driver_delivery_usecase.dart';
import '../../../../../domain/usecases/bas/locations_usecase.dart';
import '../../../../../domain/usecases/bas/trip_usecase.dart';
import '../../../../../domain/usecases/driver_usecase.dart';
import '../../../../../domain/usecases/sec/orders_usecase.dart';

class HomeController extends GetxController
    with StateMixin<List<DriverEntity>> {
  /// Variable ///
  // late List<GeoPoint> markers = [];
  var _status;
  // GeoPoint? geoPoint;
  List<DriverEntity>? homeEntity;
  AddressEntity? addressEntity;
  final currentIndex = 0.obs;
  RxBool isBusyDelete = false.obs;
  RxBool isBusyOrders = false.obs;
  RxInt statusRemove = (-1).obs;
  RxBool isBusyCreateDelivery = false.obs;
  int? tripId;
  double lat = 0;
  double long = 0;
  RxBool isBusyTrip = false.obs;
  RxBool isBusyEndTrip = false.obs;
  RxInt lastLocationID = RxInt(-1);
  int? startLocation;
  int? getLocation;
  int? endLocation;
  String? userId;
  int? valueLocation;

  // int? firstLocation ;
  /// Instances ///

  final LocalStorageService pref = Get.put(LocalStorageService());
  final FetchDriverUseCase _fetchDriverUseCase = FetchDriverUseCase();
  final DeleteDeliveryUseCase _deleteDeliveryUseCase = DeleteDeliveryUseCase();
  final CreateTripUseCase _createTripUseCase = CreateTripUseCase();
  final EndTripUseCase _endTripUseCase = EndTripUseCase();
  final OrderDetailUseCase _orderDetailUseCase = OrderDetailUseCase();
  final LocationsUseCase locationsUseCase = LocationsUseCase();

  // Box<LocationItem> locBox = Boxes.getLocationBox();

  /// Variable ///

  OrderEntity? result;
  late MapController mapController;
  final TextEditingController descriptionController = TextEditingController();
  final DriverDeliveryRepositoryImpl _useCaseCreateDelivery =
      DriverDeliveryRepositoryImpl();

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
  // Future fetchLocations(Position position) async {
  //
  //   try {
  //     LocationsRqm rqm = LocationsRqm(
  //       userId:userId ?? '',
  //       latitude: position.latitude,
  //       longitude: position.longitude,
  //       tripId: pref.tripId ?? 0,
  //       altitude: position.altitude,
  //       speed: 0,
  //       heading: '0',
  //     );
  //     var a  = await locationsUseCase.execute(rqm);
  //     if (pref.startLocationId == null) {
  //       pref.startLocId(a,"cntr");
  //     }
  //     pref.endLocId(a ,"cntr 2");
  //     debugPrint('${pref.token }token');
  //     // if (a != null) {
  //     //   pref.tripId =null;
  //     //   pref.startLocId(null) ;
  //     //   pref.endLocId(null)  ;
  //     //  // locBox.clear();
  //     // }
  //      return a;
  //     // debugPrint('$firstLocation');
  //     // debugPrint('$valueLocation');
  //     // return valueLocation;
  //   } catch (e) {
  //     AppLogger.e('$e');
  //   }
  // }

  Future fetchData() async {
    try {
      // RxInt currentIndexOrder = (index ?? currentIndex.value).obs;
      // if (isBusyOrders.isFalse) {
      //   isBusyOrders.value = true;
      //   if (currentIndexOrder.value == 0) {
      //     _status = 12;
      //   } else if (currentIndexOrder.value == 1) {
      //     _status = 4;
      //   } else if (currentIndexOrder.value == 2) {
      //     _status = 14;
      //   } else if (currentIndexOrder.value == 3) {
      //     _status = 13;
      //   } else {
      //     _status = null;
      //   }
      LazyRQM rqm = LazyRQM(
          pageNumber: 1,
          pageSize: 50,
          orderBy: [''],
          roleId: "71739647-a6e5-4456-be25-7051076cdd69");

      change(null, status: RxStatus.loading());
      homeEntity = await _fetchDriverUseCase.execute(rqm);
      if (homeEntity?.isEmpty ?? false) {
        change([], status: RxStatus.empty());
      } else {
        change(homeEntity, status: RxStatus.success());
      }
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  // Future rejectRequest(DriverDeliveryEntity entityRqm) async {
  //   try {
  //     if (Get.isSnackbarOpen == false) {
  //       DeleteDriverDeliveryRQM rqm = DeleteDriverDeliveryRQM(
  //           id: entityRqm.id,
  //           userId: entityRqm.userId,
  //           deliveryUserId: entityRqm.deliveryUserId!.isEmpty
  //               ? null
  //               : entityRqm.deliveryUserId,
  //           deliveryDate: entityRqm.createdOn,
  //           //todo set delivery date
  //           setUserId: null,
  //           addressId: entityRqm.addressId,
  //           orderId: null,
  //           examId: entityRqm.examId,
  //           requestId: entityRqm.requestId,
  //           zoneId: entityRqm.zoneId,
  //           status: statusRemove.value,
  //           description: descriptionController.text);
  //       BaseResponse result = await _deleteDeliveryUseCase.execute(rqm);
  //       if (result.succeeded == true) {
  //         showTheResult(
  //             resultType: SnackbarType.success,
  //             showTheResultType: ShowTheResultType.snackBar,
  //             title: 'موفقیت',
  //             message: 'درخواست جمع آوری شما با موفقیت لغو شد');
  //         descriptionController.clear();
  //         Get.off(MainPage());
  //         update();
  //         fetchData();
  //         return result;
  //       }
  //     }
  //   } catch (e) {
  //     AppLogger.e('$e');
  //     showTheResult(
  //         resultType: SnackbarType.error,
  //         showTheResultType: ShowTheResultType.snackBar,
  //         title: 'خطا',
  //         message: '$e');
  //   }
  // }
  //
  // Future fetchOrder(int orderID) async {
  //   try {
  //     result = await _orderDetailUseCase.execute(orderID);
  //     return result;
  //   } catch (e) {
  //     AppLogger.e('$e');
  //     rethrow;
  //   }
  // }
  //
  // Future<List<GeoPoint>> fetchMarker() async {
  //   GeoPoint a = GeoPoint(
  //       latitude: homeEntity?.data[currentIndex.value].latitude ?? 0,
  //       longitude: homeEntity?.data[currentIndex.value].longitude ?? 0);
  //   markers.add(a);
  //   return markers;
  // }
  //
  // String statusText(int status) {
  //   String statusText = '';
  //   switch (status) {
  //     case 0:
  //       statusText = 'در انتظار جمع آوری';
  //       break;
  //     case 2:
  //       statusText = 'در حال جمع آوری';
  //       break;
  //     case 4:
  //       statusText = 'در انتظار تایید کاربر';
  //       break;
  //     case 6:
  //       statusText = 'لغو شده توسط راننده';
  //       break;
  //     case 7:
  //       statusText = 'کاربر پاسخگو نبود';
  //       break;
  //     case 8:
  //       statusText = 'رد شده توسط کاربر';
  //       break;
  //     case 9:
  //       'پایان یافته';
  //       break;
  //     case 10:
  //       'پایان یافته';
  //       break;
  //     case 11:
  //       'statusText=لغو شده توسط کاربر';
  //       break;
  //     default:
  //       0;
  //   }
  //   return statusText;
  // }
  //
  // Future createDelivery(int addressId, int id, String userId) async {
  //   DriverDeliveryModel rqm = DriverDeliveryModel(
  //       userId: pref.user.id,
  //       id: id,
  //       deliveryUserId: pref.user.id,
  //       // preOrderId:0,
  //       // addressId : result?.data ?? addressId,
  //       // address: addressTxt.value + addressInfoTxt.value,
  //       // description: descriptionController.text,
  //       status: 2,
  //       // orderId: orderId,
  //       // '2022-11-15T07:52:07.716Z',
  //       deliveryDate: '2022-11-30T13:45:59.157Z',//todo
  //       addressId: addressId,
  //       // deliveryUserId:nu
  //       // 3ll ,
  //       examId: 0,
  //       requestId: 0,
  //       zoneId: 0); //todo zoneID
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
  //         message: '$e');
  //   }
  // }
  //
  // Future createTrip() async {
  //   TripRqm rqm = TripRqm(
  //     userId: pref.user.id,
  //   );
  //   try {
  //     if (isBusyTrip.value == false) {
  //       isBusyTrip.value = true;
  //       update();
  //       await _createTripUseCase.execute(rqm);
  //       isBusyTrip.value = false;
  //       update();
  //       // return tripId;
  //     }
  //   } catch (e) {
  //     isBusyTrip.value = false;
  //     update();
  //
  //     AppLogger.e('$e');
  //   }
  // }
  // Future endTrip() async {
  //   debugPrint('endTrip token:${pref.token} ');
  //   debugPrint('endTrip startLocationId ${pref.startLocationId} ');
  //   debugPrint('endTrip endLocationId ${pref.endLocationId} ');
  //
  //   TripRqm rqm = TripRqm(
  //     userId: pref.user.id,
  //     startLocationId: pref.startLocationId ?? 0,
  //     endLocationId: pref.endLocationId ?? 0,
  //   );
  //   try {
  //     if (isBusyEndTrip.value == false) {
  //       isBusyEndTrip.value = true;
  //       update();
  //       var a = await _endTripUseCase.execute(rqm);
  //       debugPrint('$a aaEndTrip');
  //       if (a != null) {
  //         pref.tripId =null;
  //         pref.startLocId(null,'end') ;
  //         pref.endLocId(null,'end')  ;
  //        // locBox.clear();
  //       }
  //       isBusyEndTrip.value = false;
  //       update();
  //       return a;
  //     }
  //   } catch (e) {
  //     isBusyEndTrip.value = false;
  //     update();
  //     AppLogger.e('$e');
  //   }
  // }
  //
  // Future getLocations() async {
  //   //   // اینجا باید شرط بنویید که اگر پرمیژن داشت این متد اجرا بشه
  //
  //   final result = await Geolocator.isLocationServiceEnabled();
  //   if (result == true) {
  //     print("Success");
  //     await getPermission();
  //   } else {
  //     print("Fail");
  //   }
  // }
  //
  // Future getPermission() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently disabled. Please, enable them to use the app.');
  //   } else if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != LocationPermission.always &&
  //         permission != LocationPermission.whileInUse) {
  //       return Future.error(
  //           'Location permissions are denied (actual value: $permission).');
  //     }
  //   }
  // }

  @override
  void onInit() {
    userId = pref.user.id;
  }
}
