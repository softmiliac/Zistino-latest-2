import 'package:admin_dashboard/src/data/models/sec/wallet_model.dart';
import 'package:admin_dashboard/src/domain/entities/sec/wallet.dart';
import 'package:admin_dashboard/src/domain/repositories/sec/wallet_repository.dart';
import 'package:get/get.dart';
import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/transaction_wallet_rqm.dart';
import '../../providers/remote/sec/wallet_api.dart';

class WalletRepositoryImpl extends WalletRepository {
  final LocalStorageService pref = Get.find<LocalStorageService>();

  @override
  Future<Wallet> getUserTotal() async {
    try {
      BaseResponse response = await WalletApi().fetchWallet();
      WalletModel result = WalletModel.fromJson(response.data[0]);
      pref.setTotalWallet(response.data);
      // WalletModel.fromJsonList(response.data as List);
      return result;
    } catch (e) {
      pref.setTotalWallet([WalletModel.fromEntity(WalletModel(price: 0)).toJson()]);
      AppLogger.catchLog(e);
      throw ('$e');
    }
  }

  @override
  Future<BaseResponse> transactionWallet(TransactionWalletRQM rqm) async {
    try {
      BaseResponse response = await WalletApi().transactionWallet(rqm);

      return response;
    } catch (e) {
      AppLogger.catchLog(e);
      throw ('$e');
    }
  }

  @override
  Future<List<Wallet>> getUserHistory() async {
    try {
      BaseResponse response = await WalletApi().myWalletHistory();
      List<Wallet> result = WalletModel.fromJsonList(response.data as List);

      return result;
    } catch (e) {
      AppLogger.catchLog(e);
      throw ('$e');
    }
  }
}
