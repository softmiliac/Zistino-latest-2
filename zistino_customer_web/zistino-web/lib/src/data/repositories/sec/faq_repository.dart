
import '../../../common/utils/app_logger.dart';
import '../../../domain/entities/sec/faq.dart';
import '../../../domain/repositories/sec/faq_repository.dart';
import '../../models/base/base_response.dart';
import '../../models/sec/faq_model.dart';
import '../../providers/remote/sec/faq_api.dart';


class FaqRepositoryImpl extends FaqRepository {
  @override
  Future<List<FaqEntity>> fetchFaq({bool isFromLocal = false, String keyword = ''}) async{
    try {
      BaseResponse response = await FaqAPI().fetch(keyword);

      return FaqModel.fromJsonList(response.data as List);
    } catch (e) {
      AppLogger.catchLog(e);
      rethrow;
    }
  }
}
