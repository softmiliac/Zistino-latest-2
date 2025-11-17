import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import '../../common/usecases/usecase.dart';
import '../../data/models/base/lazy_rpm.dart';
import '../../data/repositories/base/driver_repository.dart';
import '../entities/base/driver_entity.dart';

class FetchDriverUseCase extends ParamUseCase<List<DriverEntity>,LazyRQM> {
  final DriverRepositoryImpl _repo = DriverRepositoryImpl();


  @override
  Future<List<DriverEntity>> execute(LazyRQM params) {
    return _repo.fetchDriver(params);
  }
}
