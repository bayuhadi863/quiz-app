import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/profile/user_controller.dart';
import 'package:quiz_app/models/category_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/pages/quiz/category_quizzes_page.dart';
import 'package:quiz_app/pages/quiz/quiz_detail_page.dart';
import 'package:quiz_app/repositories/category_repository.dart';
import 'package:quiz_app/repositories/quiz_repository.dart';
import 'package:quiz_app/repositories/user_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';
import 'package:quiz_app/widgets/home/point_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable to store top 4 categories
  List<CategoryModel> categories = [];

  // Variable to store userPoints current day
  List<UserPointModel> currentDayUserPoints = [];

  QuizModel trendingQuiz = QuizModel.empty();
  CategoryModel trendingQuizCategory = CategoryModel.empty();
  UserModel user = UserModel.empty();

  int sumOfPoints = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getCategoryData();
    runFetchCurrentDayUserPoints();
    runGetTrendingQuizData();
  }

  // Function to fetch top 4 category data from repository
  void getCategoryData() async {
    final CategoryRepository categoryRepository = CategoryRepository();
    final List<CategoryModel> data = await categoryRepository.getCategories();

    if (mounted) {
      setState(() {
        // Ambil 4 kategori pertama
        categories = data.take(4).toList();
      });
    }
  }

  Future<void> fetchUserDetails() async {
    final UserModel user = await UserRepository().fetchUserDetails();

    if (mounted) {
      setState(() {
        this.user = user;
      });
    }
  }

  // Function to fetch current day userPoints from QuizRepository
  Future<void> fetchCurrentDayUserPoints() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    // final UserModel user = await UserRepository().fetchUserDetails();
    final QuizRepository quizRepository = QuizRepository();
    List<UserPointModel> data =
        await quizRepository.fetchCurrentDayUserPoints();

    // filter userPoints by user id
    data = data.where((element) => element.userId == user.id).toList();

    if (mounted) {
      setState(() {
        currentDayUserPoints = data;
        isLoading = false;
      });
    }
  }

  // Function to get sum of points from currentDayUserPoints
  void getSumOfPoints() {
    int sum = 0;
    for (int i = 0; i < currentDayUserPoints.length; i++) {
      sum += currentDayUserPoints[i].points;
    }

    if (mounted) {
      setState(() {
        sumOfPoints = sum;
      });
    }
  }

  // Function to fetch trending quiz data from repository
  Future<void> getTrendingQuizData() async {
    final QuizRepository quizRepository = QuizRepository();
    final QuizModel data = await quizRepository.fetchMostPlayedQuiz();

    if (mounted) {
      setState(() {
        trendingQuiz = data;
      });
    }
  }

  // Function to run fethc current day userPoints and getSumOfPoints when the widget initializes
  void runFetchCurrentDayUserPoints() async {
    await fetchUserDetails()
        .then((value) async => await fetchCurrentDayUserPoints())
        .then((value) => getSumOfPoints());
  }

  // Function to get category by name from CategoryRepository
  Future<void> getCategoryByName(String name) async {
    final CategoryRepository categoryRepository = CategoryRepository();
    final CategoryModel data = await categoryRepository.getCategoryByName(name);

    if (mounted) {
      setState(() {
        trendingQuizCategory = data;
      });
    }
  }

  // Function to run getTrendingQuizData and getCategoryByName when the widget initializes
  void runGetTrendingQuizData() async {
    await getTrendingQuizData().then((value) async {
      await getCategoryByName(trendingQuiz.category);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getCategoryData();
          runFetchCurrentDayUserPoints();
          runGetTrendingQuizData();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
            child: Column(
              children: [
                Row(
                  children: [
                    Obx(
                      () => Text(
                        "Welcome back, ${getFirstName(userController.user.value.name)}!",
                        style: const TextStyle(
                          fontSize: 14,
                          color: MyColors.primary,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Text(
                      "Let's play!",
                      style: TextStyle(
                        fontSize: 30,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Point Card
                pointCard(
                    "${currentDayUserPoints.isEmpty ? 0 : currentDayUserPoints.length} quizzes today!",
                    sumOfPoints,
                    1000,
                    context),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Text(
                      "Quiz of the week",
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Trending Quiz Card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trendingQuiz.name,
                              style: const TextStyle(
                                color: MyColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${trendingQuiz.playersCount} players worldwide",
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizDetailPage(
                                      quizId: trendingQuiz.id,
                                    ),
                                  ),
                                ).then((value) {
                                  getCategoryData();
                                  runFetchCurrentDayUserPoints();
                                  runGetTrendingQuizData();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    MyColors.secondary, // Warna teks putih
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Border radius 10
                                ),
                                minimumSize: const Size(
                                    100, 32), // Lebar dan tinggi minimum 100x60
                              ),
                              child: const Text('Play now!'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: trendingQuizCategory.image == ''
                            ? const Text('...')
                            : Image.asset(
                                'assets/images/${trendingQuizCategory.image}',
                                width: 60,
                                height: 60,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Popular categories
                const Row(
                  children: [
                    Text(
                      "Popular categories",
                      style: TextStyle(
                        fontSize: 18,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  primary: false,
                  padding: EdgeInsets.zero,
                  children: List.generate(
                    categories.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoryQuizzesPage(
                                  categoryName: categories[index].name),
                            ),
                          ).then((value) {
                            getCategoryData();
                            runFetchCurrentDayUserPoints();
                            runGetTrendingQuizData();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/${categories[index].image}',
                                  width: 60,
                                  height: 60,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  categories[index].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: MyColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFirstName(String name) {
    return name.split(" ")[0];
  }
}
