import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/authentication/verify_email_controller.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerifyEmailController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/verification_sent.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 80.0,
            ),
            const Text(
              'Verify your email address!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(email ?? ''),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Congratulations! Your Accoint has been created successfully. Please verify your email address to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 40.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => controller.checkEmailVerificationStatus(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(MyColors.primary),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () => controller.sendEmailVerification(),
              child: const Text(
                'Resend email',
                style: TextStyle(color: Color(0xFF080A23)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
