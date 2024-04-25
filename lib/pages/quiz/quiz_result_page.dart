import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class QuizResultPage extends StatefulWidget {
  final int totalPoints;
  final int totalQuestions;
  final int correctAnswers;

  static bool isFinished = false;

  const QuizResultPage(
      {super.key,
      required this.totalPoints,
      required this.totalQuestions,
      required this.correctAnswers});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.popUntil(context, (route) => route.isFirst);
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: MyColors.primary,
            iconTheme: const IconThemeData(
              color: Colors.white, // Warna tanda panah kembali
            )),
        body: Center(
          child: Container(
            color: MyColors.primary,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Congrats!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    const Text(
                      "YOUR SCORE",
                      style: TextStyle(
                        color: MyColors.secondary,
                        fontSize: 20,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.correctAnswers}/${widget.totalQuestions}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/coin.png",
                              width: 25,
                              height: 25,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "+${widget.totalPoints} points",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Image.asset(
                  "assets/images/trophy.png",
                  width: 190,
                  height: 190,
                ),
                ElevatedButton(
                  onPressed: () {
                    QuizResultPage.isFinished = true;
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MyColors.primary,
                    backgroundColor: MyColors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text("Back to Home"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
