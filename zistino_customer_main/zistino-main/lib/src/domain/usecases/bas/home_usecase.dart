
import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/repositories/base/home_repository.dart';
import '../../entities/base/home_entity.dart';
import '../../entities/inv/driver_delivery.dart';
import '../../repositories/inv/driver_delivery_repository.dart';

class FetchHomeUseCase extends NoParamUseCase<List<List<ProductSectionEntity>>>{
  final HomeRepositoryImpl _homeRepositoryImpl = HomeRepositoryImpl();

  @override
  Future<List<List<ProductSectionEntity>>> execute() {
    return _homeRepositoryImpl.getHome();
  }

}
// class FetchDriverDeliveryUseCase
//     extends ParamUseCase<LazyRPM<DriverDeliveryEntity>,LazyRQM> {
//   final HomeRepositoryImpl _repo;
//
//   FetchDriverDeliveryUseCase(this._repo);
//
//   @override
//   Future<LazyRPM<DriverDeliveryEntity>> execute(LazyRQM params) {
//     return _repo.getDriverDelivery(params);
//   }
// }