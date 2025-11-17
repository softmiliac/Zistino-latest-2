import 'package:get/get.dart';

import '../../../../../data/repositories/sec/user_repository.dart';
import '../../../../../domain/usecases/sec/user_usecase.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController());
  }

}