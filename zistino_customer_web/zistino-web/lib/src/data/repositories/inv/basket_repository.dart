
import '../../../common/utils/app_logger.dart';
import '../../../domain/repositories/inv/basket_repository.dart';
import '../../../domain/entities/inv/basket.dart';
import '../../models/base/base_response.dart';
import '../../models/inv/basket_model.dart';
import '../../models/inv/order_rqm.dart';
import '../../providers/remote/inv/basket_api.dart';

class BasketRepositoryImpl extends BasketRepository {
  @override
  Future<BasketEntity> getBasket({bool fromLocal = false})async {
    try {
      if(fromLocal){
        return null!;

      }else{
        BaseResponse response = await BasketApi().getBasket();
        BasketModel result = BasketModel.fromJson(response.data);
        return result;
      }

    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }
  @override
  Future<BaseResponse> addToCard(BasketEntity _rqm,
      {bool fromLocal = false}) async {
    try {
      BaseResponse response = await BasketApi().addToCard(_rqm);

      return response;
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }

  @override
  Future createOrder(OrderRqm orderRqm) async{
    try{
      BaseResponse response = await BasketApi().createOrder(orderRqm) ;

    return response;

    }catch(e){
      rethrow;
    }
  }


}
