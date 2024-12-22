// states/meal_plan_state.dart
import '../../models/plan.dart';

abstract class MealPlanState {}

class MealPlanInitial extends MealPlanState {}

class MealPlanLoading extends MealPlanState {}

class MealPlansLoaded extends MealPlanState {
  final List<MealPlan> mealPlans;
  MealPlansLoaded(this.mealPlans);
}

class MealPlanCreated extends MealPlanState {
  final MealPlan mealPlan;
  MealPlanCreated(this.mealPlan);
}

class MealPlanUpdated extends MealPlanState {
  final MealPlan mealPlan;
  MealPlanUpdated(this.mealPlan);
}

class MealPlanDeleted extends MealPlanState {
  final String message;
  MealPlanDeleted(this.message);
}

class MealPlanError extends MealPlanState {
  final String message;
  MealPlanError(this.message);
}