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

class SignUpController extends GetxController {
  /// Variables ///
  int focusedIndex = 0;
  RxBool isAnimated = false.obs;
  bool setRepresentativeRpm = false;
  var isBusySignUp = false.obs;
  RxInt value = 0.obs;
  final signupFormKey = GlobalKey<FormState>();

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

  final MainPageController mainPageController = Get.put(MainPageController());
  final EditUserUseCase _userUseCase = EditUserUseCase();
  final SetRepresentativeUseCase _setRepresentativeUseCase =
      SetRepresentativeUseCase();
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

  /// Functions ///

  Future signUp() async {
    try {
      if (isBusySignUp.value == false) {
        isBusySignUp.value = true;
        update();
        bool rpm = await _userUseCase.execute(User(
          email: emailEditingController.text.trim(),
          firstName: firstNameEditingController.text.trim(),
          lastName: lastNameEditingController.text.trim(),
          userName: pref.user.userName.trim(),
          phoneNumber: pref.user.phoneNumber.trim(),
          companyName: value.value == 0 ? 'خانگــی' : 'صنفــی',
          imageUrl: '',
          vatNumber: '',
          sheba: 'IR${shebaNumberEditingController.text.trim()}',
          bankname: bankNameEditingController.text.trim(),
          city: '',
          country: '',
          language: '',
          birthdate:
              '${birthDate.value.toGregorian().year}-${birthDate.value.toGregorian().formatter.mm}-${birthDate.value.toGregorian().formatter.dd}T00:00:00Z',
          codeMeli: '',
          representativeBy: representativeEditingController.text.trim(),
        ));
        if(representativeEditingController.text.isNotEmpty){
          await setRepresentativeCode();
        }
        isBusySignUp.value = false;
        update();
        Get.offAll(const MainPage());
        mainPageController.selectedIndex.value = 0;
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
        isBusySignUp.value = false;
        update();
      }
    } catch (e) {
      isBusySignUp.value = false;
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

  Future setRepresentativeCode() async {
    try {
      setRepresentativeRpm = await _setRepresentativeUseCase
          .execute(representativeEditingController.value.text);
      update();
    } catch (e) {
      AppLogger.catchLog(e);
      showTheResult(
          title: "خطـا",
          message: '$e',
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

  void trimMethod() {
    firstNameEditingController.text = firstNameEditingController.text.trim();
    lastNameEditingController.text = lastNameEditingController.text.trim();
    emailEditingController.text = emailEditingController.text.trim();
    shebaNumberEditingController.text =
        shebaNumberEditingController.text.trim();
    bankNameEditingController.text = bankNameEditingController.text.trim();
    representativeEditingController.text =
        representativeEditingController.text.trim();
  }
}
