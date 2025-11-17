

import '../../../data/models/inv/order_rqm.dart';
import '../../entities/inv/basket.dart';

abstract class BasketRepository {
  Future<BasketEntity> getBasket();
  Future<dynamic> addToCard(BasketEntity rqm, );
  Future createOrder(OrderRqm orderRqm);

}