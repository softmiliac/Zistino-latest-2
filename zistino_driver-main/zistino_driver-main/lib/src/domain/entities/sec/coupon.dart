
//
// part 'coupon_entity.g.dart';

// @Collection()

class CouponEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;
  final int id;
  final int status;
  final int amount;
  final String key;

  CouponEntity({this.id=0, this.status=0, this.amount=0, this.key=''});
}
