import 'package:get/get.dart';
import '../../../models/base/base_response.dart';
import '../../../models/sec/transaction_wallet_rqm.dart';
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

class WalletApi extends APIClass {
  final APIProvider _provider = Get.find();

  @override
  APIControllers get controller => APIControllers.transactionwallet;

  Future<BaseResponse> fetchWallet() async {
    try {
      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.myTransactionWalletTotal,
          version: 'v1');
      BaseResponse response =
      await _provider.getRequest(url, null, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse> transactionWallet(TransactionWalletRQM rqm) async {
    try {
      Map<String, dynamic> input = rqm.toJson();
      String url = APIEndpoint.urlCreator(controller, '');
      BaseResponse response =
      await _provider.postRequest(url, input, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseResponse> myWalletHistory() async {
    try {
      String url = APIEndpoint.urlCreator(
          controller, APIEndpoint.myTransactionWalletHistory,
          version: 'v1');
      BaseResponse response =
      await _provider.getRequest(url, null, hasBaseResponse: true);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
