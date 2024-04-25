import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/leaderboard_model.dart';

class LeaderboardRepository {
  // Singleton instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Insert to leaderboard collection
  Future<void> insertLeaderboard(LeaderboardModel leaderboard) async {
    try {
      await _db.collection('leaderboard').add(leaderboard.toJson());
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again $e';
    }
  }

  // Update leaderboard data where field userId equal to userId
  Future<void> updateLeaderboard(
      String userId, LeaderboardModel leaderboard) async {
    try {
      await _db
          .collection('leaderboard')
          .where('userId', isEqualTo: userId)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.update(leaderboard.toJson());
        }
      });
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again $e';
    }
  }

  // Fetch list of leaderboard data order by totalPoints
  Future<List<LeaderboardModel>> fetchLeaderboardData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('leaderboard')
          .orderBy('totalPoints', descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                LeaderboardModel.fromSnapshot(e))
            .toList();
      } else {
        return [];
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again $e';
    }
  }

  // Fetch totalPoints where field userId equal to userId
  Future<int> fetchTotalPoints(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('leaderboard')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('totalPoints');
      } else {
        return 0;
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again $e';
    }
  }

}
