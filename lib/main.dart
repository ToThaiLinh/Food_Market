import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/services/meal_plan_service.dart';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'bloc/meal_plan/meal_plan_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);

  runApp(const FoodyMartApp());
}

class FoodyMartApp extends StatelessWidget {
  const FoodyMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: BlocProvider(
          create: (context) => MealPlanBloc(MealPlanService()),
          child: MaterialApp(
            title: 'Foody Mart',
            theme: ThemeData(
              primaryColor: Colors.orange,
            ),
            home: const LoginPage(),
          ),
        ));
  }
}

// import 'dart:async';
//
// import 'package:intl/intl.dart';
//
// import 'services/meal_plan_service.dart';
// import 'models/plan.dart';
//
// void main() async {
//   // Tạo một instance của MealPlanService
//   MealPlanService mealPlanService = MealPlanService();
//
//   // Thông tin cần thiết để tạo meal plan
//   String foodName = "Chicken";
//   String timestamp = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Sử dụng thời gian hiện tại
//   String name = "lunch";
//
//   try {
//     // Gọi hàm createMealPlan từ service
//     MealPlan? mealPlan = await mealPlanService.createMealPlan(
//       foodName: foodName,
//       timestamp: timestamp,
//       name: name,
//     );
//
//     // In thông tin meal plan được tạo ra
//     print("Meal Plan created successfully:");
//     print("Name: ${mealPlan!.name}");
//     print("Food Name: ${mealPlan.food?.name}");
//     print("Timestamp: ${mealPlan.timestamp}");
//   } catch (e) {
//     // Xử lý lỗi nếu có
//     print("Error creating meal plan: $e");
//   }
// }
