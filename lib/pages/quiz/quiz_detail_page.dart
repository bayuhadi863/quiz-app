import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:quiz_app/data/data.dart';
import 'package:quiz_app/models/category_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/pages/quiz/quiz_started_page.dart';
import 'package:quiz_app/repositories/category_repository.dart';
import 'package:quiz_app/repositories/quiz_repository.dart';
import 'package:quiz_app/repositories/user_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';
import 'package:quiz_app/widgets/profile_avatar.dart';

class QuizDetailPage extends StatefulWidget {
  final String quizId;
  // final CategoryModel category;

  const QuizDetailPage({super.key, required this.quizId});

  @override
  State<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  QuizModel quiz = QuizModel.empty();
  CategoryModel category = CategoryModel.empty();
  List<UserPointModel> userPoints = [];
  UserModel user = UserModel.empty();
  List<FavoriteQuizModel> favoriteQuizzes = [];
  bool isPlayed = false;

  bool isLoading = false;
  bool addFavoriteLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to execute all fetch functions
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    await getQuizData()
        .then((value) async => await getCategoryData())
        .then((value) async => await fetchUserPoints())
        .then((value) async => await fetchUserDetails())
        .then((value) async => await checkIfPlayed())
        .then((value) async => await fetchFavoriteQuizzes());

    setState(() {
      isLoading = false;
    });
  }

  // Function to fetch quiz by quizId from repository
  Future<void> getQuizData() async {
    final QuizRepository quizRepository = QuizRepository();
    final QuizModel data = await quizRepository.fetchQuizById(widget.quizId);
    setState(() {
      quiz = data;
    });
  }

  // Function to fetch category by name from repository
  Future<void> getCategoryData() async {
    final CategoryRepository categoryRepository = CategoryRepository();
    final CategoryModel data =
        await categoryRepository.getCategoryByName(quiz.category);
    setState(() {
      category = data;
    });
  }

  // Function to fetch userPoints by quizId from QuizRepository
  Future<void> fetchUserPoints() async {
    final QuizRepository quizRepository = QuizRepository();
    final List<UserPointModel> data =
        await quizRepository.fetchUserPointsByQuizId(quiz.id);

    // Sort userPoints by points
    data.sort((a, b) => b.points.compareTo(a.points));

    setState(() {
      userPoints = data;
    });
  }

  // Function to check if user has played the quiz from QuizRepository
  Future<void> checkIfPlayed() async {
    final QuizRepository quizRepository = QuizRepository();
    final bool data = await quizRepository.hasUserPlayedQuiz(quiz.id, user.id);
    setState(() {
      isPlayed = data;
    });
  }

  // Function to fetch user detail from UserRepository
  Future<void> fetchUserDetails() async {
    final UserModel data = await UserRepository.instance.fetchUserDetails();
    setState(() {
      user = data;
    });
  }

  // Function to fetch favorite quizzes by userId from QuizRepository
  Future<void> fetchFavoriteQuizzes() async {
    final QuizRepository quizRepository = QuizRepository();
    final List<FavoriteQuizModel> data =
        await quizRepository.fetchFavoriteQuizzesByUserId(user.id);
    setState(() {
      favoriteQuizzes = data;
    });
  }

  // Function to check if quiz is in favorite list
  bool isFavorite() {
    return favoriteQuizzes.any((element) => element.quizId == quiz.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.grey[400]!,
              ),
            )
          : quiz.name == ''
              ? Center(
                  child: Text(
                    'No quiz found',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    fetchData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: MyColors.primary,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            child: Center(
                              child: Image.asset(
                                'assets/images/${category.image}',
                                width: 70,
                                height: 70,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.name,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.primary,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  buildBox("${quiz.questions.length} questions",
                                      "assets/images/question.png"),
                                  buildBox("+${quiz.totalPoints} points",
                                      "assets/images/coin.png"),
                                  buildBox("${quiz.duration} minutes",
                                      "assets/images/duration2.png"),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${userPoints.isEmpty ? "0" : userPoints.length} players',
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
                                          quiz.language,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: MyColors.primary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
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
                                                    addFavoriteLoading = true;
                                                  });

                                                  if (isFavorite()) {
                                                    await QuizRepository()
                                                        .deleteFavoriteQuiz(
                                                            favoriteQuizzes
                                                                .firstWhere(
                                                                    (element) =>
                                                                        element
                                                                            .quizId ==
                                                                        quiz.id)
                                                                .id);
                                                  } else {
                                                    FavoriteQuizModel
                                                        favoriteQuiz =
                                                        FavoriteQuizModel(
                                                      quizId: quiz.id,
                                                      userId: user.id,
                                                      createdAt: DateTime.now(),
                                                    );

                                                    QuizRepository()
                                                        .insertFavoriteQuiz(
                                                            favoriteQuiz);
                                                  }

                                                  setState(() {
                                                    addFavoriteLoading = false;
                                                  });

                                                  fetchData();
                                                },
                                          child: Icon(
                                            Icons.favorite,
                                            color: isFavorite()
                                                ? Colors.red[600]
                                                : Colors.grey,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      isPlayed
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    color: Colors.grey[300]!),
                                              ),
                                              child: const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                  size: 17),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                quiz.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: MyColors.primary,
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Quiz leaderboard",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: userPoints.length,
                                itemBuilder: (context, index) {
                                  return FutureBuilder<UserModel>(
                                    future: UserRepository.instance
                                        .fetchUserById(
                                            userPoints[index].userId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container(); // Placeholder saat data sedang dimuat
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}'); // Placeholder untuk penanganan kesalahan
                                      } else {
                                        UserModel userDetail = snapshot.data!;
                                        return leaderboardListItems(
                                          '#${index + 1}',
                                          userDetail.name,
                                          userPoints[index].points.toString(),
                                          40,
                                          20,
                                          15,
                                          userPoints[index].userId,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? null
          : isPlayed
              ? null
              : Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FloatingActionButton.extended(
                    label: const Text(
                      'Start Quiz',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: isLoading
                        ? null
                        : isPlayed
                            ? null
                            : () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: QuizStartedPage(quiz: quiz),
                                  withNavBar:
                                      false, // OPTIONAL VALUE. True by default.
                                ).then((value) => fetchData());
                              },
                    // child: const Icon(Icons.add, color: Colors.white, size: 25),
                  ),
                ),
    );
  }
}

Container buildBox(String text, String imagePath) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey[300]!),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
    width: 96,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: 30,
          height: 30,
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: MyColors.primary,
          ),
        ),
      ],
    ),
  );
}

Container leaderboardListItems(
  String rank,
  String name,
  String totalPoints,
  double imageSize,
  double avatarRadius,
  double avatarFontSize,
  String userId,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Data.currentUserId == userId
          ? Colors.lightBlue[50]?.withOpacity(0.5)
          : Colors.white,
      border: Border.all(
          color: Data.currentUserId == userId
              ? MyColors.secondary
              : Colors.grey[300]!),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              rank,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MyColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            profileAvatar(
              name,
              avatarRadius,
              avatarFontSize,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: MyColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$totalPoints points',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
