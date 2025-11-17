import 'package:get/get.dart';

import '../../../../common/utils/app_logger.dart';
import '../../../../domain/entities/inv/basket.dart';
import '../../../models/base/base_response.dart';
import '../../../models/inv/basket_model.dart';
import '../../../models/inv/order_rqm.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class BasketApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  // TODO: implement controller
  APIControllers get controller => APIControllers.baskets;

  APIControllers get orderController => APIControllers.orders;

  Future getBasket() async {
    try {
      String url = APIEndpoint.urlCreator(controller, APIEndpoint.client);
      BaseResponse response = await _provider.getRequest(url, null);
      return response;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

  Future<BaseResponse> addToCard(BasketEntity model,
      {String version = "v1"}) async {
    try {
      Map<String, dynamic> inputs = BasketModel.castFromEntity(model).toJson();

      String url = APIEndpoint.urlCreator(controller, APIEndpoint.basket);

      BaseResponse response =
          await _provider.postRequest(url, inputs, hasBaseResponse: false);

      return response;
    } catch (e) {
      // AppLogger.catchLog(e);
      rethrow;
    }
  }

  Future createOrder(OrderRqm rqm) async {
    Map<String, dynamic> input = rqm.toJson();
    try {
      // try{
      //   var x =rqm.orderItems.map((e) => e.toJson()).toList();
      //   debugPrint(x);
      // }catch(e){
      //   debugPrint(e);
      //
      //   rethrow;
      // }

      String url = APIEndpoint.urlCreator(orderController, '', version: 'v1');
      BaseResponse response =
          await _provider.postRequest(url, input, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
