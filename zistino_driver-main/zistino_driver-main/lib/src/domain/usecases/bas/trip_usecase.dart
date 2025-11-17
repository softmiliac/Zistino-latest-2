import 'package:recycling_machine/src/common/usecases/usecase.dart';
import 'package:recycling_machine/src/data/models/base/trip_rqm.dart';
import 'package:recycling_machine/src/data/repositories/base/trip_repository.dart';

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
      return await _repo.endTrip(params);
    }catch(e){
      rethrow;
    }
  }

}