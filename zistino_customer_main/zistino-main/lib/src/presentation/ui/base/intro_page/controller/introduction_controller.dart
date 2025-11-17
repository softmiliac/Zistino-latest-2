import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

import '../../../../../../fake_model/introduction_model.dart';
import '../../../../../data/providers/fake_data.dart';

class IntroductionController extends GetxController {
  /// Variable ///
  RxDouble newSize = 0.0.obs;

  final CarouselController buttonCarouselController = CarouselController();

  final currentIndex = 0.obs;

  List<IntroductionModel> introData = [];

  /// Functions ///

  @override
  void onInit() {
    newSize.value = Get.width/46/6;

    getIntroData();
    super.onInit();
  }

  Future getIntroData() async {
    introData = introductionData();
    return introData;
  }
}
