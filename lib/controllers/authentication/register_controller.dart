import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/pages/authentication/verify_email_page.dart';
import 'package:quiz_app/repositories/authentication_repository.dart';
import 'package:quiz_app/repositories/user_repository.dart';
import 'package:quiz_app/widgets/alerts.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> registerFormKey =
      GlobalKey<FormState>(); // form key for form validation
  final isLoading = false.obs;

  /// Signup
  signup() async {
    try {
      // start Loading

      // Check Internet Connectivity

      // Form Validation
      if (!registerFormKey.currentState!.validate()) {
        return;
      }

      // Loading
      isLoading.value = true;

      // Register user in the Firebase Authentication & Save user data in the firestore
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        name: name.text.trim(),
        email: email.text.trim(),
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      // Show Success Message
      Alerts.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailPage(email: email.text.trim()));

      // Stop Loading
      isLoading.value = false;

    } catch (e) {
      // Show some Generic error to the user
      Alerts.errorSnackBar(title: 'Oh, Snap!', message: e.toString());

      // Stop Loading
      isLoading.value = false;
    }
  }
}
