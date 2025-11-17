
import 'package:admin_dashboard/src/common/services/get_storage_service.dart';
import 'package:admin_dashboard/src/data/models/base/lazy_rqm.dart';
import 'package:get/get.dart';

import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/pro/product_entity.dart';
import '../../../domain/repositories/pro/product_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/base/lazy_rpm.dart';
import '../../models/pro/category_model.dart';
import '../../models/pro/product_model.dart';
import '../../providers/remote/pro/product_api.dart';
import '../../providers/remote/pro/search_product_api.dart';

class ProductRepositoryImpl extends ProductRepository {
  LocalStorageService pref = Get.find();

  @override
  Future<ProductEntity> getByID(String id, {bool fromLocal = false}) async {
    try {
      BaseResponse baseResponse = await ProductApi().getById(id);
      ProductEntity response = ProductModel.fromJson(baseResponse.data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<List<ProductEntity>> getByCategoryID(int id, {bool fromLocal = true}) async{
  //   try{
  //     BaseResponse response = await ProductsAPI().getByCategoryID(id);
  //     List<ProductEntity> result = ProductModel.fromJsonList(response.data as List);
  //     return result;
  //   }catch(e){
  //     rethrow;
  //   }
  // }

  @override
  Future<LazyRPM<ProductEntity>> getProductsBySearch(LazyRQM rqm) async{
    try{
      BaseResponse response = await ProductsAPI().searchBySp(rqm);
      LazyRPM<ProductModel> result =
      LazyRPM.fromJson(response.data, ProductModel.fromJson);
      return result;
    }catch(e){
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories1() async{
    try {
      // if (fromLocal) {
      //   LocalStorageService _pref = Get.find<LocalStorageService>();
      //   List<CategoryModel> items = _pref.categories;
      //   return items;
      // } else {
      BaseResponse response = await ProductsAPI().fetchCategories();
      pref.setCategory(response.data);
      List<CategoryModel> result =
      CategoryModel.fromJsonList(response.data);
      return result;
    } catch (e) {
      AppLogger.e("$e");
      rethrow;
    }
  }

  @override
  Future<List<ProductEntity>> getResidue() async{
    try{
      BaseResponse response= await ProductApi().fetchResidue();
      List<ProductEntity> result = ProductModel.fromJsonList(response.data as List);
      return result;
    }catch(e){
      rethrow;
    }
  }
}
