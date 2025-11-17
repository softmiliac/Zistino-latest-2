import 'package:admin_zistino/src/common/usecases/usecase.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rpm.dart';
import 'package:admin_zistino/src/data/models/base/lazy_rqm.dart';
import 'package:admin_zistino/src/data/models/base/trip_rqm.dart';
import 'package:admin_zistino/src/data/repositories/base/trip_repository.dart';

import '../../entities/base/trip_entity.dart';

class CreateTripUseCase extends ParamUseCase<int,TripRqm>{
  final TripRepositoryImpl _repo =TripRepositoryImpl();

  @override
  Future<int> execute(TripRqm params) async{
    try{
      return _repo.createTrip(params);
    }catch(e){
      rethrow;
    }
  }

}

class EndTripUseCase extends ParamUseCase<int,TripRqm>{
  final TripRepositoryImpl _repo =TripRepositoryImpl();

  @override
  Future<int> execute(TripRqm params) async{
    try{
      return _repo.endTrip(params);
    }catch(e){
      rethrow;
    }
  }
}
class SearchTripUseCase extends ParamUseCase<List<TripEntity>,LazyRQM>{
  final TripRepositoryImpl _repo =TripRepositoryImpl();

  @override
  Future<List<TripEntity>> execute(LazyRQM params) {
    return _repo.searchTrip(params);
  }


}