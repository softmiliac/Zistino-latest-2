class Wallet {
  String? userId;
  String? senderId;
  int? type;
  int? price;
  int? coin;
  int? exchangeRate;
  String? createdOn;


  final bool finished;

  Wallet({
    this.userId,
    this.senderId,
    this.type,
    this.price,
    this.coin,
    this.exchangeRate,
    this.finished = false,
    this.createdOn,
  });
}
