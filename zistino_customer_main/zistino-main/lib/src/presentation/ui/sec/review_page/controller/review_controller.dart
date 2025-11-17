import 'dart:convert';
import 'package:get/get.dart';
import '../../../../../../fake_model/review_model.dart';
import '../../../../../common/exceptions/server_exception.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/sec/comment_model.dart';
import '../../../../../data/providers/fake_data.dart';
import '../../../../../domain/entities/inv/driver_delivery.dart';
import '../../../../../domain/usecases/sec/comment_usecase.dart';
import '../../../base/home_page/controller/home_controller.dart';

class ReviewController extends GetxController {
  final AddCommentUseCase _reviewUseCase = AddCommentUseCase();

  HomeController homeController = Get.find();

  RxList<ReviewModel> fakeReview = <ReviewModel>[].obs;

  RxBool isCheckedCondition = false.obs;

  RxInt selectedType = 0.obs;

  RxBool isBusyReview = false.obs;

  List<ReviewModel> fake = <ReviewModel>[];

  final RxDouble rating = 3.0.obs;

  /// Variable ///

  List<ReviewModel>? getData() {
    bool type = true;
    if (selectedType.value == 0) {
      type = true;
    } else {
      type = false;
    }
    fakeReview.value = reviewFakeData();
    fakeReview.value =
        fakeReview.where((element) => element.type == type).toList();
    return fakeReview;
  }

  void addFavoriteItem(ReviewModel model) {
    if (fake.contains(model)) {
      fake.remove(model);
    } else {
      fake.add(model);
    }
  }

  Future sendDataToServer(DriverDeliveryEntity entity) async {
    try {
      var json = jsonEncode(fake.toList());
      if (isBusyReview.value == false) {
        isBusyReview.value = true;
        update();
        CommentModel rqm = CommentModel(
            isAccepted: true,
            productId: "70a90000-324a-a6f6-7e45-08dac60d6175",
            examId: entity.orderId ?? 0,
            files: "",
            title: "",
            rate: rating.value.toInt(),
            text: json
        );
        await _reviewUseCase.execute(rqm);
        isBusyReview.value = false;
        update();
        await homeController.editRequest(entity, 9);

        showTheResult(
            title: "موفقیت",
            message: "بازخورد با موفقیت ثبت شد",
            resultType: SnackbarType.success,
            showTheResultType: ShowTheResultType.snackBar);

        rating.value = 3.0;
      } else {
        isBusyReview.value = false;
        update();
      }
    } catch (e) {
      isBusyReview.value = false;

      update();

      String title = "error".tr;

      List<String> messages = [];

      AppLogger.catchLog(e);

      if (e is Failure) {
        messages.add(e.message);
        title = e.code;
      } else if (e is List<String>) {
        messages.addAll(e);
      }

      showTheResult(
          title: title,
          message: messages.first,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);

      rethrow;
    }
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }
}
