
import 'package:get/get.dart';
import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/address_entity.dart';
import '../../../domain/repositories/sec/address_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/address_model.dart';
import '../../providers/remote/sec/addresses_api.dart';


class AddressRepositoryImpl extends AddressRepository {
  @override
  Future<BaseResponse> addAddress(AddressEntity _rqm,
      {bool fromLocal = false}) async {
    try {
      LocalStorageService pref = Get.find();

      // if (pref.token != LocalStorageService.defaultTokenValue) {//todo fix this after fix token
        BaseResponse response = await AddressesAPI().insert(_rqm);

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
  Future<List<AddressEntity>> fetchAll({bool fromLocal = false}) async {
    try {
      LocalStorageService _pref = Get.find();
      // if (_pref.token == LocalStorageService.defaultTokenValue) {//todo fix this after fix token
      //   return [];
      // } else
      // {
        BaseResponse response = await AddressesAPI().fetchAll();

        print(response);

        List<AddressEntity> result = AddressModel.fromJsonList(response.data as List);
        return result; //todo
        // return await ProductRemoteDataSource().getById(id);
      // }
      // return Future.value();
    } catch (e) {

      // debugPrint(e);
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

@override
Future<AddressEntity> getByID(int _id) async {
  try {

    BaseResponse response = await AddressesAPI().getByID(_id);

    AddressEntity result = AddressModel.fromJson(response.data);
    return result; //todo

    // BaseResponse response = await AddressesAPI().getByID(_id); //todo url
    // return response;
  } catch (e) {
    print(e);
    throw (e);
  }
}
}
