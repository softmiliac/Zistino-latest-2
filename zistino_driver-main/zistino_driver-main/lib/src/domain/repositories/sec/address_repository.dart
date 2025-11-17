
import '../../../data/models/base/base_response.dart';
import '../../entities/sec/address_entity.dart';


abstract class AddressRepository {
  Future<BaseResponse> addAddress(AddressEntity _rqm, {bool fromLocal = true});


  Future<BaseResponse> deleteAddress(int id, {bool fromLocal = true});

  Future<BaseResponse> updateAddress(AddressEntity _rqm,
      int id,
      {bool fromLocal = true});

  Future<AddressEntity> getByID(int _id);

  Future<List<AddressEntity>> fetchAll({bool fromLocal = true}); //todo BaseResponse<List<Address>>
}
