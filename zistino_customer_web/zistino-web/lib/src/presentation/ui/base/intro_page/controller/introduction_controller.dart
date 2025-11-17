import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

import '../../../../../domain/entities/base/introduction_model.dart';

class IntroductionController extends GetxController {
  /// Variable ///

  final CarouselController buttonCarouselController = CarouselController();

  final currentIndex = 0.obs;

  List<IntroductionModel> introData = [];

  /// Functions ///

  @override
  void onInit() {
    getIntroData();
    super.onInit();
  }

  Future getIntroData() async {
    introData = introductionData();
    return introData;
  }
}
