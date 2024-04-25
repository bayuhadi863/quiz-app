import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app/models/leaderboard_model.dart';
import 'package:quiz_app/models/quiz_model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/pages/quiz/favorite_quizzes_page.dart';
import 'package:quiz_app/repositories/authentication_repository.dart';
import 'package:quiz_app/repositories/leaderboard_repository.dart';
import 'package:quiz_app/repositories/quiz_repository.dart';
import 'package:quiz_app/repositories/user_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';
import 'package:quiz_app/widgets/profile_avatar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel user = UserModel.empty();
  List<LeaderboardModel> leaderboard = [];
  int totalPoints = 0;
  int quizzesPlayed = 0;
  bool isLoading = false;
  List<FavoriteQuizModel> favoriteQuizzes = [];

  @override
  void initState() {
    super.initState();
    runAllFunction();
  }

  // Function to fetch user detals from UserRepository
  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    final UserRepository userRepository = UserRepository();
    final UserModel data = await userRepository.fetchUserDetails();
    setState(() {
      user = data;
      isLoading = false;
    });
  }

  // Function to fetch total points by userId from LeaderboardRepository
  Future<void> fetchTotalPoints() async {
    final int data = await LeaderboardRepository().fetchTotalPoints(user.id);
    setState(() {
      totalPoints = data;
    });
  }

  // Function to fetch number of quiz played by userId from QuizRepository
  Future<void> fetchQuizzesPlayed() async {
    final int data = await QuizRepository().fetchNumberOfQuizPlayed(user.id);
    setState(() {
      quizzesPlayed = data;
    });
  }

  // Function to fetch leaderboard data from LeaderboardRepository
  Future<void> fetchLeaderboardData() async {
    final List<LeaderboardModel> data =
        await LeaderboardRepository().fetchLeaderboardData();

    if (mounted) {
      setState(() {
        leaderboard = data;
      });
    }
  }

  // Function to get user position from leaderboard
  int getUserPosition() {
    int position = 0;
    for (int i = 0; i < leaderboard.length; i++) {
      if (leaderboard[i].userId == user.id) {
        position = i + 1;
      }
    }
    return position;
  }

  // Function to fetch favorite quizzes from QuizRepository
  Future<void> fetchFavoriteQuizzes() async {
    final List<FavoriteQuizModel> data =
        await QuizRepository().fetchFavoriteQuizzesByUserId(user.id);
    setState(() {
      favoriteQuizzes = data;
    });
  }

  // Function to run all function while widget initialized
  void runAllFunction() async {
    await fetchUserData()
        .then((value) => fetchTotalPoints())
        .then((value) => fetchQuizzesPlayed())
        .then((value) => fetchLeaderboardData())
        .then((value) => fetchFavoriteQuizzes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          runAllFunction();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 30,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * (1 / 3),
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : user.id == ''
                        ? Center(
                            child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * (1 / 3),
                            ),
                            child: Text(
                              'No user found',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ))
                        : Column(
                            children: [
                              profileAvatar(user.name, 45, 30),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user.name,
                                    style: const TextStyle(
                                      color: MyColors.primary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      openEditFormDialog();
                                    },
                                    child: const Icon(Icons.edit,
                                        size: 18, color: Colors.grey),
                                  )
                                ],
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  color: MyColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  recapCard('#${getUserPosition()}',
                                      'World rank', 'rank.png'),
                                  const SizedBox(width: 10),
                                  recapCard(quizzesPlayed.toString(),
                                      'Quizzes played', 'quiz.png'),
                                  const SizedBox(width: 10),
                                  recapCard(totalPoints.toString(),
                                      'Points total', 'coin.png'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FavoriteQuizzesPage(),
                                    ),
                                  ).then((value) => runAllFunction());
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.favorite_border,
                                            color: MyColors.primary,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Favorite quizzes (${favoriteQuizzes.length})',
                                            style: const TextStyle(
                                              color: MyColors.primary,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: MyColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await AuthenticationRepository().logout();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.red[600],
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.red[600],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 18, color: Colors.red[600]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future openEditFormDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: TextEditingController(text: user.name),
            onChanged: (value) {
              user.name = value;
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Set border radius here
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await UserRepository().updateName(user.name);
                Navigator.pop(context);
                runAllFunction();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: MyColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      );
}

Expanded recapCard(String value, String label, String image) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey[300]!,
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            'assets/images/$image',
            height: 35,
            width: 35,
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            value,
            style: const TextStyle(
              color: MyColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: MyColors.primary.withOpacity(0.6),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
