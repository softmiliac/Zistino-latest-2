import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/repositories/sec/orders_repository.dart';
import '../../entities/sec/order_entity.dart';
import '../../repositories/sec/orders_repository.dart';

class OrdersUseCase extends ParamUseCase<List<OrderEntityClient>, LazyRQM> {
  final OrdersRepository _repo;

  OrdersUseCase(this._repo);

  @override
  Future<List<OrderEntityClient>> execute(LazyRQM params) {
    return _repo.fetchAll(params);
  }
}

class ClientOrderDetailUseCase extends ParamUseCase<OrderEntityClient, int> {
  final OrdersRepositoryImpl _repo = OrdersRepositoryImpl();

  @override
  Future<OrderEntityClient> execute(int? params) {
    return _repo.getClientByPreOrderID(params);
  }
}

class DriverOrderDetailUseCase extends ParamUseCase<OrderEntityDriver, int> {
  final OrdersRepositoryImpl _repo = OrdersRepositoryImpl();

  @override
  Future<OrderEntityDriver> execute(int? params) {
    return _repo.getByDriverOrderID(params);
  }
}