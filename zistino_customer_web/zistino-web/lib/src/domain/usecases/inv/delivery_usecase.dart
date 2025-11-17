import 'package:admin_dashboard/src/common/usecases/usecase.dart';
import 'package:admin_dashboard/src/data/models/base/base_response.dart';
import 'package:admin_dashboard/src/data/models/base/lazy_rqm.dart';
import 'package:admin_dashboard/src/domain/entities/inv/driver_delivery.dart';

import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../../data/models/inv/driver_delivery_model.dart';
import '../../repositories/inv/driver_delivery_repository.dart';

class FetchDriverDeliveryUseCase
    extends ParamUseCase<LazyRPM<DriverDeliveryEntity>,LazyRQM> {
  final DriverDeliveryRepository _repo;

  FetchDriverDeliveryUseCase(this._repo);

  @override
  Future<LazyRPM<DriverDeliveryModel>> execute(LazyRQM params) {
    return _repo.getDriverDelivery(params);
  }
}

class CreateDeliveryUseCase extends ParamUseCase<dynamic,DriverDeliveryModel>{
  final DriverDeliveryRepository repo;
  CreateDeliveryUseCase(this.repo);
  @override
  Future execute(DriverDeliveryModel params) {
    return repo.createDeliveryRequest(params);
  }
}
class EditDeliveryUseCase extends ParamUseCase<dynamic,int>{
  final DriverDeliveryRepository repo;
  EditDeliveryUseCase(this.repo);
  @override
  Future execute(int params) {
    return repo.editDeliveryRequest(params);
  }
}
class DeleteDeliveryUseCase extends ParamUseCase<BaseResponse,DeleteDriverDeliveryRQM>{
  final DriverDeliveryRepository repo;
  DeleteDeliveryUseCase(this.repo);
  @override
  Future<BaseResponse> execute(DeleteDriverDeliveryRQM params) {
    return repo.deleteDeliveryRequest(params);
  }
}