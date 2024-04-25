import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class VerifySuccessPage extends StatelessWidget {
  const VerifySuccessPage({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/verification_success.png',
              width: 150, // You can adjust this as needed
              height: 150, // You can adjust this as needed
            ),
            const SizedBox(
              height: 80.0,
            ),
            const Text(
              'Your accound is verified!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Welcome to Quizard!. Your account has been verified successfully. Let\'s start learning and having fun with quizzes',
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
                onPressed: onPressed,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      MyColors.primary), // Set the background color to black
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        15,
                      ), // Set the border radius to 0 to remove the border
                    ),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
