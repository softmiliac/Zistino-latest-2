import 'package:admin_dashboard/src/data/models/sec/wallet_model.dart';
import 'package:admin_dashboard/src/domain/entities/sec/wallet.dart';
import 'dart:io';
import 'package:admin_dashboard/src/data/models/base/base_response.dart';
import '../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../entities/sec/user.dart';


abstract class WalletRepository {
  Future<Wallet> getUserTotal();
  Future<List<Wallet>> getUserHistory();
  Future<BaseResponse> transactionWallet(TransactionWalletRQM rqm);
}

