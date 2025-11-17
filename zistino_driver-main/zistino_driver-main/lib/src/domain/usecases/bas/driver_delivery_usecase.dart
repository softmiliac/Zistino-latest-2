import 'package:recycling_machine/src/data/models/base/lazy_rqm.dart';
import 'package:recycling_machine/src/domain/entities/base/driver_delivery.dart';
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/driver_delivery_model.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../data/repositories/base/driver_delivery_repository.dart';
import '../../repositories/bas/driver_delivery_repository.dart';

class CreateDeliveryUseCase extends ParamUseCase<dynamic,DriverDeliveryModel>{
  final DriverDeliveryRepository repo;
  CreateDeliveryUseCase(this.repo);
  @override
  Future execute(DriverDeliveryModel params) {
    return repo.createDeliveryRequest(params);
  }
}

class EditDeliveryUseCase extends ParamUseCase<dynamic,DriverDeliveryModel>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();
  @override
  Future execute(DriverDeliveryModel params) {
    return repo.editDeliveryRequest(params);
  }
}

class FetchDriverDeliveryUseCase
    extends ParamUseCase<LazyRPM<DriverDeliveryModel>,LazyRQM> {
  final DriverDeliveryRepositoryImpl _repo = DriverDeliveryRepositoryImpl();


  @override
  Future<LazyRPM<DriverDeliveryModel>> execute(LazyRQM params) {
    return _repo.getDriverDelivery(params);
  }
}
class DeleteDeliveryUseCase extends ParamUseCase<BaseResponse,DeleteDriverDeliveryRQM>{
  final DriverDeliveryRepositoryImpl repo = DriverDeliveryRepositoryImpl();
  @override
  Future<BaseResponse> execute(DeleteDriverDeliveryRQM params) {
    return repo.deleteDeliveryRequest(params);
  }
}
