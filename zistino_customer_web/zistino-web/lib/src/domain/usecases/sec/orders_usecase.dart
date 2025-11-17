import '../../../common/usecases/usecase.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../entities/sec/order_entity.dart';
import '../../repositories/sec/orders_repository.dart';

class OrdersUseCase extends ParamUseCase<List<OrderEntity>, LazyRQM> {
  final OrdersRepository _repo;

  OrdersUseCase(this._repo);

  @override
  Future<List<OrderEntity>> execute(LazyRQM params) {
    return _repo.fetchAll(params);
  }
}

class OrderDetailUseCase extends ParamUseCase<OrderEntity, int> {
  final OrdersRepository _repo;

  OrderDetailUseCase(this._repo);

  @override
  Future<OrderEntity> execute(int? params) {
    return _repo.getByID(params);
  }
}