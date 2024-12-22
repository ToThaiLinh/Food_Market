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

// import 'package:food/services/meal_plan_service.dart';
//
// import '../models/plan.dart';
//
// void main() async {
//   MealPlanService mealPlanService = MealPlanService();
//
//   // Ngày cần lấy dữ liệu
//   String date = "12/2/2024";
//
//   try {
//     // Gọi phương thức getMealPlanByDate
//     List<MealPlan> mealPlans = await mealPlanService.getMealPlanByDate(date: date);
//
//     // In ra console danh sách MealPlan
//     print("Meal plans for date $date:");
//     for (var plan in mealPlans) {
//       print("Name: ${plan.name}, Food: ${plan.food.name}, Timestamp: ${plan.timestamp}");
//     }
//   } catch (e) {
//     // In ra lỗi nếu xảy ra
//     print("Lỗi rồi : $e");
//   }
// }
