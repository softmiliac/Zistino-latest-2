import 'package:admin_zistino/src/common/usecases/usecase.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/data/models/base/location_rqm.dart';
import 'package:admin_zistino/src/domain/entities/base/locations_entity.dart';
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
class SearchLocationsUseCase extends ParamUseCase<List<LocationsEntity>,LazyRQM>{
  final LocationRepositoryImpl _repo =LocationRepositoryImpl();

  @override
  Future<List<LocationsEntity>> execute(LazyRQM params) {
  return _repo.searchLocations(params);
  }
}