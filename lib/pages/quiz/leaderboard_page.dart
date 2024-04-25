import 'package:flutter/material.dart';
import 'package:quiz_app/data/data.dart';
import 'package:quiz_app/models/leaderboard_model.dart';
import 'package:quiz_app/repositories/leaderboard_repository.dart';
import 'package:quiz_app/utils/constants/colors.dart';
import 'package:quiz_app/widgets/profile_avatar.dart';

class LeaderboardPage extends StatefulWidget {
  static List<LeaderboardModel> leaderboardList = [];

  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  // Variable to store leaderboard list
  List<LeaderboardModel> leaderboardList = [];

  // Variable to store loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Call getLeaderboardData function when the widget initializes
    getLeaderboardData();
  }

  // Function to fetch leaderboard data from repository
  getLeaderboardData() async {
    // Start Loading
    setState(() {
      isLoading = true;
    });

    // Call fetchLeaderboardData function from repository
    final List<LeaderboardModel> data =
        await LeaderboardRepository().fetchLeaderboardData();

    setState(() {
      leaderboardList = data;
      isLoading = false;
    });
  }

  // Function to get width of the screen percent
  double getWidthPercent(BuildContext context, double dividen, double divider) {
    return MediaQuery.of(context).size.width * (dividen / divider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          getLeaderboardData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 55),
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Leaderboard",
                      style: TextStyle(
                        fontSize: 30,
                        color: MyColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
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
                    : leaderboardList.isEmpty
                        ? Center(
                            child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * (1 / 3),
                            ),
                            child: Text(
                              'No categories found',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ))
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Kotak Kiri
                                  topThreeCard(
                                    getWidthPercent(context, 1, 4),
                                    '#2',
                                    leaderboardList[1].name,
                                    leaderboardList[1].totalPoints.toString(),
                                    50,
                                    27,
                                    20,
                                    leaderboardList[1].userId,
                                  ),
                                  const SizedBox(width: 7),
                                  // Kotak Tengah
                                  topThreeCard(
                                    getWidthPercent(context, 1, 3),
                                    '#1',
                                    leaderboardList[0].name,
                                    leaderboardList[0].totalPoints.toString(),
                                    80,
                                    37,
                                    30,
                                    leaderboardList[0].userId,
                                  ),
                                  const SizedBox(width: 7),
                                  // Kotak Kanan
                                  topThreeCard(
                                    getWidthPercent(context, 1, 4),
                                    '#3',
                                    leaderboardList[2].name,
                                    leaderboardList[2].totalPoints.toString(),
                                    50,
                                    27,
                                    20,
                                    leaderboardList[2].userId,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              for (int i = 3; i < leaderboardList.length; i++)
                                leaderboardListItems(
                                  '#${i + 1}',
                                  leaderboardList[i].name,
                                  leaderboardList[i].totalPoints.toString(),
                                  40,
                                  20,
                                  15,
                                  leaderboardList[i].userId,
                                ),
                            ],
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Container topThreeCard(
  double width,
  String rank,
  String name,
  String totalPoints,
  double imageSize,
  double avatarRadius,
  double avatarFontSize,
  String userId,
) {
  // Function to get first name and first word of last name from full name
  String getFirstName(String fullName) {
    final List<String> nameList = fullName.split(' ');
    if (nameList.length > 1) {
      // Jika nama terdiri dari lebih dari satu kata
      return '${nameList[0]} ${nameList[1][0]}.';
    } else {
      // Jika nama hanya terdiri dari satu kata
      return nameList[0];
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    width: width,
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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          rank,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: MyColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        profileAvatar(
          name,
          avatarRadius,
          avatarFontSize,
        ),
        const SizedBox(height: 10),
        Text(
          getFirstName(name),
          style: const TextStyle(
            fontSize: 14,
            color: MyColors.primary,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
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
