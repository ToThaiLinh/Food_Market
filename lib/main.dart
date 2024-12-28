import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/ui/pages/login/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await initializeDateFormatting('vi_VN', null);

  DartPluginRegistrant.ensureInitialized();
  await Future.delayed(const Duration(seconds: 1));
  runApp(const FoodyMartApp());
}

class FoodyMartApp extends StatelessWidget {
  const FoodyMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Foody Mart',
        theme: ThemeData(
          primaryColor: Colors.orange,
        ),
        // home: const LoginPage(),
        routes: {
          '/login_page': (context) => const LoginPage(),
          // Bạn có thể thêm các route khác ở đây nếu cần
        },
        initialRoute: '/login_page',
      ),
    );
  }
}
