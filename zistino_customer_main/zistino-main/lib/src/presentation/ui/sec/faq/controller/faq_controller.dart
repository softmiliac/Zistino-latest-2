import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/exceptions/no_internet_exception.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../domain/entities/sec/faq.dart';
import '../../../../../domain/usecases/sec/faq_usecase.dart';


class FAQController extends GetxController with StateMixin<List<FaqEntity>> {
  FAQController(this._fetchAllFaqUseCase);

  /// Variable ///

  TextEditingController searchController = TextEditingController();


  final FetchAllFaqUseCase _fetchAllFaqUseCase;
  List<FaqEntity>? rpm;

  /// Send data to server ///

  Future fetchFaq(
      {
        required String searchText,
      required BuildContext context}) async {
    change(null, status: RxStatus.loading());

    try {
      rpm = await _fetchAllFaqUseCase.execute(searchText);

      if (rpm == [] || rpm!.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(rpm, status: RxStatus.success());
      }

    }  on NoInternetException catch (e){
      // noInternetWidget();
      change([], status: RxStatus.error(e.message));

      update();
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  /// Dispose ///

  @override
  void dispose() {

    super.dispose();
  }
}
