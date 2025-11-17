import '../../../domain/entities/sec/coupon.dart';
import '../base/safe_convert.dart';

class CouponsModel extends CouponEntity {


  CouponsModel({
    final int? id,
    final int? status,
    final String? key,
    final int? amount
  }):super(status: status ?? 0,
  amount: amount ?? 0,
  id: id ?? 0,
  key: key ?? '',
  );

  factory CouponsModel.fromJson(Map<String, dynamic>? json) => CouponsModel(
    id: asT<int>(json, 'id'),
    status: asT<int>(json, 'status'),
    amount: asT<int>(json, 'amount'),
    key: asT<String>(json, 'key'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status,
    'amount': amount,
    'key': key,
  };
}

