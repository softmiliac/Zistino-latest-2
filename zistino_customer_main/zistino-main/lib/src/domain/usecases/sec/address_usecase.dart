
import 'package:zistino/src/data/models/base/lazy_rpm.dart';
import 'package:zistino/src/data/models/base/lazy_rqm.dart';

import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../entities/sec/address_entity.dart';
import '../../entities/sec/zone_entity.dart';
import '../../repositories/sec/address_repository.dart';

class FetchAllAddressUseCase extends NoParamUseCase<List<AddressEntity>> {
  final AddressRepository _repo;

  FetchAllAddressUseCase(this._repo);

  @override
  Future<List<AddressEntity>> execute() {
    return _repo.fetchAll();
  }
}

class FetchAllZonesUseCase extends ParamUseCase<BaseResponse, LazyRQM> {
  final AddressRepository _repo;

  FetchAllZonesUseCase(this._repo);


  @override
  Future<BaseResponse> execute(LazyRQM params) {
    return _repo.fetchAllZones(params);
  }
}

class AddAddressUseCase extends ParamUseCase<BaseResponse, AddressEntity> {
  final AddressRepository _repo;

  AddAddressUseCase(this._repo);

  @override
  Future<BaseResponse> execute(AddressEntity params) {
    return _repo.addAddress(params);
  }
}

class UpdateAddressUseCase extends ParamUseCase<BaseResponse, AddressEntity> {
  final AddressRepository _repo;

  UpdateAddressUseCase(this._repo);

  @override
  Future<BaseResponse> execute(AddressEntity params
      // ,int id
      ) {
    return _repo.updateAddress(params, params.id);
  }
}

class DeleteAddressUseCase extends ParamUseCase<BaseResponse, int> {
  final AddressRepository _repo;

  DeleteAddressUseCase(this._repo);

  @override
  Future<BaseResponse> execute(int params
      // ,int id
      ) {
    return _repo.deleteAddress(params);
  }
}
