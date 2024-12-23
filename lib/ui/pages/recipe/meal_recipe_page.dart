import 'package:flutter/material.dart';

class MealRecipePage extends StatelessWidget {
  final String mealName;
  final String recipeDetails;
  final String cookingTime;

  const MealRecipePage({
    Key? key,
    required this.mealName,
    required this.recipeDetails,
    required this.cookingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mealName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mealName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Công thức: $recipeDetails',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Thời gian nấu: $cookingTime',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}