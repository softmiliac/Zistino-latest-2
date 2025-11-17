// import 'package:oxygen/newSrc/common/utils/app_logger.dart';
// import 'package:oxygen/src/common/utils/safe_convert.dart';
//
// import '../../../domain/entities/pro/warranties_entity.dart';
// import 'dart:convert' as convert;
//
// class WarrantiesModel extends WarrantiesEntity {
//   WarrantiesModel({
//     final int? id,
//     final String? name,
//     final String? imageUrl,
//     final String? description,
//     final String? locale}) :super(
//     id: id ?? 0,
//     name: name ?? "",
//     imageUrl: imageUrl ?? "",
//     description: description ?? "",
//     locale: locale ?? "",
//   );
//
//
//   factory WarrantiesModel.fromJson(Map<String, dynamic>? json) =>
//       WarrantiesModel(
//         id: asT<int>(json, 'id'),
//         name: asT<String>(json, 'name'),
//         imageUrl: asT<String>(json, 'imageUrl'),
//         description: asT<String>(json, 'description'),
//         locale: asT<String>(json, 'locale'),
//       );
//   static WarrantiesModel fromJsonString(String string) {
//     try{
//       Map<String, dynamic>? _json = convert.json.decode(string);
//       return WarrantiesModel.fromJson(_json ?? {});
//
//     }catch(e){
//       AppLogger.e('$e');
//       throw('$e');
//     }
//
//   }
//   static WarrantiesModel fromJsonModel(Map<String, dynamic> json) =>
//       WarrantiesModel.fromJson(json);
//   Map<String, dynamic> toJson() =>
//       {
//         'id': id,
//         'name': name,
//         'imageUrl': imageUrl,
//         'description': description,
//         'locale': locale,
//       };
// }
//
