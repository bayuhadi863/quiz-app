import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants/colors.dart';

Container trendingQuizCard(
  String quizName,
  int playersCount,
  String categoryImage,
) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey[300]!),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quizName,
                style: const TextStyle(
                  color: MyColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                "$playersCount players worldwide",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: MyColors.secondary, // Warna teks putih
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Border radius 10
                  ),
                  minimumSize:
                      const Size(100, 32), // Lebar dan tinggi minimum 100x60
                ),
                child: const Text('Play now!'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: categoryImage == 'kosong'
              ? const Text('...')
              : Image.asset(
                  'assets/images/$categoryImage',
                  width: 60,
                  height: 60,
                ),
        ),
      ],
    ),
  );
}
