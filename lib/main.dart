import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food/ui/pages/login/login_page.dart';

void main() {
  runApp(FoodyMartApp());
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
        home: LoginPage(),
      ),
    );
  }
}
