import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/user.dart';
import '../../../domain/repositories/sec/user_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/user_model.dart';
import '../../providers/remote/sec/user_api.dart';

class UserRepositoryImpl extends UserRepository {
  final LocalStorageService _pref = Get.find<LocalStorageService>();

  @override
  Future<bool> editUser(User model) async {
    try {
      var response = await EditUserApi().editUser(UserModel.fromEntity(model));
      _pref.setUser(UserModel.fromEntity(model).toJson());
      debugPrint('$response');
      return true;
    } catch (e) {
      AppLogger.e('$e');
      throw ('$e');
    }
  }

  @override
  Future<User?> getUser({bool isFromLocal = false}) async {
    try {
      // if (_pref.token == LocalStorageService.defaultTokenValue) {
      //   return null;
      // }
      if (isFromLocal) {
        getUserFromApi();
        User user = _pref.user;
        return user;
      } else {
        return await getUserFromApi();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUserFromApi() async {
    try {
      Map<String, dynamic> response = await UserApi().fetchUser();
      _pref.setUser(response);
      User result = UserModel.fromJson(response);
      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      throw ('$e');
    }
  }

  @override
  Future<String> uploadFile(File file) async {
    try {
      BaseResponse response = await UploadFileProfileApi().uploadImage(file);
      String imageUrl = response.data["path"];
      User user = _pref.user;
      user.imageUrl = imageUrl;
      _pref.user = user;
      bool edit = await EditUserApi().editUser(UserModel.fromEntity(User(
          imageUrl: _pref.user.imageUrl,
          id: _pref.user.id,
          companyName: _pref.user.companyName,
          email: _pref.user.email,
          lastName: _pref.user.lastName,
          firstName: _pref.user.firstName,
          phoneNumber: _pref.user.phoneNumber,
          userName: _pref.user.userName,
          emailConfirmed: _pref.user.emailConfirmed,
          isActive: _pref.user.isActive,
          vatNumber: _pref.user.vatNumber)));

      return edit.toString();
    } catch (e) {
      rethrow;
    }
  }
}
