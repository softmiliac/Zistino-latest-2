import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/base/config_model.dart';
import '../../data/models/base/home_model.dart';
import '../../data/models/base/lazy_rpm.dart';
import '../../data/models/pro/category_model.dart';
import '../../data/models/sec/address_model.dart';
import '../../data/models/sec/user_model.dart';
import '../../data/models/sec/wallet_model.dart';
import '../../data/models/sec/zone_model.dart';
import '../../data/providers/remote/api_provider.dart';
import '../../domain/entities/sec/user.dart';
import '../../presentation/routes/app_pages.dart';
import '../utils/app_logger.dart';

class LocalStorageService extends GetxService {
  static final _box = GetStorage();

  static const String firebaseKey = "FirebaseKey";
  static const String userKey = "UserKey";
  static const String addressesKey = "AddressesKey";
  static const String zonesKey = "ZonesKey";
  static const String totalWalletKey = "totalWalletKey";
  static const String homeKey = "homeKey";
  static const String categoryKey = "categoryKey";
  static const String configKey = "configKey";
  static const String isFirstTimeLaunchKey = "IsFirstTimeLaunch";
  static const String showTutorialKey = "ShowTutorial";
  static const String showTutorialProductsKey = "ShowTutorialProducts";
  static const String tenantKey = "TenantKey";
  static const String tokenKey = "TokenKey";
  static const String defaultTokenValue = "anonymous";
  static const String defaultTenantValue = "root";
  static const String refreshTokenKey = "refreshTokenKey";
  static const String refreshTokenExpiryTimeKey = "refreshTokenExpiryTimeKey";
  static const String isPersianModeKey = "isPersianModeKey";
  static const String isDarkKey = "isDarkKey";
  static const String languageKey = "languageKey";

  static const String recentSearchKey = "RecentSearchKey";
  static const String recentPopularSearchKey = "RecentPopularSearchKey";
  static const String basketItemsKey = "BasketItemsKey";
  static const String bookmarksKey = "BookmarksKey";
  static const String categoriesKey = "categoriesKey";

  String get tenant {
    String a = _box.read(tenantKey) ?? defaultTenantValue;

    return a;
  }

  set tenant(String tenant) {
    // final APIProvider _api = Get.find();
    _box.write(tenantKey, tenant);
    // _api.updateHeaders();
  }

  String get token {
    String a = _box.read(tokenKey) ?? defaultTokenValue;

    return a;
  }

  set token(String token) {
    final APIProvider _api = Get.find();
    _box.write(tokenKey, token);
    // _api.updateHeaders();
  }

  String get refreshToken => _box.read(refreshTokenKey) ?? "";

  set refreshToken(String refreshToken) =>
      _box.write(refreshTokenKey, refreshToken);

  String get refreshTokenExpiryTime =>
      _box.read(refreshTokenExpiryTimeKey) ?? "";

  set refreshTokenExpiryTime(String refreshTokenExpiryTime) =>
      _box.write(refreshTokenExpiryTimeKey, refreshTokenExpiryTime);

  bool get isFirstTimeLaunch => _box.read(isFirstTimeLaunchKey) ?? true;

  set isFirstTimeLaunch(bool value) => _box.write(isFirstTimeLaunchKey, value);

  bool get showTutorial => _box.read(showTutorialKey) ?? true;

  set showTutorial(bool value) => _box.write(showTutorialKey, value);

  bool get showTutorialProducts => _box.read(showTutorialProductsKey) ?? true;

  set showTutorialProducts(bool value) =>
      _box.write(showTutorialProductsKey, value);

  bool get isPersianMode => _box.read(isPersianModeKey) ?? true;

  set isPersianMode(bool value) => _box.write(isPersianModeKey, value);

  bool get isDark => _box.read(isDarkKey) ?? true;

  set isDark(bool value) => _box.write(isDarkKey, value);

  String get language =>
      _box.read<String>(languageKey) ?? Get.deviceLocale?.languageCode ?? "";

  set language(String key) => _box.write(languageKey, key);

  String get firebaseToken => _box.read<String>(firebaseKey) ?? "";

  set firebaseToken(String key) => _box.write(firebaseKey, key);

  User get user {
    var userJson = _box.read(userKey);
    if (userJson == null) {
      return UserModel();
    }
    UserModel userModel = UserModel.fromJson(json.decode(userJson));
    return userModel;
  }

  set user(User item) {
    try {
      _box.write(userKey, json.encode(UserModel.fromEntity(item).toJson()));
    } catch (e) {
      AppLogger.e('$e');
    }
  }

  // WalletModel get totalWallet {
  //   var totalWalletJson = _box.read(totalWalletKey);
  //   if (totalWalletJson == null) {
  //     return WalletModel();
  //   }
  //   WalletModel totalWalletModel = WalletModel.fromJson(json.decode(totalWalletJson));
  //   return totalWalletModel;
  // }

  // set totalWallet(WalletModel item) {
  //   try {
  //     _box.write(totalWalletKey, json.encode(WalletModel.fromEntity(item).toJson()));
  //   } catch (e) {
  //     AppLogger.e('$e');
  //   }
  // }

  bool isLogin() {
    if (token != LocalStorageService.defaultTokenValue) {
      return true;
    }
    return false;
  }

  setUser(Map<String, dynamic> _json) async {
    try {
      await _box.write(userKey, json.encode(_json));
    } catch (e) {
      debugPrint("$e");
    }
  }

  // List<CategoryModel> get categories {
  //   var json = _box.read(categoriesKey);
  //   if (json == null) {
  //     return [];
  //   }
  //   List<CategoryModel> items = CategoryModel.fromJsonList(json as List);
  //   return items;
  // }

  setCategories(List json) {
    _box.write(categoriesKey, json);
  }

  List<String> get recentSearch {
    List<dynamic>? items = _box.read(recentSearchKey);
    if (items == null) {
      return [];
    }
    return List.from(items.map((e) => e));
  }

  List<String> get recentPopSearch {
    List<dynamic>? items = _box.read(recentPopularSearchKey);
    if (items == null) {
      return [];
    }
    return List.from(items.map((e) => e));
  }

  setRecentSearch(List<String> items) {
    _box.write(recentSearchKey, items);
  }

  setPopularRecentSearch(List<String> items) {
    _box.write(recentPopularSearchKey, items);
  }

  //*********************

  List<List<ProductSectionModel>> get getHome {
    var json = _box.read(homeKey);

    List data = json as List; //List<List<dynamic>>

    List<List<ProductSectionModel>> out = [];

    for (int i = 0; i < data.length; i++) {
      try {
        List<ProductSectionModel> result =
            ProductSectionModel.fromJsonList(data[i] as List);
        out.add(result);
      } catch (e) {
        AppLogger.e('$e');
      }
    }

    return out;
  }

  // List<ProductSectionModel> get getHome {
  //   var json = _box.read(homeKey);
  //   if (json == null) {
  //     return [];
  //   }
  //   List<ProductSectionModel> items = ProductSectionModel.fromJsonList(json as List);
  //   return items;
  // }

  setHome(List json) {
    _box.write(homeKey, json);
  }

  setSearchProducts(LazyRPM json) {
    _box.write(homeKey, json);
  }

  //*********************

  List<CategoryModel> get getCategory {
    var json = _box.read(categoryKey);

    List data = json as List; //List<List<dynamic>>

    List<CategoryModel> out = [];

    for (int i = 0; i < data.length; i++) {
      try {
        CategoryModel result = CategoryModel.fromJson(data[i]);
        out.add(result);
      } catch (e) {
        AppLogger.e('$e');
      }
    }

    return out;
  }

  setCategory(List json) {
    _box.write(categoryKey, json);
  }

  // List<ConfigModel> get getConfig {
  //   var json = _box.read(configKey);
  //
  //   List data = json as List; //List<List<dynamic>>
  //
  //   List<ConfigModel> out = [];
  //
  //   for (int i = 0; i < data.length; i++) {
  //     try {
  //       ConfigModel result = ConfigModel.fromJson(data[i]);
  //       out.add(result);
  //     } catch (e) {
  //       AppLogger.e('$e');
  //     }
  //   }
  //
  //   return out;
  // }

  ConfigModel get getConfig {
    var config = _box.read(configKey);
    if (config == null) {
      return ConfigModel();
    }
    ConfigModel userModel = ConfigModel.fromJson(json.decode(config));
    return userModel;
  }

  setConfig(Map<String, dynamic> _json) async {
    try {
      await _box.write(configKey, json.encode(_json));
    } catch (e) {
      debugPrint("$e");
    }
  }

  List<AddressModel> get addresses {
    var json = _box.read(addressesKey);
    if (json != null) {
      List data = json as List; //List<List<dynamic>>
      List<AddressModel> out = [];
      for (int i = 0; i < data.length; i++) {
        try {
          AddressModel result = AddressModel.fromJson(data[i]);
          out.add(result);
        } catch (e) {
          AppLogger.e('$e');
        }
      }
      return out.reversed.toList();
    } else {
      return [];
    }
  }

  setAddresses(List json) {
    _box.write(addressesKey, json);
  }

  List<ZoneModel> get zones {
    var json = _box.read(zonesKey);

    List data = json as List;

    List<ZoneModel> out = [];

    for (int i = 0; i < data.length; i++) {
      try {
        ZoneModel result = ZoneModel.fromJson(data[i]);
        out.add(result);
      } catch (e) {
        AppLogger.e('$e');
      }
    }

    return out.reversed.toList();
  }

  setZones(List json) {
    _box.write(zonesKey, json);
  }

  List<WalletModel>? get totalWallet {
    var json = _box.read(totalWalletKey);

    // if(totalWallet?.isNotEmpty ?? false || totalWallet != null){
    List data = json as List; //List<List<dynamic>>

    List<WalletModel> out = [];

    for (int i = 0; i < data.length; i++) {
      try {
        WalletModel result = WalletModel.fromJson(data[i]);
        out.add(result);
      } catch (e) {
        AppLogger.e('$e');
      }
    }
    return out;
    // }else{
    //   return [WalletModel(price: 0)];
    // };
  }

  setTotalWallet(List json) {
    _box.write(totalWalletKey, json);
  }

  Future clearPref() async {
    var a = _box.erase();

    // var b = _box.remove(UserKey);
    var futures = <Future>[a];
    await Future.wait(futures);
  }

  Future logOut() async {
    //todo final this func
    //   var a = _box.remove(firebaseKey);
    //   var b = _box.remove(userKey);
    // var b = _box.remove(tokenKey);
    // var c = _box.remove(refreshTokenKey);
    // var d = _box.remove(refreshTokenExpiryTimeKey);
    // var e = _box.remove(recentSearchKey);
    // var futures = <Future>[a, b, c, d, e];
    // await Future.wait(futures);

    user = User();
    token = defaultTokenValue;
    firebaseToken = "";
    refreshToken = "";
    refreshTokenExpiryTime = "";
    setRecentSearch([]);
    setPopularRecentSearch([]);
    isFirstTimeLaunch = false;
    Get.offAllNamed(Routes.authenticationPage);
  }

  Map<String, String> get headers {
    Map<String, String> headers = {
      'apiLevel': "1",
      //todo amin alizadeh
      'appVersion': "1.0.0",
      //todo amin alizadeh
      'platform': "1.0.0",
      //todo amin alizadeh
      'tenant': 'root', //todo fix from server
      'content-type': 'application/json',
      // 'tenant': tenant == defaultTenantValue ? defaultTenantValue : tenant,
      'Accept-Language': 'en',
      'Authorization':
          // 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImFhY2U0NzBmLWY4MzQtNGRlYi1hNmNmLThjMmQ4MjI3MGZmYyIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6ImFkbWluQHJvb3QuY29tIiwiZnVsbE5hbWUiOiJyb290IEFkbWluIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZSI6InJvb3QiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zdXJuYW1lIjoiQWRtaW4iLCJpcEFkZHJlc3MiOiI1LjEyNS45Ny4xMjIiLCJ0ZW5hbnQiOiJyb290Iiwicm9sZXMiOiJbXCJBZG1pblwiXSIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL21vYmlsZXBob25lIjoiIiwiZXhwIjoxNjc1ODQ1ODg3fQ.nU9LfwU38pWTYl4d3vwHsq0D3-GHrmzcsT4YfgFVsCk'
          token == defaultTokenValue ? defaultTokenValue : 'Bearer $token'
    };

    return headers;
  }
}
