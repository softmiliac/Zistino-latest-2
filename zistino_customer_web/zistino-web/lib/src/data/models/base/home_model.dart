import 'dart:convert';


import 'package:admin_dashboard/src/data/models/base/safe_convert.dart';

import '../../../domain/entities/base/home_entity.dart';
import '../pro/product_model.dart';


class ProductSectionModel extends ProductSectionEntity {
  ProductSectionModel({
    final int? id,
    final String? name,
    final String? page,
    final String? groupName,
    final int? version,
    final String? productId,
    final String? imagePath,
    required final ProductSectionSettingModel? setting,
    final String? description,
    final String? linkUrl,
    final String? locale,
    final ProductModel? productModel,
  }) : super(
      id: id ?? 0,
      name: name ?? '',
      description: description ?? '',
      locale: locale ?? '',
      productId: productId ?? '',
      version: version ?? 0,
      setting: setting ?? ProductSectionSetting(),
      page: page ?? '',
      linkUrl: linkUrl ?? '',
      imagePath: imagePath ?? '',
      groupName: groupName ?? '',
      productModel: productModel);

  factory ProductSectionModel.fromJson(Map<String, dynamic> json) {
    ProductSectionSettingModel settingModel;
    try {
      var _json = json['setting'];
      if (_json != null) {
        settingModel = ProductSectionSettingModel.fromJson(_json);
      } else {
        settingModel = ProductSectionSettingModel();
      }
    } catch (e) {
      settingModel = ProductSectionSettingModel();
    }
    return ProductSectionModel(
      id: asT<int>(json, 'id'),
      name: asT<String>(json, 'name'),
      page: asT<String>(json, 'page'),
      groupName: asT<String>(json, 'groupName'),
      version: asT<int>(json, 'version'),
      productId: asT<String>(json, 'productId'),
      imagePath: asT<String>(json, 'imagePath'),
      setting: settingModel,
      description: asT<dynamic>(json, 'description'),
      linkUrl: asT<String>(json, 'linkUrl'),
      locale: asT<String>(json, 'locale'),
      productModel:
      ProductModel.fromJson(asT<Map<String, dynamic>>(json, 'extraValues')),
    );
  }

  static List<ProductSectionModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((_json) {
        var a = ProductSectionModel.fromJson(_json);

        return a;
      }).toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'page': page,
    'groupName': groupName,
    'version': version,
    'productId': productId,
    'imagePath': imagePath,
    'setting': setting, //todo
    'description': description,
    'linkUrl': linkUrl,
    'locale': locale,
    'extraValues': productModel?.toJson(),
  };
}

class ProductSectionSettingModel extends ProductSectionSetting {
  // ProductSectionSettingModel(
  //     {this.productSectionType = ProductSectionType.banner, this.expireDate});

  ProductSectionSettingModel({
    final ProductSectionType? productSectionType,
    final DateTime? expireDate,
  }) : super(
      type: productSectionType ?? ProductSectionType.banner,
      expireDate: expireDate);

  factory ProductSectionSettingModel.fromJson(String _json) {
    Map<String, dynamic> input = json.decode(_json);
    // int typeIndex =  as int;
    var date = input['expireDate'];
    return ProductSectionSettingModel(
      productSectionType: ProductSectionType.values[input['type']],
      // productSectionType: asT<ProductSectionType>(input, 'type'),
      expireDate: date != null ? asT<DateTime?>(input, 'expireDate') : null,
    );
  }
}

// enum ProductSectionType { banner, horizontal, countDown, lazy }
