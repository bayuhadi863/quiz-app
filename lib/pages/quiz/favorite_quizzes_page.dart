import 'package:flutter/material.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/repositories/quiz_repository.dart';
import 'package:quiz_app/repositories/user_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class FavoriteQuizzesPage extends StatefulWidget {
  const FavoriteQuizzesPage({super.key});

  @override
  State<FavoriteQuizzesPage> createState() => _FavoriteQuizzesPageState();
}

class _FavoriteQuizzesPageState extends State<FavoriteQuizzesPage> {
  UserModel user = UserModel.empty();
  List<QuizModel> favoriteQuizzes = [];
  List<FavoriteQuizModel> favoriteQuizzesModel = [];
  List<UserPointModel> userPoints = [];
  bool addFavoriteLoading = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    runAllFunction();
  }

  // Function to fetch all quizzes from QuizRepository
  Future<void> fetchAllQuizzes() async {
    final List<QuizModel> data = await QuizRepository().fetchAllQuizzes();

    // Filter quizzes that id in favoriteQuizzesModel quizId and set tu favoriteQuizzes state
    final List<QuizModel> favoriteQuizzesData = data
        .where((element) =>
            favoriteQuizzesModel.map((e) => e.quizId).contains(element.id))
        .toList();

    setState(() {
      favoriteQuizzes = favoriteQuizzesData;
    });
  }

  // Function to fetch user details from UserRepository
  Future<void> fetchUserDetails() async {
    final UserModel data = await UserRepository.instance.fetchUserDetails();
    setState(() {
      user = data;
    });
  }

  // Function to fetch favorite quizzes from QuizRepository
  Future<void> fetchFavoriteQuizzes() async {
    final List<FavoriteQuizModel> data =
        await QuizRepository().fetchFavoriteQuizzesByUserId(user.id);
    setState(() {
      favoriteQuizzesModel = data;
    });
  }

  // Function to fetch userPoints from QuizRepository
  Future<void> fetchAllUserPoints() async {
    final QuizRepository quizRepository = QuizRepository();
    final List<UserPointModel> data = await quizRepository.fetchAllUserPoints();
    setState(() {
      userPoints = data;
    });
  }

  // Function to run all initial function
  void runAllFunction() async {
    // Start Loading
    setState(() {
      isLoading = true;
    });
    await fetchUserDetails()
        .then((value) => fetchFavoriteQuizzes())
        .then((value) => fetchAllQuizzes())
        .then((value) => fetchAllUserPoints());

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorite Quizzes',
          style: TextStyle(color: MyColors.primary),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.grey,
            ))
          : favoriteQuizzes.isEmpty
              ? Center(
                  child: Text(
                    'No quizzes found',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    runAllFunction();
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: favoriteQuizzes.length,
                    itemBuilder: (context, index) {
                      final String quizTitle = favoriteQuizzes[index].name;
                      final int playersCount = userPoints.isEmpty
                          ? 0
                          : userPoints
                              .where((element) =>
                                  element.quizId == favoriteQuizzes[index].id)
                              .length;

                      // check if the quiz is played by the user - check if user.id is in the list of userPoints field userId
                      final bool isPlayed = userPoints
                          .where((element) =>
                              element.quizId == favoriteQuizzes[index].id &&
                              element.userId == user.id)
                          .isNotEmpty;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 20),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to Quiz Detail Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizDetailPage(
                                  quizId: favoriteQuizzes[index].id,
                                ),
                              ),
                            ).then((value) => runAllFunction());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quizTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '$playersCount players',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                            ),
                                            child: Text(
                                              favoriteQuizzes[index].language,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: MyColors.primary,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey[300]!),
                                            ),
                                            child: GestureDetector(
                                              onTap: addFavoriteLoading
                                                  ? null
                                                  : () async {
                                                      // Add to favorite

                                                      setState(() {
                                                        addFavoriteLoading =
                                                            true;
                                                      });

                                                      await QuizRepository()
                                                          .deleteFavoriteQuiz(
                                                              favoriteQuizzesModel[
                                                                      index]
                                                                  .id);

                                                      setState(() {
                                                        addFavoriteLoading =
                                                            false;
                                                      });

                                                      runAllFunction();
                                                    },
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.red[600],
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          isPlayed
                                              ? GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color:
                                                            Colors.grey[300]!,
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                      size: 18,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
