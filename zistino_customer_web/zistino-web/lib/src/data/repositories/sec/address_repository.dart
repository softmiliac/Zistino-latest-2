import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/address_entity.dart';
import '../../../domain/repositories/sec/address_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/address_model.dart';
import '../../providers/remote/sec/addresses_api.dart';


class AddressRepositoryImpl extends AddressRepository {
  LocalStorageService pref = Get.find();

  @override
  Future<BaseResponse> addAddress(AddressEntity _rqm,
      {bool fromLocal = false}) async {
    try {
      // if (pref.token != LocalStorageService.defaultTokenValue) {//todo fix this after fix token
      BaseResponse response = await AddressesAPI().insert(_rqm);

      return response;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<List<AddressEntity>> fetchAll({bool fromLocal = false}) async {
    try {
      BaseResponse response = await AddressesAPI().fetchAll();
      pref.setAddresses(response.data as List);
      debugPrint("$response");
      List<AddressEntity> result = AddressModel.fromJsonList(response.data as List);
    return result;
    } catch (e) {

    rethrow;
    }
  }

  @override
  Future<BaseResponse> updateAddress(AddressEntity _rqm, int id,
      {bool fromLocal = false}) async {
    try {
      LocalStorageService _pref = Get.find();

      // if (_pref.token != LocalStorageService.defaultTokenValue) { //todo fix this after fix token
      BaseResponse response = await AddressesAPI().update(_rqm, id);

      return response;
      // } else {
      //   return BaseResponse(succeeded: true, data: true, messages: []);
      // }
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future<BaseResponse> deleteAddress(int id, {bool fromLocal = true}) async {
    try {
      BaseResponse response = await AddressesAPI().delete(id); //todo set id

      return response;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

// @override
// Future<BaseResponse> getByID(int _id,
//     {bool fromLocal = false}) async {
//   try {
//     Map<String, dynamic> response = await AddressesAPI().getByID(_id); //todo url
//     return BaseResponse.fromJson(response);
//   } catch (e) {
//     debugPrint(e);
//     throw (e);
//   }
// }
}
