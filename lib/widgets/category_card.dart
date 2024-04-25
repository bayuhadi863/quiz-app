import 'package:flutter/material.dart';
import 'package:quiz_app/models/category_model.dart';
import 'package:quiz_app/pages/quiz/category_quizzes_page.dart';
import 'package:quiz_app/utils/constants/colors.dart';

GestureDetector categoryCard(
    CategoryModel category, BuildContext context, VoidCallback onTap) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CategoryQuizzesPage(categoryName: category.name),
        ),
      ).then((value) => null);
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
              'assets/images/${category.image}',
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 15),
            Text(
              category.name,
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
}
