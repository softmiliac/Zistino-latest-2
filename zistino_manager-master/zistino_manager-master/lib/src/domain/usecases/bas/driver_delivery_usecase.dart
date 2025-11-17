import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/domain/entities/base/driver_delivery.dart';
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/driver_delivery_model.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../data/repositories/base/driver_delivery_repository.dart';
import '../../repositories/bas/driver_delivery_repository.dart';
class CreateDeliveryUseCase extends ParamUseCase<BaseResponse,DriverDeliveryModel>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();

  @override
  Future<BaseResponse> execute(DriverDeliveryModel params) {
    return repo.createDeliveryRequest(params);
  }
}

class FetchDriverDeliveryUseCase
    extends ParamUseCase<LazyRPM<DriverDeliveryEntity>,LazyRQM> {
  final DriverDeliveryRepositoryImpl _repo = DriverDeliveryRepositoryImpl();
  @override
  Future<LazyRPM<DriverDeliveryEntity>> execute(LazyRQM params) {
    return _repo.getDriverDelivery(params);
  }
}

class DeleteDeliveryUseCase extends ParamUseCase<BaseResponse,DriverDeliveryRQM>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();
  @override
  Future<BaseResponse> execute(DriverDeliveryRQM params) {
    return repo.deleteDeliveryRequest(params);
  }
}

class EditDeliveryUseCase extends ParamUseCase<BaseResponse,DriverDeliveryRQM>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();
  @override
  Future<BaseResponse> execute(DriverDeliveryRQM params) {
    return repo.editDeliveryRequest(params);
  }
}
