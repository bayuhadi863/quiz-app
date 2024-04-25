import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  final String id;
  String name;
  String description;
  String category;
  String language;
  int totalPoints;
  int duration;
  List<QuestionModel> questions;
  int playersCount;

  QuizModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.language,
    required this.totalPoints,
    required this.duration,
    required this.questions,
    required this.playersCount,
  });

  static QuizModel empty() => QuizModel(
        id: '',
        name: '',
        description: '',
        category: '',
        language: '',
        totalPoints: 0,
        duration: 0,
        questions: [],
        playersCount: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'language': language,
      'totalPoints': totalPoints,
      'duration': duration,
      'questions': questions.map((e) => e.toJson()).toList(),
      'playersCount': playersCount,
    };
  }

  factory QuizModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return QuizModel(
      id: documentSnapshot.id,
      name: data['name'],
      description: data['description'],
      category: data['category'],
      language: data['language'],
      totalPoints: data['totalPoints'],
      duration: data['duration'],
      questions: data['questions'] == null
          ? []
          : List<QuestionModel>.from(
              data['questions'].map(
                (e) => QuestionModel(
                  question: e['question'],
                  answers: List<String>.from(e['answers']),
                  points: e['points'],
                  correctAnswer: e['correctAnswer'],
                ),
              ),
            ),
      playersCount: data['playersCount'],
    );
  }
}

class QuestionModel {
  String question;
  List<String> answers;
  int points;
  dynamic correctAnswer; // Mengubah tipe data menjadi dynamic

  static QuestionModel empty() => QuestionModel(
        question: '',
        answers: [],
        points: 0,
        correctAnswer: '',
      );

  QuestionModel({
    required this.question,
    required this.answers,
    required this.points,
    required this.correctAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
      'points': points,
      'correctAnswer': correctAnswer,
    };
  }
}

class UserPointModel {
  String quizId;
  String userId;
  int points;
  DateTime createdAt;

  UserPointModel({
    required this.userId,
    required this.points,
    required this.quizId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'userId': userId,
      'points': points,
      'createdAt': createdAt,
    };
  }

  factory UserPointModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return UserPointModel(
      userId: data['userId'],
      points: data['points'],
      quizId: data['quizId'],
      createdAt: data['createdAt'].toDate(),
    );
  }
}

class FavoriteQuizModel {
  final String? id;
  String quizId;
  String userId;
  DateTime createdAt;

  FavoriteQuizModel({
    this.id,
    required this.userId,
    required this.quizId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'userId': userId,
      'createdAt': createdAt,
    };
  }

  factory FavoriteQuizModel.fromSnapshot(DocumentSnapshot documentSnapshot) {
    final data = documentSnapshot.data() as Map<String, dynamic>;
    return FavoriteQuizModel(
      id: documentSnapshot.id,
      userId: data['userId'],
      quizId: data['quizId'],
      createdAt: data['createdAt'].toDate(),
    );
  }
}
