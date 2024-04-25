import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/models/quiz_model.dart';

class QuizRepository {
  // Singleton instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch all quizzes
  Future<List<QuizModel>> fetchAllQuizzes() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('quizzes').get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                QuizModel.fromSnapshot(e))
            .toList();
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Get quizzes by category name
  Future<List<QuizModel>> getQuizzesByCategoryName(String categoryName) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection("quizzes")
          .where('category',
              isEqualTo: categoryName) // Gunakan parameter categoryName
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                QuizModel.fromSnapshot(e))
            .toList();
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Insert user points to userPoints collection
  Future<void> insertUserPoints(UserPointModel userPoint) async {
    try {
      await _db.collection('userPoints').add(userPoint.toJson());

      /// Update leaderboard data
      /// Get leaderboard data where field userId equal to userPoint.userId
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('leaderboard')
          .where('userId', isEqualTo: userPoint.userId)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        // Update leaderboard data
        await _db
            .collection('leaderboard')
            .doc(querySnapshot.docs.first.id)
            .update({
          'totalPoints': FieldValue.increment(userPoint.points),
        });

        // Update quiz playersCount field
        await _db.collection('quizzes').doc(userPoint.quizId).update({
          'playersCount': FieldValue.increment(1),
        });
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
        throw 'Leaderboard data not found';
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

  // Fetch quiz by quizId
  Future<QuizModel> fetchQuizById(String quizId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _db.collection('quizzes').doc(quizId).get();

      if (documentSnapshot.exists) {
        return QuizModel.fromSnapshot(documentSnapshot);
      } else {
        throw 'Quiz not found';
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

  // Fetch all userPoints
  Future<List<UserPointModel>> fetchAllUserPoints() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _db.collection('userPoints').get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                UserPointModel.fromSnapshot(e))
            .toList();
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Fetch userPoints by quizId
  Future<List<UserPointModel>> fetchUserPointsByQuizId(String quizId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('userPoints')
          .where('quizId', isEqualTo: quizId)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                UserPointModel.fromSnapshot(e))
            .toList();
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Fetch userPoints data current day
  Future<List<UserPointModel>> fetchCurrentDayUserPoints() async {
    try {
      final DateTime now = DateTime.now();
      final DateTime startOfDay = DateTime(now.year, now.month, now.day);
      final DateTime endOfDay =
          DateTime(now.year, now.month, now.day, 23, 59, 59);

      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('userPoints')
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThanOrEqualTo: endOfDay)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                UserPointModel.fromSnapshot(e))
            .toList();
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Fetch the most played quiz
  Future<QuizModel> fetchMostPlayedQuiz() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('quizzes')
          .orderBy('playersCount', descending: true)
          .limit(1)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return QuizModel.fromSnapshot(querySnapshot.docs.first);
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
        throw 'Quiz not found';
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

  // Fetch number of quiz played by userId
  Future<int> fetchNumberOfQuizPlayed(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('userPoints')
          .where('userId', isEqualTo: userId)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.length;
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Fetch userPoints where quizId equal to quizId and userId equal to userId
  Future<UserPointModel> fetchUserPointByQuizIdAndUserId(
      String quizId, String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('userPoints')
          .where('quizId', isEqualTo: quizId)
          .where('userId', isEqualTo: userId)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return UserPointModel.fromSnapshot(querySnapshot.docs.first);
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
        throw 'UserPoint not found';
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

  // Check if user has played the quiz
  Future<bool> hasUserPlayedQuiz(String quizId, String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('userPoints')
          .where('quizId', isEqualTo: quizId)
          .where('userId', isEqualTo: userId)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
        return false;
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

  // Insert quiz to favorite quizzes
  Future<void> insertFavoriteQuiz(FavoriteQuizModel favoriteQuiz) async {
    try {
      await _db.collection('favoriteQuizzes').add(favoriteQuiz.toJson());
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

  // Fetch favorite quizzes by userId
  Future<List<FavoriteQuizModel>> fetchFavoriteQuizzesByUserId(
      String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db
          .collection('favoriteQuizzes')
          .where('userId', isEqualTo: userId)
          .get();

      // Periksa apakah querySnapshot.docs tidak null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                FavoriteQuizModel.fromSnapshot(e))
            .toList();
      } else {
        // Jika tidak ada dokumen yang cocok, kembalikan daftar kosong
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

  // Delete favorite quiz by favoriteQuizId
  Future<void> deleteFavoriteQuiz(String? favoriteQuizId) async {
    try {
      await _db.collection('favoriteQuizzes').doc(favoriteQuizId).delete();
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
