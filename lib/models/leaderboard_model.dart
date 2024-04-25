import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardModel {
  String userId;
  String name;
  int totalPoints;

  LeaderboardModel({
    required this.userId,
    required this.totalPoints,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'totalPoints': totalPoints,
    };
  }

  factory LeaderboardModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return LeaderboardModel(
      userId: data['userId'],
      name: data['name'],
      totalPoints: data['totalPoints'],
    );
  }
}
