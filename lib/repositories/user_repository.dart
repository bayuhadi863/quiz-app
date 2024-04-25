import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/leaderboard_model.dart';
import 'package:quiz_app/models/user_model.dart';
import 'package:quiz_app/repositories/authentication_repository.dart';
import 'package:quiz_app/repositories/leaderboard_repository.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("users").doc(user.id).set(user.toJson());

      // Leaderboard object
      final LeaderboardModel leaderboard = LeaderboardModel(
        userId: user.id,
        name: user.name,
        totalPoints: 0,
      );

      // insert initial leaderboard data
      await LeaderboardRepository().insertLeaderboard(leaderboard);
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        throw UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Update name field in user document
  Future<void> updateName(String name) async {
    try {
      await _db
          .collection("users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update({'name': name});
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Fetch users by id
  Future<UserModel> fetchUserById(String userId) async {
    try {
      final documentSnapshot =
          await _db.collection("users").doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        throw UserModel.empty();
      }
    } on FirebaseException catch (e) {
      throw e.code;
    } on FormatException catch (_) {
      throw 'Format exeption error';
    } on PlatformException catch (e) {
      throw e.code;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
