import 'package:admin_dashboard/src/presentation/ui/base/main_page/controller/main_controller.dart';
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

class ProductsController extends GetxController
    with StateMixin<List<ProductEntity>> {
  ProductsController(
      // this._productsUseCase,
      this._searchUseCase);

  ///**************** Instances *********************

  final LocalStorageService pref = Get.find();
  final GetProductsBySearchUseCase _searchUseCase;
  late final MainPageController mainPageController = Get.find();

  ///**************** variables *********************

  RxInt categoryIndex = 0.obs;
  List<ProductEntity>? rpm;
  RxBool isRefresh = false.obs;
  RxBool isEmptyTextField = false.obs;
  RxString searchingText = "".obs;
  RxList<String> recentSearch = <String>[].obs;
  RxList<String> popSearch = <String>[].obs;
  List<int> countSearch = [];
  int index = 0;

  ///**************** Functions *********************

  stopLoading() {
    change([], status: RxStatus.empty());
  }

  Future<List?> fetchProducts(
      {pageNumber = 1}) async {
    try {
      LazyRQM rqm = LazyRQM(
          pageNumber: pageNumber,
          pageSize: 50,
          keyword: mainPageController.searchTextController.text,
          categoryType: 1,
          categoryId: pref.getCategory[categoryIndex.value].id,
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
      return rpm;
    } catch (e) {
      List<String> messages = [];
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


  // void changeIndex(int _index) {
  //   _indexFilter = _index;
  //   update();
  //   pagingController.refresh();
  //   // fetchPage(0);
  //   debugPrint("changeSearchText_query:  $_searchText");
  // }


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
    pref.setRecentSearch(recentSearch);
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
    pref.setPopularRecentSearch(popSearch);
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
    recentSearch.value = pref.recentSearch;
    popSearch.value = pref.recentPopSearch;
    fetchProducts();
    // pagingController.addPageRequestListener((pageKey) async {
    //   // await fetchPage(pageKey);
    // });
    // return fetchPage(0);

    super.onInit();
  }
}
