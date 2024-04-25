import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuizPage extends StatefulWidget {
  const AddQuizPage({super.key});

  @override
  State<AddQuizPage> createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Quiz'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Add Quiz Page'),
            ElevatedButton(
              onPressed: () async {
                final FirebaseFirestore db = FirebaseFirestore.instance;
                final quizzes = db.collection("quizzes");
                final data = <String, dynamic>{
                  "name":
                      "Kuis Laravel: Uji Pengetahuan Anda tentang Framework PHP Populer",
                  "description":
                      "Selamat datang dalam kuis tentang Laravel! Apakah Anda seorang pengembang web yang tertarik dengan salah satu framework PHP paling populer di dunia? Uji pengetahuan Anda tentang konsep dasar, fitur, dan ekosistem Laravel dengan kuis ini. Siapkan diri Anda untuk tantangan!",
                  "language": "ID",
                  "category": "Technology",
                  "totalPoints": 100,
                  "duration": 15,
                  "playersCount": 0,
                  "questions": [
                    {
                      "question": "Siapakah pencipta Laravel?",
                      "answers": [
                        "Taylor Otwell",
                        "Jeffrey Way",
                        "Evan You",
                        "Matt Stauffer"
                      ],
                      "points": 10,
                      "correctAnswer": ["Taylor Otwell", "Jeffrey Way"]
                    },
                    {
                      "question":
                          "Apa yang menjadi filosofi utama di balik Laravel?",
                      "answers": [
                        "Simplicity",
                        "Complexity",
                        "Clarity",
                        "Consistency"
                      ],
                      "points": 10,
                      "correctAnswer": ["Simplicity", "Clarity"]
                    },
                    {
                      "question":
                          "Apa nama sistem template bawaan yang digunakan oleh Laravel?",
                      "answers": ["Blade", "Smarty", "Twig", "EJS"],
                      "points": 10,
                      "correctAnswer": ["Blade", "Smarty"]
                    },
                    {
                      "question":
                          "Apa nama ORM (Object-Relational Mapping) yang digunakan oleh Laravel secara default?",
                      "answers": [
                        "Eloquent",
                        "Doctrine",
                        "Propel",
                        "Hibernate"
                      ],
                      "points": 10,
                      "correctAnswer": ["Eloquent", "Doctrine"]
                    },
                    {
                      "question":
                          "Apa perintah yang digunakan untuk membuat migrasi database baru?",
                      "answers": [
                        "php artisan migrate",
                        "php artisan make:migration",
                        "php artisan new:migration",
                        "php migrate:make"
                      ],
                      "points": 10,
                      "correctAnswer": [
                        "php artisan make:migration",
                        "php artisan migrate"
                      ]
                    },
                    {
                      "question":
                          "Apa nama fitur Laravel yang digunakan untuk mengelola sistem otentikasi?",
                      "answers": [
                        "Passport",
                        "Authenticator",
                        "Guardian",
                        "Sentry"
                      ],
                      "points": 10,
                      "correctAnswer": ["Passport", "Authenticator"]
                    },
                    {
                      "question":
                          "Apa yang dimaksud dengan 'Middleware' dalam konteks Laravel?",
                      "answers": [
                        "Fungsi untuk mengubah URL",
                        "Lapisan yang ditempatkan di antara permintaan dan respons HTTP",
                        "Paket kode pihak ketiga",
                        "Kelas yang mengatur routing"
                      ],
                      "points": 10,
                      "correctAnswer": [
                        "Lapisan yang ditempatkan di antara permintaan dan respons HTTP",
                        "Kelas yang mengatur routing"
                      ]
                    },
                    {
                      "question":
                          "Apa nama dependency injection container yang digunakan oleh Laravel?",
                      "answers": [
                        "PicoContainer",
                        "Spring",
                        "Guice",
                        "Illuminate Container"
                      ],
                      "points": 10,
                      "correctAnswer": ["Illuminate Container", "PicoContainer"]
                    },
                    {
                      "question":
                          "Apa yang dimaksud dengan 'Eloquent ORM' dalam Laravel?",
                      "answers": [
                        "Nama panggilan untuk konfigurasi database",
                        "Lapisan untuk mengelola antrian pekerjaan",
                        "Metode untuk membuat tampilan",
                        "Sistem untuk berinteraksi dengan database"
                      ],
                      "points": 10,
                      "correctAnswer": [
                        "Sistem untuk berinteraksi dengan database",
                        "Lapisan untuk mengelola antrian pekerjaan"
                      ]
                    },
                    {
                      "question":
                          "Apa nama fitur Laravel yang digunakan untuk mengelola pengiriman email?",
                      "answers": ["Mailer", "SwiftMailer", "Mailgun", "Mail"],
                      "points": 10,
                      "correctAnswer": ["Mail", "SwiftMailer"]
                    }
                  ]
                };
                await quizzes.add(data);
              },
              child: const Text('Add Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
