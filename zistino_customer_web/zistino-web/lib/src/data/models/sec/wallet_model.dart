import '../../../domain/entities/sec/wallet.dart';
import '../base/safe_convert.dart';

class WalletModel extends Wallet {
  WalletModel({
    String? userId,
    String? senderId,
    int? type,
    int? price,
    int? coin,
    int? exchangeRate,
    bool finished = false,
    String? createdOn,
  }) : super(
          userId: userId,
          senderId: senderId,
          type: type,
          price: price,
          coin: coin,
          exchangeRate: exchangeRate,
          finished: finished,
          createdOn: createdOn,
        );

  WalletModel.fromEntity(final Wallet item)
      : super(
          userId: item.userId,
          senderId: item.senderId,
          type: item.type,
          price: item.price,
          coin: item.coin,
          exchangeRate: item.exchangeRate,
          finished: item.finished,
          createdOn: item.createdOn,
        );

  static List<WalletModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => WalletModel.fromJson(json)).toList();

  static Wallet toEntity(final Wallet item) {
    return Wallet(
      userId: item.userId,
      senderId: item.senderId,
      type: item.type,
      price: item.price,
      coin: item.coin,
      exchangeRate: item.exchangeRate,
      finished: item.finished,
      createdOn: item.createdOn,
    );
  }

  factory WalletModel.fromJson(Map<String, dynamic>? json) => WalletModel(
        userId: asT<String>(json, 'userId'),
        senderId: asT<String>(json, 'senderId'),
        type: asT<int>(json, 'type'),
        price: asT<int>(json, 'price'),
        coin: asT<int>(json, 'coin'),
        exchangeRate: asT<int>(json, 'exchangeRate'),
        finished: asT<bool>(json, 'finished'),
        createdOn: asT<String>(json, 'createdOn'),
      );

  Map<String, dynamic> toJson() => {
        ' userId': userId,
        ' senderId': senderId,
        ' type': type,
        ' price': price,
        ' coin': coin,
        ' exchangeRate': exchangeRate,
        ' finished': finished,
        ' createdOn': createdOn,
      };
}
