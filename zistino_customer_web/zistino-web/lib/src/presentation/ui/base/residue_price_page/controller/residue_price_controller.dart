import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/constants/exception_constants.dart';
import '../../../../../common/utils/app_logger.dart';
import '../../../../../data/models/pro/category_model.dart';
import '../../../../../domain/entities/pro/product_entity.dart';
import '../../../../../domain/usecases/bas/category_usecase.dart';
import '../../../../../domain/usecases/pro/product_usecase.dart';

class ResiduePriceController extends GetxController
    with StateMixin<List<CategoryModel>> {
  ResiduePriceController(this.fetchCategoryUseCase, this._residueUseCase);

  RxInt currentIndex = 0.obs;
  RxInt orderingCount = 1.obs;
  final TextEditingController counterTextEditingController =
      TextEditingController(text: "1");

  final FetchCategoryUseCase fetchCategoryUseCase;
  final ResidueUseCase _residueUseCase;
  List<CategoryModel>? result;
  List<ProductEntity>? productRPM;


  @override
  void onInit() {
   fetchCategory();
   fetchResidue();
   currentIndex.value = 0;
  }

  Future fetchCategory() async {
    try {
      change(null, status: RxStatus.loading());
      result = await fetchCategoryUseCase.execute();
      if (result!.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(result, status: RxStatus.success());
      }
    } catch (e) {
      AppLogger.e('$e');
      change(null, status: RxStatus.error());
      throw (ExceptionConstants.somethingWentWrong);
    }
  }

  Future fetchResidue() async {
    try {
      productRPM = await _residueUseCase.execute();
      return productRPM;
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  List<ProductEntity> changeItem() {
    try {
      return productRPM
              ?.where((element) =>
                  element.categories[0].id ==
                  result?[currentIndex.value].id)
              .toList() ??
          [];
    } catch (e) {
      debugPrint("$e");
      return [];
    }
  }
}
