import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/authentication/onboarding_controller.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      backgroundColor: MyColors.primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Column(
                children: [
                  Text(
                    'Quizard',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.w800),
                  ),
                  Text(
                    '1,000+ quizzes to challenge you on all topics',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/chest.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.onBoardingCompleted(),
                style: ElevatedButton.styleFrom(
                  foregroundColor: MyColors.primary,
                  backgroundColor: MyColors.green, // Warna teks
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Border radius
                  ),
                  minimumSize: const Size(220, 50), // Ukuran minimum button
                ),
                child: const Text('Start playing'), // Teks tombol
              )
            ],
          ),
        ),
      ),
    );
  }
}
