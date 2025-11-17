

import '../../../data/models/sec/faq_model.dart';
import '../../entities/sec/faq.dart';

abstract class FaqRepository {
  Future<List<FaqEntity>> fetchFaq(
      {bool isFromLocal = true, String keyword = ''});
}
