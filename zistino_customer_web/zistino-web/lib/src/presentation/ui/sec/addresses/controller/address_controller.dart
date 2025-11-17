import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/base_response.dart';
import '../../../../../data/models/sec/address_model.dart';
import '../../../../../domain/entities/sec/address_entity.dart';
import '../../../../../domain/usecases/sec/address_usecase.dart';

class AddressesController extends GetxController
    with StateMixin<List<AddressEntity>> {
  ///Map///
  // late PickerMapController controller;
  // late MapController mapController;
  double? lat;
  double? long;
  // GeoPoint? geoPoint; //todo //get from server f

  // late PickerMapController pickerController;
  ///Map///
  RxBool isDisableMapReady = false.obs;

  RxBool isBusyDelete = false.obs;
  RxList<int> valueRadio = <int>[].obs;

  final LocalStorageService pref = Get.find();

  List<AddressEntity> rpm = [];

  final FetchAllAddressUseCase _useCase;
  final DeleteAddressUseCase _deleteAddressUseCase;

  AddressesController(this._useCase, this._deleteAddressUseCase,
      this._addAddressUseCase, this._updateAddressUseCase);

  final formKey = GlobalKey<FormState>();
  RxBool isBusyAdd = false.obs;

  RxString addressTxt = ''.obs;
  RxString addressInfoTxt = ''.obs;
  RxString addressTypeTxt = ''.obs;
  RxString phoneNumberTxt = ''.obs;

  //////////////////////Text editing controllers///////////////////////

  TextEditingController addressController = TextEditingController();
  TextEditingController addressInfoController = TextEditingController();
  TextEditingController addressTitleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  //////////////////////Text editing controllers///////////////////////

  final AddAddressUseCase _addAddressUseCase;
  final UpdateAddressUseCase _updateAddressUseCase;


  @override
  void onInit() {
    fetchData(isFromLocal: true);
  }

  /// Send data to server ///

  Future clearTxtField() async {
    addressController.text = '';
    addressInfoController.text = '';
    addressTitleController.text = '';
    phoneController.text = '';
  }

  Future addAddress({required BuildContext context}) async {
    try {
      if (isBusyAdd.value == false) {
        isBusyAdd.value = true;
        update();
        AddressEntity rqm = AddressEntity(
          userId: pref.user.id,
          fullName: '${pref.user.firstName} ${pref.user.lastName}',
          address: addressController.text,
          zipCode: '',
          city: '',
          country: '',
          title: addressTitleController.text,
          description: addressInfoController.text,
          phoneNumber: phoneController.text,
          // latitude: geoPoint?.latitude,
          // longitude: geoPoint?.longitude,
        );

        BaseResponse result = await _addAddressUseCase.execute(rqm);
        isBusyAdd.value = false;
        update();

        if (result.succeeded != false) {
          fetchData(isFromLocal: false);
          Get.back(result: 'success');
          showTheResult(
              title: "موفقیت".tr,
              message: 'آدرس بـا مـوفقیت اضافه شد',
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar);
          addressController.text = '';
          addressInfoController.text = '';
          addressTitleController.text = '';
          phoneController.text = '';
        }
        return result;
      } else {
        isBusyAdd.value = false;

        update();
      }
    } catch (e) {
      // List<String> messages = [];
      isBusyAdd.value = false;
      update();
      AppLogger.catchLog(e);

      // if (e is String) {
      //   messages.add(e);
      // } else if (e is List<String>) {
      //   messages.addAll(e);
      // }

      showTheResult(
          title: "خطـا",
          message: '$e',
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }

  Future updateAddress({required BuildContext context, required int id}) async {
    try {
      if (isBusyAdd.value == false) {
        isBusyAdd.value = true;

        AddressEntity rqm = AddressEntity(
          userId: pref.user.id,
          id: id,
          fullName: '${pref.user.firstName} ${pref.user.lastName}',
          address: addressController.text,
          zipCode: '',
          city: '',
          country: '',
          title: addressTitleController.text,
          description: addressInfoController.text,
          // latitude: geoPoint?.latitude,
          // longitude: geoPoint?.longitude,
          phoneNumber: phoneController.text,
        );

        BaseResponse result = await _updateAddressUseCase.execute(rqm);

        isBusyAdd.value = false;

        if (result.succeeded != false) {
          Get.back();
          fetchData(isFromLocal: false);
          showTheResult(
              title: "موفقیت",
              message: 'آدرس با موفقیت بروز شد',
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar);
          addressController.text = '';
          addressInfoController.text = '';
          // emailController.text = '';
          addressTitleController.text = '';
          phoneController.text = '';
        }

        return result;
      } else {
        isBusyAdd.value = false;
        update();
      }
    }
    // on NoInternetException catch (e){
    //   noInternetWidget();
    //   isBusyAdd = false;
    //   update();
    // }
    catch (e) {
      List<String> messages = [];
      isBusyAdd.value = false;
      AppLogger.catchLog(e);
      update();

      if (e is String) {
        messages.add(e);
      } else if (e is List<String>) {
        messages.addAll(e);
      }

      showTheResult(
          title: "خطـا",
          message: messages.isEmpty
              ? ExceptionConstants.somethingWentWrong
              : messages.first,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }

  Future<List<AddressEntity>?> fetchData({bool isFromLocal = true}) async {
    try {
      if (isFromLocal == true) {
        if ((pref.addresses.isEmpty || pref.addresses == [])) {
          change([], status: RxStatus.empty());
          update();
        } else {
          change(pref.addresses, status: RxStatus.success());
        }
        return pref.addresses;
      } else {
        change(null, status: RxStatus.loading());
        List<AddressEntity> _rpm = await _useCase.execute();
        if ((_rpm.isEmpty || _rpm == null)) {
          change([], status: RxStatus.empty());
          update();
        } else {
          rpm = _rpm;
          rpm = rpm.reversed.toList();
          change(pref.addresses, status: RxStatus.success());
          update();
        }
      return rpm;
      }
    } catch (e) {
      List<String> messages = [];
      AppLogger.catchLog(e);
      if (e is String) {
        messages.add(e);
      } else if (e is List<String>) {
        messages.addAll(e);
      }
      change([], status: RxStatus.error('$e'));

      showTheResult(
          title: "error".tr,
          message: messages.first,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      // rethrow;
    }
  }

  Future deleteAddress(
      {required BuildContext context, required int addressID, required int index}) async {
    try {
      if (isBusyDelete.value == false) {
        isBusyDelete.value = true;
        update();

        BaseResponse result = await _deleteAddressUseCase.execute(addressID);

        isBusyDelete.value = false;

        if (result.succeeded) {
          fetchData(isFromLocal: false);
          // pref.addresses.removeAt(index);
          // update();
          Get.back();
          showTheResult(
              title: "موفقیت", //todo tr
              message: 'آدرس با موفقیت حذف شد',
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar);
        }

        return result;
      } else {
        isBusyDelete.value = false;
        update();
      }
    } catch (e) {
      isBusyDelete.value = false;

      AppLogger.catchLog(e);
      //
      //   showTheResult(
      //       context: context,
      //       title: "Error",
      //       message: messages.first,
      //       resultType: SnackbarType.error,
      //       showTheResultType: ShowTheResultType.snackBar);
      //   rethrow;
    }
  }

  void addAnonymousAddress(Map<String, dynamic> result) {
    AddressEntity address = AddressModel.fromJson(result);
    rpm.add(address);
    change(rpm, status: RxStatus.success());
  }

  // Future<void> changeLoctaion(GeoPoint geoPoint) async {
  //   await mapController.changeLocationMarker(
  //       oldLocation: geoPoint, newLocation: geoPoint);
  //   await mapController.changeLocation(geoPoint); //todo// dosen't update in ui
  //   update();
  // }

  // @override
  // void onInit() async {
  //   controller = PickerMapController(
  //     // initPosition:GeoPoint(latitude: 34,longitude: 36),
  //     initMapWithUserPosition: true,
  //   );
  //   // lat = double.parse(pref.lawyer.profile!.lat);
  //   // long = double.parse(pref.lawyer.profile!.long?? '');
  //   debugPrint('${pref.user.id}');
  //   // pickerController = PickerMapController();
  //
  //   super.onInit();
  // }
}
