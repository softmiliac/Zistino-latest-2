

import '../../../data/models/base/lazy_rpm.dart';
import '../../entities/base/home_entity.dart';
import '../../entities/inv/driver_delivery.dart';

abstract class HomeRepository {
  Future<List<List<ProductSectionEntity>>> getHome({bool isFromLocal =true});

}