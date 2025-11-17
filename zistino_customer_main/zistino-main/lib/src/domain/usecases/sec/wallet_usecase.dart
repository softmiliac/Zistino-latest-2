import 'dart:io';

import 'package:zistino/src/data/models/sec/wallet_model.dart';
import 'package:zistino/src/domain/repositories/sec/wallet_repository.dart';

import 'package:zistino/src/data/models/base/base_response.dart';

import '../../../common/usecases/usecase.dart';
import '../../../data/models/sec/transaction_wallet_rqm.dart';
import '../../../data/repositories/sec/wallet_repository.dart';
import '../../entities/sec/wallet.dart';

class TotalWalletUseCase extends NoParamUseCase<Wallet> {
  final WalletRepositoryImpl _repository = WalletRepositoryImpl();


  @override
  Future<Wallet> execute() {
    return _repository.getUserTotal();
  }
}

class TransactionWalletUseCase extends ParamUseCase<BaseResponse,TransactionWalletRQM> {
  final WalletRepository _repository;

  TransactionWalletUseCase(this._repository);

  @override
  Future<BaseResponse> execute(TransactionWalletRQM params) {
    return _repository.transactionWallet(params);
  }
}

class WalletHistoryUseCase extends NoParamUseCase<List<Wallet>> {
  final WalletRepository _repo;

  WalletHistoryUseCase(this._repo);

  @override
  Future<List<Wallet>> execute() {
    return _repo.getUserHistory();
  }
}

