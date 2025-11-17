import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../domain/entities/sec/user.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../../../base/main_page/controller/main_controller.dart';
import '../../../base/main_page/view/main_page.dart';

class EditProfileController extends GetxController {
  /// Variables ///
  int focusedIndex = 0;
  RxBool isAnimated = false.obs;
  var isBusyEdit = false.obs;
  RxInt value = 0.obs;



  final editProfileFormKey = GlobalKey<FormState>();

  /// Instances ///
  final TextEditingController firstNameEditingController =
      TextEditingController();
  final TextEditingController lastNameEditingController =
      TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController shebaNumberEditingController =
      TextEditingController();
  final TextEditingController bankNameEditingController =
      TextEditingController();
  final TextEditingController representativeEditingController =
      TextEditingController();
  final TextEditingController birthDateEditingController =
      TextEditingController();
  final LocalStorageService pref = Get.find<LocalStorageService>();
  final EditUserUseCase _editUserUseCase = EditUserUseCase();

  MainPageController mainPageController = Get.put(MainPageController());

  Rx<Jalali> birthDate = Jalali.now().obs;


  @override
  void dispose() {
    super.dispose();
    firstNameEditingController.dispose();
    lastNameEditingController.dispose();
    emailEditingController.dispose();
    shebaNumberEditingController.dispose();
    bankNameEditingController.dispose();
    representativeEditingController.dispose();
    birthDateEditingController.dispose();
  }


  /// Methods ///

  Future editProfile({bool isSignUp = false}) async {
    try {
      if (isBusyEdit.value == false) {
        isBusyEdit.value = true;
        update();

        bool rpm = await _editUserUseCase.execute(User(
          id: pref.user.id,
          email: emailEditingController.text.isNotEmpty
              ? emailEditingController.text
              : pref.user.email,
          firstName: firstNameEditingController.text.trim(),
          lastName: lastNameEditingController.text.trim(),
          userName: pref.user.userName.trim(),
          phoneNumber: pref.user.phoneNumber,
          companyName: value.value == 0 ? 'خانگــی' : 'صنفــی',
          imageUrl: pref.user.imageUrl,
          vatNumber: pref.user.vatNumber,
          sheba: 'IR${shebaNumberEditingController.text}',
          bankname: bankNameEditingController.text.trim(),
          city: '',
          country: '',
          language: '',
          birthdate:
              '${birthDate.value.toGregorian().year}-${birthDate.value.toGregorian().formatter.mm}-${birthDate.value.toGregorian().formatter.dd}T00:00:00',
          // 2022-11-13T09:05:35.484Z
          codeMeli: '',
          representativeBy: representativeEditingController.text,
        ));
        isBusyEdit.value = false;
        update();
        isSignUp
            ? Get.offAll(const MainPage())
            : Get.back(result: 'result');
        isSignUp ? mainPageController.selectedIndex.value = 0 : mainPageController.selectedIndex.value = 3;

        // Get.back(result: 'Success');
        update();
        showTheResult(
            title: "موفقیت",
            message: 'اطلاعات پروفایل با موفقیت ثبت شد',
            resultType: SnackbarType.success,
            showTheResultType: ShowTheResultType.snackBar);
        // if(rpm){
        // }
        return rpm;
      } else {
        isBusyEdit.value = false;
        update();
      }
    } catch (e) {
      isBusyEdit.value = false;
      AppLogger.catchLog(e);
      showTheResult(
          title: "خطـا",
          message: ExceptionConstants.serverError,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      update();
      AppLogger.e('$e');
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  void showDatePickerReceivedDate(BuildContext context) async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1300, 8),
      lastDate: Jalali.now(),
      textDirection: TextDirection.rtl,
      initialDatePickerMode: PDatePickerMode.day,
    );
    if (picked != null) {
      birthDate.value = picked;
      birthDateEditingController.text =
          "${birthDate.value.formatter.d} ${birthDate.value.formatter.mN} ${birthDate.value.formatter.yyyy}";
    }
  }

  void onItemFocus(int index) {
    focusedIndex = index;
    update();
  }
}
