import 'package:flutter/material.dart';

@immutable
class AppConfig {
  static const String baseUrl = "http://10.0.2.2:8080/it4788";
  static const bool useMockData = false;
  static const bool logging = true;
  static const int defaultTimeOut = 5; //In Seconds
}