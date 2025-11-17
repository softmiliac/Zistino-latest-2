import 'package:recycling_machine/src/common/usecases/usecase.dart';
import 'package:recycling_machine/src/data/models/base/location_rqm.dart';
import '../../../data/repositories/base/location_repository.dart';

class LocationsUseCase extends ParamUseCase<int,LocationsRqm>{
  final LocationRepositoryImpl _repo =LocationRepositoryImpl();

  @override
  Future<int> execute(LocationsRqm params){
    try{
      return _repo.fetchLocation(params);
    }catch(e){
      rethrow;

    }
  }

}