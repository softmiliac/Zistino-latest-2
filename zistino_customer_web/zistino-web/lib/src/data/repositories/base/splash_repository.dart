import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/user.dart';
import '../../../domain/repositories/bas/splash_repository.dart';
import '../../models/base/base_response.dart';
import '../../providers/remote/base/category_api.dart';
import '../../providers/remote/base/home_api.dart';
import '../../providers/remote/sec/user_api.dart';

class SplashRepositoryImpl extends SplashRepository {
  @override
  Future<bool> syncApp() async {
    // var a = getCategories();
    // var b = getBookmark(); //todo check get bookmark and debug
    // var c = getUser();
    // var d = getHome();
    // var e = getCategory();//todo check

    //todo get data from server.
    // appVersion data.
    // brands data.
    // products data.
    // basket data
    var futures = <Future>[
      // c,
      // d,//todo check
    ];
    await Future.wait(futures);

    return Future.value(true);
  }

  // Future getCategories() async {
  //   LocalStorageService _pref = Get.find<LocalStorageService>();
  //   try {
  //     BaseResponse response =
  //         await CategoryAPI().getByType(CategoryType.product);
  //
  //     _pref.setCategories(response.data);
  //
  //     return bool;
  //   } catch (e) {
  //     AppLogger.e("$e");
  //     rethrow;
  //   }
  // }

  // Future getBookmark() async {
  //   try {
  //     BaseResponse response = await BookmarkAPI().fetchAll();
  //     BookmarkModel result = BookmarkModel.fromJson(response.data);
  //     Box<BookmarkItem> box = Boxes.getBookmarkBox();
  //     box.addAll(result.content);
  //
  //   } catch (e) {
  //     AppLogger.e("$e");
  //     rethrow;
  //   }
  // }

  Future getHome() async {
    LocalStorageService pref = Get.find<LocalStorageService>();
    try {
      BaseResponse response = await HomeApi().fetchHome();

      var data = response.data as List; //List<List<dynamic>>

      pref.setHome(data);
      return;
    } catch (e) {
      AppLogger.e("$e");
      rethrow;
    }
  }
  // Future getProducts() async {
  //   LocalStorageService pref = Get.find<LocalStorageService>();
  //
  //   LazyRQM rqm = LazyRQM(
  //     keyword: ''
  //
  //   );
  //   try {
  //     BaseResponse response = await ProductsAPI().fetchAll(rqm);
  //     LazyRPM<ProductModel> result =
  //     LazyRPM.fromJson(response.data, ProductModel.fromJson);
  //     pref.setSearchProducts(result);
  //     return result;
  //   } catch (e) {
  //     AppLogger.e("$e");
  //     rethrow;
  //   }
  // }

  Future getCategory() async {
    LocalStorageService pref = Get.find<LocalStorageService>();
    try {
      BaseResponse response = await CategoryApi().fetchCategory();

      var data = response.data as List;

      pref.setCategory(data);
      return;
    } catch (e) {
      AppLogger.e("$e");
      rethrow;
    }
  }


  Future<User> getUser() async {
    final LocalStorageService pref = Get.find<LocalStorageService>();
    try {
      debugPrint(pref.token);
      if (pref.
      token != LocalStorageService.defaultTokenValue) {
        Map<String, dynamic> response = await UserApi().fetchUser();
        pref.setUser(response);
      }

      return pref.user;
    } catch (e) {
      AppLogger.e("$e");
      rethrow;
    }
  }
}
