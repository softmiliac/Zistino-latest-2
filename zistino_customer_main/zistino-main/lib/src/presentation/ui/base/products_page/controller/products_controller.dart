import 'package:zistino/src/presentation/ui/base/main_page/controller/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/lazy_rpm.dart';
import '../../../../../data/models/base/lazy_rqm.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/search_usecase.dart';

class ProductsController extends GetxController
    with StateMixin<List<ProductEntity>> {
  ProductsController(// this._productsUseCase,
      this._searchUseCase);

  ///**************** Instances *********************

  final LocalStorageService pref = Get.find();
  final GetProductsBySearchUseCase _searchUseCase;
  late final MainPageController mainPageController = Get.find();

  ///**************** variables *********************

  RxInt categoryIndex = 0.obs;
  List<ProductEntity>? rpm;
  RxBool isRefresh = false.obs;
  RxBool isBusyGetProducts = false.obs;
  RxBool isEmptyTextField = false.obs;
  RxString searchingText = "".obs;
  int index = 0;
  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = [];

  GlobalKey tutorial = GlobalKey();
  GlobalKey checkOut = GlobalKey();
  GlobalKey addCart = GlobalKey();

  ///**************** Functions *********************

  void changeSearchText(String query) {
    try {
      searchingText.value = query;
      update();
      debugPrint("changeSearchText_query:  ${searchingText.value}");
      debounce(searchingText, (callback) async{
        await fetchProducts();
      },time: const Duration(milliseconds: 550));
          } catch (e)
      {
        AppLogger.e('$e');
      }
    }

  Future<List?> fetchProducts({pageNumber = 1}) async {
    try {
      isBusyGetProducts.value = true;
      LazyRQM rqm = LazyRQM(
          pageNumber: pageNumber,
          pageSize: 50,
          keyword: searchingText.value,
          categoryType: 1,
          categoryId: pref.getCategory.isNotEmpty ? pref.getCategory[categoryIndex.value].id : null,
          orderBy: ['']); //todo

      debugPrint("-->>>>>> ${DateTime.now()}<<<<<<>>>>> ${rqm.keyword}");

      change(null, status: RxStatus.loading());
      LazyRPM<ProductEntity> lazyRPM = await _searchUseCase.execute(rqm);
      rpm = lazyRPM.data.cast<ProductEntity>();
      if (rpm?.isEmpty ?? false) {
        change([], status: RxStatus.empty());
      } else {
        change(rpm, status: RxStatus.success());
      }
      isBusyGetProducts.value = false;
      return rpm;
    } catch (e) {
      List<String> messages = [];
      isBusyGetProducts.value = false;
      AppLogger.catchLog(e);
      change(null, status: RxStatus.error('$e'));
      if (e is String) {
        messages.add(e);
      } else if (e is List<String>) {
        messages.addAll(e);
      }
      showTheResult(
          title: "Error",
          message: messages.first,
          resultType: SnackbarType.error,
          showTheResultType: ShowTheResultType.snackBar);
      rethrow;
    }
  }

}
