import 'package:flutter/material.dart';
import 'package:quiz_app/models/category_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/repositories/category_repository.dart';
import 'package:quiz_app/repositories/quiz_repository.dart';
import 'package:quiz_app/repositories/user_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';

class CategoryQuizzesPage extends StatefulWidget {
  final String categoryName;

  const CategoryQuizzesPage({super.key, required this.categoryName});

  @override
  State<CategoryQuizzesPage> createState() => _CategoryQuizzesPageState();
}

class _CategoryQuizzesPageState extends State<CategoryQuizzesPage> {
  List<QuizModel> quizzes = [];
  List<UserPointModel> userPoints = [];
  UserModel user = UserModel.empty();
  bool isLoading = false;
  bool addFavoriteLoading = false;
  List<FavoriteQuizModel> favoriteQuizzes = [];

  @override
  void initState() {
    super.initState();
    runAllFunction();
  }

  // Function to fetch quizzes data from repository
  Future<void> getQuizzesData() async {
    final QuizRepository quizRepository = QuizRepository();
    final List<QuizModel> data =
        await quizRepository.getQuizzesByCategoryName(widget.categoryName);
    if (mounted) {
      setState(() {
        quizzes = data;
      });
    }
  }

  // Function to fetch category by name from repository
  Future<CategoryModel> getCategoryData(String categoryName) async {
    final CategoryRepository categoryRepository = CategoryRepository();
    final CategoryModel data =
        await categoryRepository.getCategoryByName(categoryName);

    return data;
  }

  // Function to fetch userPoints from QuizRepository
  Future<void> fetchAllUserPoints() async {
    final QuizRepository quizRepository = QuizRepository();
    final List<UserPointModel> data = await quizRepository.fetchAllUserPoints();

    if (mounted) {
      setState(() {
        userPoints = data;
      });
    }
  }

  // Function to fetch user detail from UserRepository
  Future<void> fetchUserDetails() async {
    final UserModel data = await UserRepository.instance.fetchUserDetails();

    if (mounted) {
      setState(() {
        user = data;
      });
    }
  }

  // Function to fetch favorite quizzes from QuizRepository
  Future<void> fetchFavoriteQuizzes() async {
    final List<FavoriteQuizModel> data =
        await QuizRepository().fetchFavoriteQuizzesByUserId(user.id);

    if (mounted) {
      setState(() {
        favoriteQuizzes = data;
      });
    }
  }

  // Function to run all initial function
  void runAllFunction() async {
    // Start Loading
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    await getQuizzesData()
        .then((value) => fetchUserDetails())
        .then((value) => fetchAllUserPoints())
        .then((value) => fetchFavoriteQuizzes());

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} Quizzes',
          style: const TextStyle(
            color: MyColors.primary,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.grey,
            ))
          : quizzes.isEmpty
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
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      final String quizTitle = quizzes[index].name;
                      final int playersCount = userPoints.isEmpty
                          ? 0
                          : userPoints
                              .where((element) =>
                                  element.quizId == quizzes[index].id)
                              .length;

                      // check if the quiz is played by the user - check if user.id is in the list of userPoints field userId
                      final bool isPlayed = userPoints
                          .where((element) =>
                              element.quizId == quizzes[index].id &&
                              element.userId == user.id)
                          .isNotEmpty;

                      // check if the quiz is favorite by the user - check if user.id is in the list of favoriteQuizzes field userId
                      final bool isFavorite = favoriteQuizzes
                          .where((element) =>
                              element.quizId == quizzes[index].id &&
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
                                  quizId: quizzes[index].id,
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
                                              quizzes[index].language,
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

                                                      if (isFavorite) {
                                                        await QuizRepository()
                                                            .deleteFavoriteQuiz(
                                                                favoriteQuizzes
                                                                    .firstWhere((element) =>
                                                                        element
                                                                            .quizId ==
                                                                        quizzes[index]
                                                                            .id)
                                                                    .id);
                                                      } else {
                                                        FavoriteQuizModel
                                                            favoriteQuiz =
                                                            FavoriteQuizModel(
                                                          quizId:
                                                              quizzes[index].id,
                                                          userId: user.id,
                                                          createdAt:
                                                              DateTime.now(),
                                                        );

                                                        QuizRepository()
                                                            .insertFavoriteQuiz(
                                                                favoriteQuiz);
                                                      }

                                                      setState(() {
                                                        addFavoriteLoading =
                                                            false;
                                                      });

                                                      runAllFunction();
                                                    },
                                              child: Icon(
                                                Icons.favorite,
                                                color: isFavorite
                                                    ? Colors.red[600]
                                                    : Colors.grey,
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
