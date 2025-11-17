import 'package:zistino/src/data/models/sec/wallet_model.dart';
import 'package:zistino/src/domain/entities/sec/wallet.dart';
import 'dart:io';
import 'package:zistino/src/data/models/base/base_response.dart';
import '../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../entities/sec/user.dart';


abstract class WalletRepository {
  Future<Wallet> getUserTotal();
  Future<List<Wallet>> getUserHistory();
  Future<BaseResponse> transactionWallet(TransactionWalletRQM rqm);
}

