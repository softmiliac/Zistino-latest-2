
import 'package:zistino/src/data/models/base/lazy_rpm.dart';
import 'package:zistino/src/data/models/base/lazy_rqm.dart';

import '../../../data/models/base/base_response.dart';
import '../../entities/sec/address_entity.dart';
import '../../entities/sec/zone_entity.dart';


abstract class AddressRepository {
  Future<BaseResponse> addAddress(AddressEntity _rqm, {bool fromLocal = true});


  Future<BaseResponse> deleteAddress(int id, {bool fromLocal = true});

  Future<BaseResponse> updateAddress(AddressEntity _rqm,
      int id,
      {bool fromLocal = true});

  // Future<BaseResponse> getByID(int _id, {bool fromLocal = true}); //todo BaseResponse<List<Address>>

  Future<List<AddressEntity>> fetchAll({bool fromLocal = true}); //todo BaseResponse<List<Address>>
  Future<BaseResponse> fetchAllZones(LazyRQM rqm,{bool fromLocal = true}); //todo BaseResponse<List<Address>>
}
