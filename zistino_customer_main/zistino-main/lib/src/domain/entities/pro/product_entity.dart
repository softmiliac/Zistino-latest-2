import 'package:zistino/src/domain/entities/pro/price_entity.dart';

import '../../../data/models/pro/category_model.dart';
import '../../../data/models/pro/specification_model.dart';
import 'color_entity.dart';

class ProductEntity {
  final String id;
  final String name;
  final String description;
  final double? rate;

  final List<CategoryModel> categories;
  final int? likesCount;
  final int? commentsCount;
  final int? ordersCount;
  final String size;
  final bool isMaster;
  final String? masterId;
  final List<ColorEntity>? colorsList;
  final String masterColor;
  final List<PriceEntity>? pricesList;
  final int? masterPrice;
  final int? discountPrice;
  final List<String> imagesList;
  final String masterImage;
  final String warranty;
  final SpecificationModel? specifications;
  final List<String> tags;
  final String brandId;
  final String brandName;
  final int discountPercent;
  final int inStock;
  final bool isActive;
  final String locale;
  final String tenant;

  ProductEntity(
      {this.id = "",
      this.name = "",
      this.description = "",
      this.rate = 0.0,
      this.brandId = "",
      this.locale = "",
      this.discountPercent = 0,
      this.inStock = 0,
      this.commentsCount = 0,
      this.imagesList = const <String>[],
      this.isMaster = false,
      this.likesCount = 0,
      // this.localeID = 0,
      this.masterColor = '',
      this.masterId = '',
      this.masterImage = '',
      this.masterPrice = 0,
      this.discountPrice = 0,
      this.isActive = false,
      this.brandName = '',
      this.ordersCount = 0,
      this.pricesList,
      this.colorsList,
      this.size = '',
      this.specifications,
      this.tags = const <String>[],
      this.categories = const [],
      this.warranty = '',
      this.tenant = ''});
}
