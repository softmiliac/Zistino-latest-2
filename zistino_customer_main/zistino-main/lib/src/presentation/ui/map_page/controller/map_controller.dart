import 'package:zistino/src/common/services/get_storage_service.dart';
import 'package:zistino/src/common/utils/app_logger.dart';
import 'package:zistino/src/presentation/ui/inv/residue_page/view/select_residue_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import '../../../../common/utils/show_result_action.dart';
import '../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../data/models/base/base_response.dart';
import '../../../../data/repositories/sec/address_repository.dart';
import '../../../../domain/entities/sec/address_entity.dart';
import '../../../../domain/usecases/sec/address_usecase.dart';
import '../../base/main_page/controller/main_controller.dart';
import 'package:zistino/src/common/constants/exception_constants.dart';

class MyMapController extends GetxController {
  MyMapController(this._addAddressUseCase);

  /// Variables ///

  GeoPoint? geoPoint; //todo //get from server f
  double? lat;
  double? long;
  RxBool isBusyCreateDelivery = false.obs;

  /// Variables Addresses ///

  BaseResponse? result;
  RxBool isBusyAdd = false.obs;
  RxString addressTxt = ''.obs;
  RxString addressInfoTxt = ''.obs;
  RxString addressTypeTxt = ''.obs;
  RxString phoneNumberTxt = ''.obs;
  int? idZone;
  String? txtZone;
  TextEditingController addressController = TextEditingController();
  TextEditingController addressInfoController = TextEditingController();
  TextEditingController addressTitleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  /// Instances ///

  late MapController mapController;
  late PickerMapController controller;
  final LocalStorageService pref = Get.find();
  final AddAddressUseCase _addAddressUseCase;
  final MainPageController mainPageController = Get.find();
  final AddressRepositoryImpl _addressRepo = AddressRepositoryImpl();

  /// Methods ///
  // @override
  // void onInit() async {
  //   createDays();
  //
  //   createTimeSelection(true);
  //   super.onInit();
  //
  //   selectedDay.listen((dayBox) {
  //     createTimeSelection(dayBox.date == DateTime.now());
  //     // debugPrint('${hours[index].active} asasq');
  //   });
  // }
  Future clearTxtField() async {
    addressController.text = '';
    addressInfoController.text = '';
    addressTitleController.text = '';
    phoneController.text = '';
    descriptionController.text = '';
    txtZone = pref.zones[0].zone;
    idZone = pref.zones[0].id;
  }

  Future<void> changeLocation(GeoPoint geoPoint) async {
    await mapController.changeLocationMarker(
        oldLocation: geoPoint, newLocation: geoPoint);
    await mapController.changeLocation(geoPoint); //todo// dosen't update in ui
    update();
  }

  Future addAddress() async {
    try {
      if (isBusyAdd.value == false) {
        isBusyAdd.value = true;
        update();
        AddressEntity rqm = AddressEntity(
            userId: pref.user.id,
            fullName: '${pref.user.firstName} ${pref.user.lastName}',
            address: addressController.text.trim(),
            title: addressTitleController.text.trim(),
            description: addressInfoController.text.trim(),
            phoneNumber: phoneController.text,
            latitude: geoPoint?.latitude,
            longitude: geoPoint?.longitude,
            country: 'Iran',
            zipCode: '',
            city: '',
            email: idZone.toString());

        result = await _addAddressUseCase.execute(rqm);
        isBusyAdd.value = false;
        update();

        if (result?.succeeded != false) {
          await _addressRepo.fetchAll();

          Get.to(SelectResiduePage(address: AddressEntity(id: result?.data)));
          showTheResult(
              title: "موفقیت",
              message: 'آدرس بـا مـوفقیت اضافه شد',
              resultType: SnackbarType.success,
              showTheResultType: ShowTheResultType.snackBar);
          addressController.text = '';
          addressInfoController.text = '';
          addressTitleController.text = '';
          phoneController.text = '';
          // Get.closeCurrentSnackbar();
          // Navigator.of(Get.context!,rootNavigator: false).pop();
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
          message: ExceptionConstants.serverError,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }

// List<DayBox> createDates() {
//   try {
//     Jalali nowJalali = Jalali.now();
//     for (int i = 0; i <= 10; i++) {
//       Jalali dateTime = nowJalali.addDays(i);
//
//     }
//   } catch (e) {
//     debugPrint("$e");
//   }
//   return days.value;
// }

// String timeFormat() {
//   DateTime timeOrder = DateTime.parse(entity.createdOn);
//   String time = '${timeOrder.hour} : ${timeOrder.minute}';
//   return time;
// }

}
