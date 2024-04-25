import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quiz_app/repositories/authentication_repository.dart';
import 'package:quiz_app/widgets/alerts.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  /// Email and password sign in
  Future<void> emailAndPasswordSignIn() async {
    try {
      // Form validation
      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      // Loading
      isLoading.value = true;

      // Login user using email & password
      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      Alerts.successSnackBar(
          title: "Login success", message: 'Play many quizzes now!');

      // redirect
      AuthenticationRepository.instance.screenRedirect();

      // Loading
      isLoading.value = false;
    } catch (e) {
      Alerts.errorSnackBar(
        title: 'Oh Snap',
        message: e.toString(),
      );

      // Stop Loading
      isLoading.value = false;
    }
  }
}
