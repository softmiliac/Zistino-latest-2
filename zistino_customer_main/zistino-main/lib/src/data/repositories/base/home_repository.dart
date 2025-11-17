import 'package:zistino/src/data/models/base/lazy_rpm.dart';
import 'package:zistino/src/data/models/base/lazy_rqm.dart';
import 'package:zistino/src/domain/entities/inv/driver_delivery.dart';
import 'package:get/get.dart';

import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/base/home_entity.dart';
import '../../../domain/repositories/bas/home_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/inv/driver_delivery_model.dart';
import '../../providers/remote/base/home_api.dart';
import '../../providers/remote/inv/driver_delivery_api.dart';

class HomeRepositoryImpl extends HomeRepository {
  @override
  Future<List<List<ProductSectionEntity>>> getHome({bool isFromLocal = false}) async {
    LocalStorageService _pref = Get.find();
    try {
      List data = [];
      if (isFromLocal) {
      } else {
        BaseResponse response = await HomeApi().fetchHome();
        data = response.data as List;
        _pref.setHome(data);
      }
      return _pref.getHome;
    } catch (e) {
      AppLogger.e('$e');
      rethrow;
    }
  }

}
