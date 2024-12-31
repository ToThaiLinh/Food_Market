// events/meal_plan_event.dart
abstract class MealPlanEvent {}

class CreateMealPlan extends MealPlanEvent {
  final String foodName;
  final String timestamp;
  final String name;

  CreateMealPlan({
    required this.foodName,
    required this.timestamp,
    required this.name,
  });
}

class AddMealPlan extends MealPlanEvent {
  final Map<String, dynamic> dish;
  final String mealType;

  AddMealPlan({required this.dish, required this.mealType});
}

class UpdateMealPlan extends MealPlanEvent {
  final String planId;
  final String newFoodName;
  final String newName;

  UpdateMealPlan({
    required this.planId,
    required this.newFoodName,
    required this.newName,
  });
}

class DeleteMealPlan extends MealPlanEvent {
  final String planId;

  DeleteMealPlan({required this.planId});
}

class GetMealPlansByDate extends MealPlanEvent {
  final String date;

  GetMealPlansByDate({required this.date});
}
