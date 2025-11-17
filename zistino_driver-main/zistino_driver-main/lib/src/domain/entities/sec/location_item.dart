import 'package:hive/hive.dart';

import '../../../common/utils/hive_utils/hive_constants.dart';

part 'location_item.g.dart';

@HiveType(typeId: HiveTypeIdConstants.locationItemTableId)
class LocationItem extends HiveObject {
  @HiveField(0)
  int startLocation;


  LocationItem({required this.startLocation});
}
