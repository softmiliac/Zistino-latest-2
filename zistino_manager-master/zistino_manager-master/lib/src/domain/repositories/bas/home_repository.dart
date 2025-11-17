

import '../../entities/base/home_entity.dart';

abstract class HomeRepository {
  Future<List<List<ProductSectionEntity>>> getHome({bool isFromLocal =true});
}