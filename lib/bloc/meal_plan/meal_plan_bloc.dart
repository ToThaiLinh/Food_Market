// blocs/meal_plan_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/plan.dart';
import '../../services/meal_plan_service.dart';
import 'meal_plan_event.dart';
import 'meal_plan_state.dart';

class MealPlanBloc extends Bloc<MealPlanEvent, MealPlanState> {
  final MealPlanService _mealPlanService;
  List<MealPlan> _mealPlans = [];

  MealPlanBloc(this._mealPlanService) : super(MealPlanInitial()) {
    on<CreateMealPlan>(_onCreateMealPlan);
    on<UpdateMealPlan>(_onUpdateMealPlan);
    on<DeleteMealPlan>(_onDeleteMealPlan);
    on<GetMealPlansByDate>(_onGetMealPlansByDate);
    on<AddMealPlan>(_onAddMealPlan);
  }

  Future<void> _onCreateMealPlan(
      CreateMealPlan event,
      Emitter<MealPlanState> emit,
      ) async {
    try {
      emit(MealPlanLoading());
      final mealPlan = await _mealPlanService.createMealPlan(
        foodName: event.foodName,
        timestamp: event.timestamp,
        name: event.name,
      );
      if (mealPlan == null) {
        emit(MealPlanError("Không có food trong csdl"));
      } else {
        emit(MealPlanCreated(mealPlan));
      }
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onUpdateMealPlan(
      UpdateMealPlan event,
      Emitter<MealPlanState> emit,
      ) async {
    try {
      emit(MealPlanLoading());
      final mealPlan = await _mealPlanService.updateMealPlan(
        planId: event.planId,
        newFoodName: event.newFoodName,
        newName: event.newName,
      );
      emit(MealPlanUpdated(mealPlan));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onDeleteMealPlan(
      DeleteMealPlan event,
      Emitter<MealPlanState> emit,
      ) async {
    try {
      emit(MealPlanLoading());
      final message = await _mealPlanService.deleteMealPlan(
        planId: event.planId,
      );
      emit(MealPlanDeleted(message));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onGetMealPlansByDate(
      GetMealPlansByDate event,
      Emitter<MealPlanState> emit,
      ) async {
    try {
      emit(MealPlanLoading());
      final mealPlans = await _mealPlanService.getMealPlanByDate(
        date: event.date,
      );
      emit(MealPlansLoaded(mealPlans));
    } catch (e) {
      emit(MealPlanError(e.toString()));
    }
  }

  Future<void> _onAddMealPlan(
      AddMealPlan event,
      Emitter<MealPlanState> emit,
      ) async {
    // Thêm món ăn vào danh sách
    final newMealPlan = MealPlan(
      id: event.dish['id'] ?? '', // Cung cấp giá trị mặc định nếu id là null
      name: event.dish['name'] ?? 'Không có tên', // Cung cấp giá trị mặc định nếu name là null
      mealType: event.mealType, // mealType không nên null nếu được truyền từ dialog
      timestamp: '', // Cung cấp giá trị mặc định hoặc lấy từ event nếu cần
      status: '', // Cung cấp giá trị mặc định hoặc lấy từ event nếu cần
      userId: '', // Cung cấp giá trị mặc định hoặc lấy từ event nếu cần
    );

    _mealPlans.add(newMealPlan); // Cập nhật danh sách món ăn
    emit(MealPlansLoaded(_mealPlans)); // Cập nhật trạng thái
  }
}