import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/pages/authentication/login_page.dart';
import 'package:quiz_app/repositories/authentication_repository.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  void onBoardingCompleted() {
    final storage = GetStorage();
    storage.write('isFirstTime', false);
    Get.offAll(() => const LoginPage());
  }

  void restartOnBoarding() {
    final storage = GetStorage();
    storage.write('isFirstTime', true);
    AuthenticationRepository.instance.screenRedirect();
  }
}
