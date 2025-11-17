import '../../../data/models/base/base_response.dart';
import '../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../entities/sec/wallet.dart';


abstract class WalletRepository {
  Future<Wallet> getUserTotal();
  Future<List<Wallet>> getUserHistory();
  Future<BaseResponse> transactionWallet(TransactionWalletRQM rqm);
}

