import 'package:get/get.dart';

import '../../../../../data/repositories/sec/faq_repository.dart';
import '../../../../../domain/usecases/sec/faq_usecase.dart';
import 'faq_controller.dart';

class FAQBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FetchAllFaqUseCase(Get.find<FaqRepositoryImpl>()));
    Get.lazyPut(() => FAQController(Get.find()));
  }
}