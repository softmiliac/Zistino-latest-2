

// part 'price_entity.g.dart';

// @Collection()
class PriceEntity {
  // @Id()
  // int localeID = Isar.autoIncrement;

  final int id;
  final int price;
  final String locale;

  PriceEntity(
    {
    this.id = 0,
    this.price = 0,
    this.locale = "",
  });
}

//todo مقادیر درست نیست