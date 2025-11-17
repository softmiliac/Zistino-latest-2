import 'package:admin_zistino/src/domain/entities/base/driver_delivery.dart';
import '../../../data/models/base/base_response.dart';
import '../../../data/models/base/driver_delivery_model.dart';
import '../../../data/models/base/lazy_rpm.dart';
import '../../../data/models/base/lazy_rqm.dart';
import '../../../data/models/inv/delete_driver_delivery_rqm.dart';
import '../../entities/base/driver_entity.dart';
import '../../entities/sec/order_entity.dart';

abstract class DriverRepository {
  Future<List<DriverEntity>> fetchDriver(LazyRQM rqm);
}