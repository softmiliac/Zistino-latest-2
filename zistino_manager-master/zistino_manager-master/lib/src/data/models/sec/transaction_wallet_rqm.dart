import '../base/safe_convert.dart';

class TransactionWalletRQM {
  final String? userId;
  final String? senderId;
  final int? type;
  final int? price;
  final int? coin;
  final int? status;
  final double? exchangeRate;
  final bool? finished;

  TransactionWalletRQM({
    this.userId,
    this.senderId,
    this.type,
    this.price,
    this.coin,
    this.status,
    this.exchangeRate,
    this.finished,
  });

  factory TransactionWalletRQM.fromJson(Map<String, dynamic>? json) => TransactionWalletRQM(
    userId: asT<String>(json, 'userId'),
    senderId: asT<String>(json, 'senderId'),
    type: asT<int>(json, 'type'),
    price: asT<int>(json, 'price'),
    coin: asT<int>(json, 'coin'),
    status: asT<int>(json, 'status'),
    exchangeRate: asT<double>(json, 'exchangeRate'),
    finished: asT<bool>(json, 'finished'),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'senderId': senderId,
    'type': type,
    'price': price,
    'coin': coin,
    'status': status,
    'exchangeRate': exchangeRate,
    'finished': finished,
  };
}

