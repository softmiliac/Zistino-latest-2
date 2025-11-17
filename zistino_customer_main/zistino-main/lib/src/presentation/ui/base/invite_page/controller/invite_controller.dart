import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/pro/category_model.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../../../../../domain/usecases/pro/product_usecase.dart';

class InviteController extends GetxController {

  RxBool isCopied = false.obs;


  void copyToClipboard(String representative) async{
    Clipboard.setData(
      ClipboardData(text: representative),
    );
    showTheResult(resultType: SnackbarType.message,
        showTheResultType: ShowTheResultType.snackBar,
        title: 'پیام',
        message: 'کـد معرف ذخیره شد');
    isCopied.value = true;
    await Future.delayed(const Duration(seconds: 6));
    isCopied.value = false;
  }
}
