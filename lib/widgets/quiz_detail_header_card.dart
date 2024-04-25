import 'package:flutter/material.dart';
import 'package:quiz_app/utils/constants/colors.dart';

Container quizDetailHeaderCard(String image) {
  return Container(
    decoration: BoxDecoration(
      color: MyColors.primary,
      borderRadius: BorderRadius.circular(15),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Center(
      child: Image.asset(
        'assets/images/$image',
        width: 60,
        height: 60,
      ),
    ),
  );
}
