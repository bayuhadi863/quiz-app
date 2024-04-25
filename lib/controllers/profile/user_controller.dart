import 'package:get/get.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/repositories/user_repository.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  // Variables
  Rx<UserModel> user = UserModel.empty().obs;

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  /// Fetch user record
  fetchUserRecord() async {
    try {
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    }
  }
}
