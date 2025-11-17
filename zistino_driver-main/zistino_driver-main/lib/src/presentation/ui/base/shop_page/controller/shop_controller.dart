import 'package:recycling_machine/src/presentation/ui/base/main_page/controller/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../../common/services/get_storage_service.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../common/utils/show_result_action.dart';
import '../../../../../data/enums/bas/theme/show_result_type.dart';
import '../../../../../data/enums/bas/theme/snackbar_type.dart';
import '../../../../../data/models/base/lazy_rpm.dart';
import '../../../../../data/models/base/lazy_rqm.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/search_usecase.dart';

class ShopController extends GetxController
    with StateMixin<LazyRPM<ProductEntity>> {
  ShopController(this._searchUseCase);

  ///**************** Instances *********************

  final TextEditingController textEditingController = TextEditingController();
  final LocalStorageService _pref = Get.find();
  final SearchUseCase _searchUseCase;
  late final MainPageController mainPageController = Get.find();


  ///**************** variables *********************

  LazyRPM<ProductEntity>? rpm;
  RxInt tag = 1.obs;
  RxBool isRefresh = false.obs;
  RxBool isEmptyTextField = false.obs;
  RxString searchingText = "".obs;
  RxList<String> recentSearch = <String>[].obs;
  RxList<String> popSearch = <String>[].obs;
  List<int> countSearch = [];
  int index = 0;

  ///**************** Functions *********************

  setRefresh(bool refresh) {
    isRefresh.value = refresh;
  }

  void clearSearch() async {
    searchingText.value = "";
    // query.value = '';
    // await fetchPage(0);
    // update();
    // }
  }

  stopLoading() {
    change(LazyRPM(), status: RxStatus.empty());
  }


  Future<LazyRPM<ProductEntity>?> fetchProductsData(
      {pageNumber = 1, int? categoryID}) async {
    try {
      LazyRQM rqm = LazyRQM(
          pageNumber: pageNumber,
          pageSize: 50,
          keyword: '',
          orderBy: ['']); //todo

      debugPrint("-->>>>>> ${DateTime.now()}<<<<<<>>>>> ${rqm.keyword}");

      change(null, status: RxStatus.loading());
      rpm = await _searchUseCase.execute(rqm);
      if (rpm?.data.isEmpty ?? false) {
        change(LazyRPM(), status: RxStatus.empty());
      } else {
        change(rpm, status: RxStatus.success());
      }
      return rpm;
    } catch (e) {
      List<String> messages = [];
      AppLogger.catchLog(e);
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



  Future<LazyRPM<ProductEntity>?> fetchProductsDataWithSearch(
      {pageNumber = 1, int? categoryID}) async {
    try {
      LazyRQM rqm = LazyRQM(
          pageNumber: pageNumber,
          pageSize: 50,
          keyword:mainPageController.searchTextController.text,
          orderBy: ['']); //todo

      debugPrint("-->>>>>> ${DateTime.now()}<<<<<<>>>>> ${rqm.keyword}");

      change(null, status: RxStatus.loading());
      rpm = await _searchUseCase.execute(rqm);
      if (rpm?.data.isEmpty ?? false) {
        change(LazyRPM(), status: RxStatus.empty());
      } else {
        change(rpm, status: RxStatus.success());
      }
      return rpm;
    } catch (e) {
      List<String> messages = [];
      AppLogger.catchLog(e);
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

  // void changeIndex(int _index) {
  //   _indexFilter = _index;
  //   update();
  //   pagingController.refresh();
  //   // fetchPage(0);
  //   print("changeSearchText_query:  $_searchText");
  // }
  void searchRecent(int index) async {
    textEditingController.text = recentSearch[index];
    searchingText.value = recentSearch[index];
    fetchProductsData();

    // fetchProductsData();
    // changeSearchText(textEditingController.text);
  }

  void changeSearchText(String query) async {
    try {
      searchingText.value = query;
      debugPrint("changeSearchText_query:  ${searchingText.value}");
      debounce(searchingText, (_) => fetchProductsData(),
          time: const Duration(milliseconds: 700));
    } catch (e) {
      AppLogger.e('$e');
    }
  }



  addSearchItem(ProductEntity product) {
    // recentSearch.remove(product.name);
    // popularSearch.remove(product.name);

    recentSearch.remove(product.name);

    if (product.name.isNotEmpty) {
      recentSearch.add(product.name);
      update();
    }
    // if (countSearch[index]>2) {
    //   popularSearch.add(product.name);
    //
    // }
    if (recentSearch.length > 10) {
      removeSearchItem(0);
      removePopularSearchItem(0);
    }
    recentSearch.value = recentSearch.reversed.toList();
    _pref.setRecentSearch(recentSearch);
    // _pref.setPopularRecentSearch(popularSearch);
  }


  addPopSearchItem(ProductEntity product) {
    // recentSearch.remove(product.name);
    // popularSearch.remove(product.name);

    popSearch.remove(product.name);

    if (product.name.isNotEmpty) {
      popSearch.add(product.name);
      update();
    }
    // if (countSearch[index]>2) {
    //   popularSearch.add(product.name);
    //
    // }
    if (popSearch.length > 10) {
      // removeSearchItem(0);
      removePopularSearchItem(0);
    }
    popSearch.value = popSearch.reversed.toList();
    _pref.setPopularRecentSearch(popSearch);
    // _pref.setPopularRecentSearch(popularSearch);
  }


  void removeSearchItem(int index) {
    recentSearch.removeAt(index);
    // fetchProductsData();
  }

  void removePopularSearchItem(int index) {
    recentSearch.removeAt(index);
    // fetchProductsData();
  }

  @override
  void onInit() {
    recentSearch.value = _pref.recentSearch;
    popSearch.value = _pref.recentPopSearch;

    // pagingController.addPageRequestListener((pageKey) async {
    //   // await fetchPage(pageKey);
    // });
    // return fetchPage(0);

    super.onInit();
  }
}
