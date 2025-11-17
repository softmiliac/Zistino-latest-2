import 'package:recycling_machine/src/data/models/pro/specification_model.dart';
import '../../../domain/entities/pro/product_entity.dart';
import '../base/safe_convert.dart';
import 'category_model.dart';
import 'colors_model.dart';
import 'dart:convert' as convert;

class ProductModel extends ProductEntity {
  ProductModel({
    final String? id,
    final String? name,
    final String? description,
    final double? rate,
    final List<CategoryModel>? categories,
    final int? viewsCount,
    final int? likesCount,
    final int? commentsCount,
    final int? ordersCount,
    final String? size,
    final bool? isMaster,
    final String? masterId,
    final List<ColorsModel>? colorsList,
    final String? masterColor,
    // final List<PriceModel>? pricesList,
    final int? masterPrice,
    final int? discountPrice,
    final List<String>? imagesList,
    final String? masterImage,
    final String? warranty,  //todo change type
    final SpecificationModel? specifications,
    final List<String>? tags,
    final String? brandId,
    final String? brandName,
    final int? discountPercent,
    final int? inStock,
    final bool? isActive,
    final String? locale,
    final String? tenant,
  }) : super(
      id: id ?? '',
      isActive: isActive ?? false,
      brandName: brandName ?? '',
      locale: locale ?? '',
      description: description ?? '',
      name: name ?? '',
      masterPrice: masterPrice,
      discountPrice: discountPrice,
      masterImage: masterImage ?? '',
      inStock: inStock ?? 0,
      discountPercent: discountPercent ?? 0,
      rate: rate,
      categories: categories ?? [],
      commentsCount: commentsCount,
      likesCount: likesCount,
      isMaster: isMaster ?? false,
      imagesList: imagesList ?? <String>[],
      colorsList: colorsList,
      brandId: brandName ?? '',
      size: size ?? '',
      masterColor: masterColor ?? '',
      masterId: masterId ?? '',
      ordersCount: ordersCount,
      // pricesList: pricesList,
      specifications: specifications,
      tags: tags ?? <String>[],
      tenant: tenant ?? '',
      warranty: warranty ??'');



  static ProductModel fromJsonModel(Map<String, dynamic> json) =>
      ProductModel.fromJson(json);

  factory ProductModel.fromJson(Map<String, dynamic>? json) {

    List<CategoryModel> categoryModel;
    try {
      var _jsonCategory = json?['categories'];
      var a  = convert.json.decode(_jsonCategory);
      if (a != null) {
        categoryModel = CategoryModel.fromJsonList(a);
      } else {
        categoryModel = <CategoryModel>[];
      }
    } catch (e) {
      categoryModel = <CategoryModel>[];
    }

    List<ColorsModel> colorsModel;
    try {
      var _jsonColor = json?['colorsList'];
      if (_jsonColor != null) {
        colorsModel = ColorsModel.fromJsonList(_jsonColor);
      } else {
        colorsModel = [];
      }
    } catch (e) {
      colorsModel =[];
    }

    // List<PriceModel> priceModel;
    // try {
    //   var _jsonPrice = json?['pricesList'];
    //   if (_jsonPrice != null) {
    //     priceModel = PriceModel.fromJsonList(_jsonPrice);
    //   } else {
    //     priceModel = [];
    //   }
    // } catch (e) {
    //   priceModel =[];
    // }

    SpecificationModel specificationModel;
    try {
      var _jsonSpecification = json?['specifications'];
      if (_jsonSpecification != null) {
        specificationModel = SpecificationModel.fromJsonString(_jsonSpecification);
      } else {
        specificationModel = SpecificationModel();
      }
    } catch (e) {
      specificationModel = SpecificationModel();
    }

    return ProductModel(
      id: asT<String>(json, 'id'),
      name: asT<String>(json, 'name'),
      description: asT<String>(json, 'description'),
      rate: asT<double>(json, 'rate'),
      categories: categoryModel,
      viewsCount: asT<int>(json, 'viewsCount'),
      likesCount: asT<int>(json, 'likesCount'),
      commentsCount: asT<int>(json, 'commentsCount'),
      ordersCount: asT<int>(json, 'ordersCount'),
      size: asT<String>(json, 'size'),
      isMaster: asT<bool>(json, 'isMaster'),
      masterId: asT<String>(json, 'masterId'),
      colorsList: colorsModel,
      masterColor: asT<String>(json, 'masterColor'),
      // pricesList: priceModel,
      masterPrice: asT<int>(json, 'masterPrice',defaultValue: 0),
      discountPrice: asT<int>(json, 'discountPrice',defaultValue: 0),
      imagesList: asT<List<String>>(json, 'imagesList',defaultValue: <String>[]),
      masterImage: asT<String>(json, 'masterImage'),
      warranty: asT<String>(json, 'warranty'),
      specifications: specificationModel,
      tags: asT<List<String>>(json, 'tags',defaultValue: <String>[]),
      brandId: asT<String>(json, 'brandId'),
      brandName: asT<String>(json, 'brandName'),
      discountPercent: asT<int>(json, 'discountPercent'),
      inStock: asT<int>(json, 'inStock'),
      isActive: asT<bool>(json, 'isActive'),
      locale: asT<String>(json, 'locale'),
      tenant: asT<String>(json, 'tenant'),
    );
  }

  static List<ProductModel> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => ProductModel.fromJson(json)).toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'rate': rate,
    'categories': categories,
    'likesCount': likesCount,
    'commentsCount': commentsCount,
    'ordersCount': ordersCount,
    'size': size,
    'isMaster': isMaster,
    'masterId': masterId,
    'colorsList': colorsList,
    'masterColor': masterColor,
    'pricesList': pricesList,
    'masterPrice': masterPrice,
    'discountPrice': discountPrice,
    'imagesList': imagesList,
    'masterImage': masterImage,
    'warranty': warranty,
    'specifications': specifications,
    'tags': tags,
    'brandId': brandId,
    'brandName': brandName,
    'discountPercent': discountPercent,
    'inStock': inStock,
    'isActive': isActive,
    'locale': locale,
    'tenant': tenant,
  };
}
