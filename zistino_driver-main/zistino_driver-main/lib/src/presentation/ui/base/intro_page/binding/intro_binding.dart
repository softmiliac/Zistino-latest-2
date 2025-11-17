import 'package:get/get.dart';
import 'package:recycling_machine/src/presentation/ui/base/intro_page/controller/introduction_controller.dart';

class IntroBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => IntroductionController());
  }

}