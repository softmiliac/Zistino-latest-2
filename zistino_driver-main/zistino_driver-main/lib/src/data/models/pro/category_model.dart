
import 'dart:convert' as convert;

import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/pro/category_entity.dart';
import '../../enums/pro/category_type.dart';
import '../base/safe_convert.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel(
      {int id = 0,
      int? parentId,
      String name = "",
      String description = "",
      String imagePath = "",
      CategoryType type = CategoryType.product,
      List<CategoryModel?>? children})
      : super(name : name,
            id: id,
            parentId: parentId,
            description: description,
            imagePath: imagePath,
            type: type,
            children: children);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var _jsonChildren = json['children'];
    List<CategoryModel> children = fromJsonListChildren(_jsonChildren);


    return CategoryModel(
        id: asT<int>(json, 'id'),
        parentId: asT<int>(json, 'parentId'),
        name: asT<String>(json, 'name'),
        imagePath: asT<String>(json, 'imagePath'),
        children: children);
  }

  factory CategoryModel.fromJsonChild(Map<String, dynamic> json) {

    return CategoryModel(
        id: asT<int>(json, 'id'),
        parentId: asT<int>(json, 'parentId'),
        imagePath: asT<String>(json, 'imagePath'),
        name: asT<String>(json, 'name'),
        children: []);
  }

  static List<CategoryModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) {
        var a = CategoryModel.fromJson(json);

        return a;
      }).toList();

  static CategoryModel fromJsonString(String string) {
    try{
      Map<String, dynamic>? _json = convert.json.decode(string);
      return CategoryModel.fromJson(_json ?? {});

    }catch(e){
      AppLogger.e('$e');
    throw('$e');
    }

  }

  static List<CategoryModel> fromJsonListChildren(List<dynamic>? jsonList) =>
      jsonList?.map((json) => CategoryModel.fromJsonChild(json)).toList() ?? [];

  static CategoryEntity toEntity(final CategoryEntity item) {
    return CategoryEntity(
      name: item.name,
        id: item.id,
        type: item.type,
        parentId: item.parentId,
        imagePath: item.imagePath,
        description: item.description,
        children: item.children);
  }

  static CategoryEntity fromEntity(final CategoryEntity item) {
    return CategoryEntity(
      name: item.name,
        id: item.id,
        type: item.type,
        parentId: item.parentId,
        imagePath: item.imagePath,
        description: item.description,
        children: item.children);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentId': parentId,
        'name': name,
        'imagePath': imagePath,
        'children': children!.map((e) => e),
      };
}
