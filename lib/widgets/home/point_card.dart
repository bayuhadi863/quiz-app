import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quiz_app/utils/constants/colors.dart';

Container pointCard(
    String title, int points, int maxPoints, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: MyColors.primary,
      borderRadius: BorderRadius.circular(15),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/images/coin.png',
                width: 40,
                height: 40,
              ),
            )
          ],
        ),
        Row(
          children: [
            Image.asset(
              'assets/images/coin.png',
              width: 14,
              height: 14,
            ),
            const SizedBox(width: 10),
            Text(
              "+${points.toString()} daily points",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 75,
                lineHeight: 13.0,
                percent: points / maxPoints,
                barRadius: const Radius.circular(10),
                progressColor: MyColors.secondary,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}
