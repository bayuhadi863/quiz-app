import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/pages/quiz/quiz_result_page.dart';
import 'package:quiz_app/repositories/quiz_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class QuizStartedPage extends StatefulWidget {
  final QuizModel quiz;

  const QuizStartedPage({super.key, required this.quiz});

  @override
  State<QuizStartedPage> createState() => _QuizStartedPageState();
}

class _QuizStartedPageState extends State<QuizStartedPage> {
  PageController pageController = PageController();

  // variable to store timer
  int minuteLeft = 0;
  int secondLeft = 0;

  // Variable to control selected index
  int selectedIndex = -1;
  List<int> multiSelectedIndex = [];

  // Variable to control loading
  bool isLoading = false;

  // Variable to store user points
  int totalPoints = 0;
  int correctAnswers = 0;

  // Variable to control finish quiz
  bool isFinish = false;

  // Get current user id
  String get userId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    setState(() {
      minuteLeft = widget.quiz.duration;
    });

    // startTimer();
    startTimer();
  }

  // Start timer
  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (isFinish) timer.cancel();

      if (minuteLeft == 0 && secondLeft == 0) {
        // Stop timer
        timer.cancel();

        // Call Insert user points to quiz function
        await insertUserPoints();

        // Move to result page
        moveToResultPage();
      }

      if (secondLeft > 0) {
        setState(() {
          secondLeft--;
        });
      } else {
        setState(() {
          secondLeft = 59;
          minuteLeft--;
        });
      }
    });
  }

  // Function to insert user points to userPoints collection
  Future<void> insertUserPoints() async {
    final UserPointModel userPoint = UserPointModel(
      quizId: widget.quiz.id,
      userId: userId,
      points: totalPoints,
      createdAt: DateTime.now(),
    );

    await QuizRepository().insertUserPoints(userPoint);
  }

  // Function to move to result page
  void moveToResultPage() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: QuizResultPage(
        totalPoints: totalPoints,
        totalQuestions: widget.quiz.questions.length,
        correctAnswers: correctAnswers,
      ),
      withNavBar: false, // OPTIONAL VALUE. True by default.
    );
  }

  Color generateRandomColor(int index) {
    Random random = Random(index);
    int red = random.nextInt(256);
    int green = random.nextInt(256);
    int blue = random.nextInt(256);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Exit'),
              content: const Text('Are you sure you want to exit the quiz?'),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Set border radius here
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    // Insert user points to quiz
                    await insertUserPoints();

                    // Set finish
                    setState(() {
                      isFinish = true;
                    });

                    // Move to result page
                    moveToResultPage();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: MyColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Scaffold(
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          itemBuilder: (context, index) {
            final question = widget.quiz.questions[index];
            return Container(
              color: Colors.black,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${minuteLeft > 0 ? '${minuteLeft}m ' : ''}${secondLeft > 0 ? '${secondLeft}s' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${index + 1}/10',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '$totalPoints Points',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        question.question,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      question.correctAnswer is String
                          ? const Text(
                              '1 correct answer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              '${question.correctAnswer.length} correct answers',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  question.correctAnswer is String
                      ? Column(
                          children: List.generate(
                            question.answers.length,
                            (columnIndex) {
                              // Change the order of answers only one time
                              if (question.answers[0] ==
                                  question.correctAnswer) {
                                question.answers.shuffle();
                              }

                              // Random color by quizz

                              Color backgroundColor =
                                  Colors.primaries[index + 2];

                              return Container(
                                width: double.infinity,
                                // height: 55,

                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ElevatedButton(
                                  onPressed: selectedIndex != -1
                                      ? () {
                                          return;
                                        }
                                      : () async {
                                          setState(() {
                                            selectedIndex = columnIndex;

                                            if (question.answers[columnIndex] ==
                                                question.correctAnswer) {
                                              totalPoints += question.points;
                                              correctAnswers++;
                                            }
                                          });

                                          await Future.delayed(
                                            const Duration(seconds: 1),
                                          );

                                          if (index ==
                                              widget.quiz.questions.length -
                                                  1) {
                                            // Insert user points to quiz
                                            await insertUserPoints();

                                            // Set finish
                                            setState(() {
                                              isFinish = true;
                                            });

                                            // Move to result page
                                            moveToResultPage();
                                          } else {
                                            // Move to next question
                                            pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                            );

                                            setState(() {
                                              selectedIndex = -1;
                                            });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    maximumSize:
                                        const Size(double.infinity, 90),
                                    minimumSize:
                                        const Size(double.infinity, 60),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    foregroundColor: selectedIndex ==
                                                columnIndex &&
                                            question.answers[columnIndex] ==
                                                question.correctAnswer
                                        ? Colors.green[700]
                                        : selectedIndex == columnIndex &&
                                                question.answers[columnIndex] !=
                                                    question.correctAnswer
                                            ? Colors.red[800]
                                            : MyColors.primary,
                                    backgroundColor: selectedIndex ==
                                                columnIndex &&
                                            question.answers[columnIndex] ==
                                                question.correctAnswer
                                        ? Colors.lightGreen[200]
                                            ?.withOpacity(0.8)
                                        : selectedIndex == columnIndex &&
                                                question.answers[columnIndex] !=
                                                    question.correctAnswer
                                            ? Colors.pink[200]?.withOpacity(0.8)
                                            : backgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: selectedIndex == columnIndex &&
                                                  question.answers[
                                                          columnIndex] ==
                                                      question.correctAnswer
                                              ? Colors.green[700]!
                                              : selectedIndex == columnIndex &&
                                                      question.answers[
                                                              columnIndex] !=
                                                          question.correctAnswer
                                                  ? Colors.red[800]!
                                                  : backgroundColor),
                                    ),
                                  ),
                                  child: Text(
                                    question.answers[columnIndex],
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Column(
                          // Multi correctAnswer
                          children: List.generate(
                            question.answers.length,
                            (columnIndex) {
                              // Change the order of answers only one time
                              if (question.answers[0] ==
                                  question.correctAnswer) {
                                question.answers.shuffle();
                              }

                              // rgb Color
                              Color backgroundColor =
                                  Colors.primaries[index + 2];

                              return Container(
                                width: double.infinity,
                                // height: 55,

                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ElevatedButton(
                                  onPressed: multiSelectedIndex.length == 2
                                      ? () {
                                          return;
                                        }
                                      : () async {
                                          setState(() {
                                            if (multiSelectedIndex
                                                .contains(columnIndex)) {
                                              multiSelectedIndex
                                                  .remove(columnIndex);
                                            } else {
                                              multiSelectedIndex
                                                  .add(columnIndex);
                                            }
                                          });

                                          if (multiSelectedIndex.length == 2) {
                                            // check if columnIndex in multiSelectedIndex & check if question.answers[columnIndex] is in question.correctAnswer

                                            if (multiSelectedIndex
                                                    .contains(columnIndex) &&
                                                question.correctAnswer.contains(
                                                    question.answers[
                                                        columnIndex])) {
                                              setState(() {
                                                totalPoints += question.points;
                                                correctAnswers++;
                                              });
                                            }

                                            await Future.delayed(
                                              const Duration(seconds: 1),
                                            );

                                            if (index ==
                                                widget.quiz.questions.length -
                                                    1) {
                                              // Insert user points to quiz
                                              await insertUserPoints();

                                              // Set finish
                                              setState(() {
                                                isFinish = true;
                                              });

                                              // Move to result page
                                              moveToResultPage();
                                            } else {
                                              // Move to next question
                                              pageController.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );

                                              setState(() {
                                                multiSelectedIndex = [];
                                              });
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    maximumSize:
                                        const Size(double.infinity, 90),
                                    minimumSize:
                                        const Size(double.infinity, 60),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    foregroundColor:
                                        // check if columnIndex in multiSelectedIndex & check if question.answers[columnIndex] is in question.correctAnswer
                                        multiSelectedIndex
                                                    .contains(columnIndex) &&
                                                question.correctAnswer.contains(
                                                    question
                                                        .answers[columnIndex])
                                            ? Colors.green[700]
                                            : multiSelectedIndex.contains(
                                                        columnIndex) &&
                                                    !question.correctAnswer
                                                        .contains(
                                                            question.answers[
                                                                columnIndex])
                                                ? Colors.red[800]
                                                : MyColors.primary,
                                    backgroundColor: // check if columnIndex in multiSelectedIndex & check if question.answers[columnIndex] is in question.correctAnswer
                                        multiSelectedIndex
                                                    .contains(columnIndex) &&
                                                question.correctAnswer.contains(
                                                    question
                                                        .answers[columnIndex])
                                            ? Colors.lightGreen[200]
                                                ?.withOpacity(0.8)
                                            : multiSelectedIndex.contains(
                                                        columnIndex) &&
                                                    !question.correctAnswer
                                                        .contains(
                                                            question.answers[
                                                                columnIndex])
                                                ? Colors.pink[200]
                                                    ?.withOpacity(0.8)
                                                : // set color by index
                                                backgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: // check if columnIndex in multiSelectedIndex & check if question.answers[columnIndex] is in question.correctAnswer
                                              multiSelectedIndex.contains(
                                                          columnIndex) &&
                                                      question.correctAnswer
                                                          .contains(
                                                              question.answers[
                                                                  columnIndex])
                                                  ? Colors.green[700]!
                                                  : multiSelectedIndex.contains(
                                                              columnIndex) &&
                                                          !question
                                                              .correctAnswer
                                                              .contains(question
                                                                      .answers[
                                                                  columnIndex])
                                                      ? Colors.red[800]!
                                                      : backgroundColor),
                                    ),
                                  ),
                                  child: Text(
                                    question.answers[columnIndex],
                                    style: const TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            );
          },
          itemCount: widget.quiz.questions.length,
        ),
      ),
    );
  }
}
