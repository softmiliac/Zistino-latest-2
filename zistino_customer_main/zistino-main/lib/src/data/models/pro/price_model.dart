//
// import 'dart:convert' as convert;
//
// import '../../../common/utils/app_logger.dart';
// import '../../../domain/entities/pro/color_entity.dart';
// import '../../../domain/entities/pro/price_entity.dart';
// import '../base/safe_convert.dart';
//
// class PriceModel extends PriceEntity {
//   PriceModel({
//     int id = 0,
//     int price = 0,
//     String locale = "",
//   }) : super(id: id, price: price, locale: locale);
//
//   factory PriceModel.fromJson(Map<String, dynamic> json) {
//     return PriceModel(
//       id: asT<int>(json, 'id'),
//       price: asT<int>(json, 'price'),
//       locale: asT<String>(json, 'locale'),
//     );
//   }
//
//   factory PriceModel.fromJsonChild(Map<String, dynamic> json) {
//     return PriceModel(
//       id: asT<int>(json, 'id'),
//       price: asT<int>(json, 'price'),
//       locale: asT<String>(json, 'locale'),
//     );
//   }
//
//   static List<PriceModel> fromJsonList(String string) {
//     try {
//       List<dynamic> _json = convert.json.decode(string);
//
//       return _json.map((json) {
//         var a = PriceModel.fromJson(json );
//
//         return a;
//       }).toList();
//     } catch (e) {
//       AppLogger.e('$e');
//       return [];
//     }
//   }
//
//   static ColorEntity toEntity(final ColorEntity item) {
//     return ColorEntity(item.name, id: item.id, locale: item.locale, code: item.code);
//   }
//
//   static ColorEntity fromEntity(final ColorEntity item) {
//     return ColorEntity(item.name, id: item.id, code: item.code, locale: item.locale);
//   }
//
//   Map<String, dynamic> toJson() => {
//         'id': id,
//         'price': price,
//         'locale': locale,
//       };
// }
