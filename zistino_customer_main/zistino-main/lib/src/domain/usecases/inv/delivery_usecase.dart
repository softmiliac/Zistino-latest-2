import 'package:zistino/src/common/usecases/usecase.dart';
import 'package:zistino/src/data/models/base/base_response.dart';
import 'package:zistino/src/data/models/base/lazy_rqm.dart';
import 'package:zistino/src/data/repositories/inv/driver_delivery_repository.dart';
import 'package:zistino/src/domain/entities/inv/driver_delivery.dart';

import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../data/models/inv/driver_delivery_model.dart';
import '../../repositories/inv/driver_delivery_repository.dart';

class FetchDriverDeliveryUseCase
    extends ParamUseCase<LazyRPM<DriverDeliveryEntity>,LazyRQM> {
  final DriverDeliveryRepository _repo = DriverDeliveryRepositoryImpl();


  @override
  Future<LazyRPM<DriverDeliveryModel>> execute(LazyRQM params) {
    return _repo.getDriverDelivery(params);
  }
}

class CreateDeliveryUseCase extends ParamUseCase<BaseResponse,DriverDeliveryModel>{
  final DriverDeliveryRepository repo;
  CreateDeliveryUseCase(this.repo);
  @override
  Future<BaseResponse> execute(DriverDeliveryModel params) {
    return repo.createDeliveryRequest(params);
  }
}
class EditDeliveryUseCase extends ParamUseCase<BaseResponse,DriverDeliveryRQM>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();

  @override
  Future<BaseResponse> execute(DriverDeliveryRQM params) {
    return repo.editDeliveryRequest(params);
  }
}
class DeleteDeliveryUseCase extends ParamUseCase<BaseResponse,DriverDeliveryRQM>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();
  @override
  Future<BaseResponse> execute(DriverDeliveryRQM params) {
    return repo.deleteDeliveryRequest(params);
  }
}